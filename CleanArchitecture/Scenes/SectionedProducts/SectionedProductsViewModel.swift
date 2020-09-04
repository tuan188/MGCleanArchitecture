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

// MARK: - ViewModel
extension SectionedProductsViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectProductTrigger: Driver<IndexPath>
        let editProductTrigger: Driver<IndexPath>
        let updatedProductTrigger: Driver<Product>
    }

    struct Output {
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isReloading = false
        @Property var isLoadingMore = false
        @Property var productSections = [ProductViewModelSection]()
        @Property var isEmpty = false
    }

    struct ProductSection {
        let header: String
        let productList: [ProductModel]
    }
    
    struct ProductViewModelSection {
        let header: String
        let productList: [ProductItemViewModel]
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let activityIndicator = PageActivityIndicator()
        let isLoading = activityIndicator.isLoading
        let isReloading = activityIndicator.isReloading
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        activityIndicator.isLoadingMore
            .drive(output.$isLoadingMore)
            .disposed(by: disposeBag)
        
        let errorTracker = ErrorTracker()
        errorTracker
            .asDriver()
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

        let productSections = page
            .map { $0.items }
            .map { [ProductSection(header: "Section1", productList: $0)] }
        
        productSections
            .map {
                return $0.map { section in
                    return ProductViewModelSection(header: section.header,
                                                   productList: section.productList.map(ProductItemViewModel.init))
                }
            }
            .drive(output.$productSections)
            .disposed(by: disposeBag)
            
        input.selectProductTrigger
            .withLatestFrom(productSections) {
                return ($0, $1)
            }
            .map { indexPath, productSections -> ProductModel in
                return productSections[indexPath.section].productList[indexPath.row]
            }
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .drive()
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                           items: productSections)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        input.editProductTrigger
            .withLatestFrom(productSections) { indexPath, productSections -> Product in
                return productSections[indexPath.section].productList[indexPath.row].product
            }
            .do(onNext: self.navigator.toEditProduct)
            .drive()
            .disposed(by: disposeBag)
        
        input.updatedProductTrigger
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
            .drive()
            .disposed(by: disposeBag)

        return output
    }
}

