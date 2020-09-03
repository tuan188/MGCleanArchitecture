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
        let productSections: Driver<[ProductViewModelSection]>
        let selectedProduct: Driver<Void>
        let isEmpty: Driver<Bool>
        let editedProduct: Driver<Void>
        let updatedProduct: Driver<Void>
    }

    struct ProductSection {
        let header: String
        let productList: [ProductModel]
    }
    
    struct ProductViewModelSection {
        let header: String
        let productList: [ProductItemViewModel]
    }

    func transform(_ input: Input) -> Output {
        let activityIndicator = PageActivityIndicator()
        let isLoading = activityIndicator.isLoading
        let isReloading = activityIndicator.isReloading
        let isLoadingMore = activityIndicator.isLoadingMore
        
        let errorTracker = ErrorTracker()
        let error = errorTracker.asDriver()
        
        let pageSubject = BehaviorRelay(value: PagingInfo<ProductModel>(page: 1, items: []))
        let updatedProductSubject = PublishSubject<Void>()
        
        let getPageResult = getPage(
            pageSubject: pageSubject,
            pageActivityIndicator: activityIndicator,
            errorTracker: errorTracker,
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            loadMoreTrigger: input.loadMoreTrigger,
            getItems: { _, page in
                let dto = GetPageDto().with { $0.page = page }
                return self.useCase.getProductList(dto: dto)
            },
            mapper: ProductModel.init(product:)
        )
        
        let page = Driver.merge(
            getPageResult.page,
            updatedProductSubject
                .asDriverOnErrorJustComplete()
                .withLatestFrom(pageSubject.asDriver())
        )

        let productSections = page
            .map { $0.items }
            .map { [ProductSection(header: "Section1", productList: $0)] }
        
        let productViewModelSections = productSections
            .map {
                return $0.map { section in
                    return ProductViewModelSection(header: section.header,
                                                   productList: section.productList.map(ProductItemViewModel.init))
                }
            }
            
        let selectedProduct = input.selectProductTrigger
            .withLatestFrom(productSections) {
                return ($0, $1)
            }
            .map { indexPath, productSections -> ProductModel in
                return productSections[indexPath.section].productList[indexPath.row]
            }
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .mapToVoid()
        
        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                                         items: productSections)
        
        let editedProduct = input.editProductTrigger
            .withLatestFrom(productSections) { indexPath, productSections -> Product in
                return productSections[indexPath.section].productList[indexPath.row].product
            }
            .do(onNext: self.navigator.toEditProduct)
            .mapToVoid()
        
        let updatedProduct = input.updatedProductTrigger
            .do(onNext: { product in
                let page = pageSubject.value
                var productList = page.items
                let productModel = ProductModel(product: product, edited: true)
                
                if let index = productList.firstIndex(of: productModel) {
                    productList[index] = productModel
                    let updatedPage = PagingInfo(page: page.page, items: productList)
                    pageSubject.accept(updatedPage)
                    updatedProductSubject.onNext(())
                }
            })
            .mapToVoid()

        return Output(
            error: error,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            productSections: productViewModelSections,
            selectedProduct: selectedProduct,
            isEmpty: isEmpty,
            editedProduct: editedProduct,
            updatedProduct: updatedProduct
        )
    }
}

