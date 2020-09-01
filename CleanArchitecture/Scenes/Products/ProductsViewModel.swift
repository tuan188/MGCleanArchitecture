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
        let productList: Driver<[ProductViewModel]>
        let selectedProduct: Driver<Void>
        let editedProduct: Driver<Void>
        let isEmpty: Driver<Bool>
        let deletedProduct: Driver<Void>
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

        let productList = page
            .map { $0.items }
        
        let productViewModelList = productList
            .map { $0.map(ProductViewModel.init) }
        
        let selectedProduct = select(trigger: input.selectProductTrigger, items: productList)
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .mapToVoid()
        
        let editedProduct = select(trigger: input.editProductTrigger, items: productList)
            .map { $0.product }
            .flatMapLatest { product -> Driver<EditProductDelegate> in
                self.navigator.toEditProduct(product)
            }
            .do(onNext: { delegate in
                switch delegate {
                case .updatedProduct(let product):
                    let page = pageSubject.value
                    var productList = page.items
                    let productModel = ProductModel(product: product, edited: true)
                    
                    if let index = productList.firstIndex(of: productModel) {
                        productList[index] = productModel
                        let updatedPage = PagingInfo(page: page.page, items: productList)
                        pageSubject.accept(updatedPage)
                        updatedProductSubject.onNext(())
                    }
                }
            })
            .mapToVoid()

        let isEmpty = checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                                         items: productList)
        
        let deletedProduct = select(trigger: input.deleteProductTrigger, items: productList)
            .map { $0.product }
            .flatMapLatest { product -> Driver<Product> in
                return self.navigator.confirmDeleteProduct(product)
                    .map { product }
            }
            .flatMapLatest { product -> Driver<Product> in
                return self.useCase.deleteProduct(id: product.id)
                    .trackActivity(activityIndicator.loadingIndicator)
                    .trackError(errorTracker)
                    .map { _ in product }
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { product in
                let page = pageSubject.value
                
                var productList = page.items
                productList.removeAll { $0.product.id == product.id }
                
                let updatedPage = PagingInfo(page: page.page, items: productList)
                pageSubject.accept(updatedPage)
            })
            .mapToVoid()

        return Output(
            error: error,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadingMore: isLoadingMore,
            productList: productViewModelList,
            selectedProduct: selectedProduct,
            editedProduct: editedProduct,
            isEmpty: isEmpty,
            deletedProduct: deletedProduct
        )
    }
}

