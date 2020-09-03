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
extension ProductsViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void> 
        let loadMoreTrigger: Driver<Void>
        let selectProductTrigger: Driver<IndexPath>
        let editProductTrigger: Driver<IndexPath>
        let deleteProductTrigger: Driver<IndexPath>
    }

    struct Output {
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isReloading = false
        @Property var isLoadingMore = false
        @Property var productList = [ProductItemViewModel]()
        @Property var isEmpty = false
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let activityIndicator = PageActivityIndicator()
        let isLoading = activityIndicator.isLoading
        let isReloading = activityIndicator.isReloading
        
        let errorTracker = ErrorTracker()
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        activityIndicator.isLoadingMore
            .drive(output.$isLoadingMore)
            .disposed(by: disposeBag)
        
        errorTracker.asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        let pageSubject = BehaviorRelay(value: PagingInfo<ProductModel>(page: 1, items: []))
        let updatedProductSubject = PublishSubject<Void>()
        
        let getPageInput = GetPageInput(
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
        
        let getPageResult = getPage(input: getPageInput)
        
        let page = Driver.merge(
            getPageResult.page,
            updatedProductSubject
                .asDriverOnErrorJustComplete()
                .withLatestFrom(pageSubject.asDriver())
        )

        let productList = page
            .map { $0.items }
        
        productList
            .map { products in products.map(ProductItemViewModel.init) }
            .drive(output.$productList)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectProductTrigger, items: productList)
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .drive()
            .disposed(by: disposeBag)
        
        select(trigger: input.editProductTrigger, items: productList)
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
            .drive()
            .disposed(by: disposeBag)

        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                           items: productList)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        select(trigger: input.deleteProductTrigger, items: productList)
            .map { $0.product }
            .flatMapLatest { product -> Driver<Product> in
                return self.navigator.confirmDeleteProduct(product)
                    .map { product }
            }
            .flatMapLatest { product -> Driver<Product> in
                return self.useCase.deleteProduct(dto: DeleteProductDto(id: product.id))
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
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}

