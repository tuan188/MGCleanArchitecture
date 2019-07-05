//
//  SectionedProductsViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/11/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

struct SectionedProductsViewModel {
    let navigator: SectionedProductsNavigatorType
    let useCase: SectionedProductsUseCaseType
}

// MARK: - ViewModelType
extension SectionedProductsViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectProductTrigger: Driver<IndexPath>
        let editProductTrigger: Driver<IndexPath>
        let updatedProductTrigger: Driver<Product>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let fetchItems: Driver<Void>
        let productSections: Driver<[ProductSection]>
        let selectedProduct: Driver<Void>
        let isEmpty: Driver<Bool>
        let editedProduct: Driver<Void>
        let updatedProduct: Driver<Void>
    }

    struct ProductSection {
        let header: String
        let productList: [ProductModel]
    }

    func transform(_ input: Input) -> Output {
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

        let productSections = page
            .map { $0.items.map { $0 } }
            .map { [ProductSection(header: "Section1", productList: $0)] }
            .asDriverOnErrorJustComplete()
        
        let selectedProduct = input.selectProductTrigger
            .withLatestFrom(productSections) {
                return ($0, $1)
            }
            .map { params -> ProductModel in
                let (indexPath, productSections) = params
                return productSections[indexPath.section].productList[indexPath.row]
            }
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(fetchItemsTrigger: fetchItems,
                                         loadTrigger: Driver.merge(isLoading, isReloading),
                                         items: productSections)
        
        let editedProduct = input.editProductTrigger
            .withLatestFrom(productSections) { indexPath, productSections -> Product in
                return productSections[indexPath.section].productList[indexPath.row].product
            }
            .do(onNext: self.navigator.toEditProduct)
            .mapToVoid()
        
        let updatedProduct = input.updatedProductTrigger
            .do(onNext: { product in
                var productList = page.value.items
                let productModel = ProductModel(product: product, edited: true)
                
                if let index = productList.firstIndex(of: productModel) {
                    productList[index] = productModel
                    let updatedPage = PagingInfo(page: page.value.page, items: productList)
                    page.accept(updatedPage)
                }
            })
            .mapToVoid()

        return Output(
            error: loadError,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            fetchItems: fetchItems,
            productSections: productSections,
            selectedProduct: selectedProduct,
            isEmpty: isEmpty,
            editedProduct: editedProduct,
            updatedProduct: updatedProduct
        )
    }
}

