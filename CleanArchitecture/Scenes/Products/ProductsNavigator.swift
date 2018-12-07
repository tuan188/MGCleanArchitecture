//
// ProductsNavigator.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

protocol ProductsNavigatorType {
    func toProductDetail(product: Product)
    func toEditProduct(_ product: Product) -> Driver<EditProductDelegate>
    func confirmDeleteProduct(_ product: Product) -> Driver<Void>
}

struct ProductsNavigator: ProductsNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(product: Product) {
        let vc: ProductDetailViewController = assembler.resolve(
            navigationController: navigationController,
            product: product)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toEditProduct(_ product: Product) -> Driver<EditProductDelegate> {
        let delegate = PublishSubject<EditProductDelegate>()
        
        let nav = UINavigationController()
        let vc: EditProductViewController = assembler.resolve(
            navigationController: nav,
            product: product,
            delegate: delegate)
        nav.viewControllers.append(vc)
        
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
                                       style: UIAlertAction.Style.cancel) { (_) in
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

