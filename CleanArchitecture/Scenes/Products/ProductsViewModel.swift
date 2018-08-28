//
// ProductsViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct ProductsViewModel: ViewModelType {
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
        let loading: Driver<Bool>
        let refreshing: Driver<Bool>
        let loadingMore: Driver<Bool>
        let fetchItems: Driver<Void>
        let productList: Driver<[ProductModel]>
        let selectedProduct: Driver<Void>
        let editedProduct: Driver<Void>
        let isEmptyData: Driver<Bool>
        let deletedProduct: Driver<Void>
    }

    struct ProductModel {
        let product: Product
    }

    let navigator: ProductsNavigatorType
    let useCase: ProductsUseCaseType

    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let loadMoreOutput = setupLoadMorePaging(
            loadTrigger: input.loadTrigger,
            getItems: useCase.getProductList,
            refreshTrigger: input.reloadTrigger,
            refreshItems: useCase.getProductList,
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: useCase.loadMoreProductList)
        let (page, fetchItems, loadError, loading, refreshing, loadingMore) = loadMoreOutput

        let productList = page
            .map { $0.items.map { ProductModel(product: $0) } }
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
                    let productList = page.value.items
                    if let index = productList.index(of: product) {
                        productList[index] = product
                        let updatedPage = PagingInfo(page: page.value.page, items: productList)
                        page.accept(updatedPage)
                    }
                }
            })
            .mapToVoid()

        let isEmptyData = Driver.combineLatest(fetchItems, loading)
            .filter { !$0.1 }
            .withLatestFrom(productList)
            .map { $0.isEmpty }
        
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
                let productList = page.value.items
                productList.remove(product)
                let updatedPage = PagingInfo(page: page.value.page, items: productList)
                page.accept(updatedPage)
            })
            .mapToVoid()

        return Output(
            error: loadError,
            loading: loading,
            refreshing: refreshing,
            loadingMore: loadingMore,
            fetchItems: fetchItems,
            productList: productList,
            selectedProduct: selectedProduct,
            editedProduct: editedProduct,
            isEmptyData: isEmptyData,
            deletedProduct: deletedProduct
        )
    }
}

