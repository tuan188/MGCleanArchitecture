//
//  SectionedProductsViewModel.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/11/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import RxSwift
import RxCocoa
import MGArchitecture

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
        @Property var productSections = [ProductSectionViewModel]()
        @Property var isEmpty = false
    }

    struct ProductSection {
        let header: String
        let productList: [ProductModel]
    }
    
    struct ProductSectionViewModel {
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
                return self.useCase.getProductList(page: page)
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
            .map { products -> [ProductSection] in
                var numberOfSections = Int(products.count / 10)
                let remain = products.count % 10
                
                if remain > 0 {
                    numberOfSections += 1
                }
                
                return (0...(numberOfSections - 1))
                    .map { section in
                        let sectionProducts = products.filter { Int($0.product.id / 10) == section }
                        return ProductSection(header: "Section \(section + 1)", productList: sectionProducts)
                    }
            }
        
        productSections
            .map {
                return $0.map { section in
                    return ProductSectionViewModel(header: section.header,
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
            .drive(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading),
                           items: productSections)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        input.editProductTrigger
            .withLatestFrom(productSections) { indexPath, productSections -> Product in
                return productSections[indexPath.section].productList[indexPath.row].product
            }
            .drive(onNext: self.navigator.toEditProduct)
            .disposed(by: disposeBag)
        
        input.updatedProductTrigger
            .drive(onNext: { product in
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
            .disposed(by: disposeBag)

        return output
    }
}

