//
// ProductsNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ProductsNavigatorType {
    func toProducts()
    func toProductDetail(product: Product)
    func toEditProduct(_ product: Product) -> Driver<EditProductDelegate>
    func confirmDeleteProduct(_ product: Product) -> Driver<Void>
}

struct ProductsNavigator: ProductsNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toProducts() {
        let vc = ProductsViewController.instantiate()
        let vm = ProductsViewModel(navigator: self, useCase: ProductsUseCase())
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func toProductDetail(product: Product) {
        let navigator = ProductDetailNavigator(navigationController: navigationController)
        navigator.toProductDetail(product: product)
    }
    
    func toEditProduct(_ product: Product) -> Driver<EditProductDelegate> {
        let vc = EditProductViewController.instantiate()
        let nav = UINavigationController(rootViewController: vc)
        let navigator = EditProductNavigator(navigationController: nav)
        let delegate = PublishSubject<EditProductDelegate>()
        let vm = EditProductViewModel(navigator: navigator,
            useCase: EditProductUseCase(),
            product: product,
            delegate: delegate)
        vc.bindViewModel(to: vm)
        navigationController.present(nav, animated: true, completion: nil)
        return delegate.asDriverOnErrorJustComplete()
    }
    
    func confirmDeleteProduct(_ product: Product) -> Driver<Void> {
        return Observable<Void>.create({ (observer) -> Disposable in
            let alert = UIAlertController(
                title: "Delete product: " + product.name,
                message: "Are you sure?",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "Delete",
                style: .destructive) { _ in
                    observer.onNext(())
                    observer.onCompleted()
            }
            alert.addAction(okAction)
            
            let cancel = UIAlertAction(title: "Cancel",
                                       style: UIAlertActionStyle.cancel) { (_) in
                                        observer.onCompleted()
            }
            alert.addAction(cancel)
            self.navigationController.present(alert, animated: true, completion: nil)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        })
        .asDriverOnErrorJustComplete()
    }
}

