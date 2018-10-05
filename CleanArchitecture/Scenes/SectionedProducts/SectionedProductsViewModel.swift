//
// SectionedProductsViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/11/18.
// Copyright © 2018 Framgia. All rights reserved.
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
        let loading: Driver<Bool>
        let refreshing: Driver<Bool>
        let loadingMore: Driver<Bool>
        let fetchItems: Driver<Void>
        let productSections: Driver<[ProductSection]>
        let selectedProduct: Driver<Void>
        let isEmptyData: Driver<Bool>
        let editedProduct: Driver<Void>
        let updatedProduct: Driver<Void>
    }

    struct ProductSection {
        let header: String
        let productList: [ProductModel]
    }

    func transform(_ input: Input) -> Output {
        let loadMoreOutput = setupLoadMorePaging(
            loadTrigger: input.loadTrigger,
            getItems: useCase.getProductList,
            refreshTrigger: input.reloadTrigger,
            refreshItems: useCase.getProductList,
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: useCase.loadMoreProductList,
            mapper: ProductModel.init(product:))
        let (page, fetchItems, loadError, loading, refreshing, loadingMore) = loadMoreOutput

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

        let isEmptyData = Driver.combineLatest(fetchItems, Driver.merge(loading, refreshing))
            .withLatestFrom(productSections) { ($0.1, $1.isEmpty) }
            .map { args -> Bool in
                let (loading, isEmpty) = args
                if loading { return false }
                return isEmpty
            }
        
        let editedProduct = input.editProductTrigger
            .withLatestFrom(productSections) { indexPath, productSections -> Product in
                return productSections[indexPath.section].productList[indexPath.row].product
            }
            .do(onNext: self.navigator.toEditProduct)
            .mapToVoid()
        
        let updatedProduct = input.updatedProductTrigger
            .do(onNext: { product in
                let productList = page.value.items
                let productModel = ProductModel(product: product, edited: true)
                if let index = productList.index(of: productModel) {
                    productList[index] = productModel
                    let updatedPage = PagingInfo(page: page.value.page, items: productList)
                    page.accept(updatedPage)
                }
            })
            .mapToVoid()

        return Output(
            error: loadError,
            loading: loading,
            refreshing: refreshing,
            loadingMore: loadingMore,
            fetchItems: fetchItems,
            productSections: productSections,
            selectedProduct: selectedProduct,
            isEmptyData: isEmptyData,
            editedProduct: editedProduct,
            updatedProduct: updatedProduct
        )
    }
}

