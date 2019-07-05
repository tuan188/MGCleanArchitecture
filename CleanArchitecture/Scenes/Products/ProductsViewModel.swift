//
//  ProductsViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct ProductsViewModel {
    let navigator: ProductsNavigatorType
    let useCase: ProductsUseCaseType
}

// MARK: - ViewModelType
extension ProductsViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectProductTrigger: Driver<IndexPath>
        let editProductTrigger: Driver<IndexPath>
        let deleteProductTrigger: Driver<IndexPath>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let fetchItems: Driver<Void>
        let productList: Driver<[ProductModel]>
        let selectedProduct: Driver<Void>
        let editedProduct: Driver<Void>
        let isEmpty: Driver<Bool>
        let deletedProduct: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let configOutput = configPagination(
            loadTrigger: input.loadTrigger,
            getItems: { _ in
                self.useCase.getProductList()
            },
            reloadTrigger: input.reloadTrigger,
            reloadItems: { _ in
                self.useCase.getProductList()
            },
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: { _, page in
                self.useCase.loadMoreProductList(page: page)
            },
            mapper: ProductModel.init(product:))
        
        let (page, fetchItems, loadError, isLoading, isReloading, isLoadingMore) = configOutput

        let productList = page
            .map { $0.items.map { $0 } }
            .asDriverOnErrorJustComplete()
        
        let selectedProduct = input.selectProductTrigger
            .withLatestFrom(productList) {
                return ($0, $1)
            }
            .map { indexPath, productList in
                return productList[indexPath.row]
            }
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .mapToVoid()
        
        let editedProduct = input.editProductTrigger
            .withLatestFrom(productList) { indexPath, products -> Product in
                return products[indexPath.row].product
            }
            .flatMapLatest { product -> Driver<EditProductDelegate> in
                self.navigator.toEditProduct(product)
            }
            .do(onNext: { delegate in
                switch delegate {
                case .updatedProduct(let product):
                    var productList = page.value.items
                    let productModel = ProductModel(product: product, edited: true)
                    
                    if let index = productList.firstIndex(of: productModel) {
                        productList[index] = productModel
                        let updatedPage = PagingInfo(page: page.value.page, items: productList)
                        page.accept(updatedPage)
                    }
                }
            })
            .mapToVoid()

        let isEmpty = checkIfDataIsEmpty(fetchItemsTrigger: fetchItems,
                                         loadTrigger: Driver.merge(isLoading, isReloading),
                                         items: productList)
        
        let deletedProduct = input.deleteProductTrigger
            .withLatestFrom(productList) { indexPath, productList in
                return productList[indexPath.row].product
            }
            .flatMapLatest { product -> Driver<Product> in
                return self.navigator.confirmDeleteProduct(product)
                    .map { product }
            }
            .flatMapLatest { product -> Driver<Product> in
                return self.useCase.deleteProduct(id: product.id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .map { _ in product }
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { product in
                var productList = page.value.items
                productList.removeAll { $0.product.id == product.id }
                let updatedPage = PagingInfo(page: page.value.page, items: productList)
                page.accept(updatedPage)
            })
            .mapToVoid()

        return Output(
            error: loadError,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            fetchItems: fetchItems,
            productList: productList,
            selectedProduct: selectedProduct,
            editedProduct: editedProduct,
            isEmpty: isEmpty,
            deletedProduct: deletedProduct
        )
    }
}

