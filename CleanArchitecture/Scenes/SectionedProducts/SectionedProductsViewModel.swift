//
// SectionedProductsViewModel.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/11/18.
// Copyright © 2018 Framgia. All rights reserved.
//

struct SectionedProductsViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectProductTrigger: Driver<IndexPath>
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
    }

    struct ProductModel {
        let product: Product
    }

    struct ProductSection {
        let header: String
        let productList: [ProductModel]
    }

    let navigator: SectionedProductsNavigatorType
    let useCase: SectionedProductsUseCaseType

    func transform(_ input: Input) -> Output {
        let loadMoreOutput = setupLoadMorePaging(
            loadTrigger: input.loadTrigger,
            getItems: useCase.getProductList,
            refreshTrigger: input.reloadTrigger,
            refreshItems: useCase.getProductList,
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: useCase.loadMoreProductList)
        let (page, fetchItems, loadError, loading, refreshing, loadingMore) = loadMoreOutput

        let productSections = page
            .map { $0.items.map { ProductModel(product: $0) } }
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

        let isEmptyData = Driver.combineLatest(fetchItems, loading)
            .filter { !$0.1 }
            .withLatestFrom(productSections)
            .map { $0.isEmpty }

        return Output(
            error: loadError,
            loading: loading,
            refreshing: refreshing,
            loadingMore: loadingMore,
            fetchItems: fetchItems,
            productSections: productSections,
            selectedProduct: selectedProduct,
            isEmptyData: isEmptyData
        )
    }
}

