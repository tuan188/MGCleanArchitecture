//
// ProductsViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/5/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class ProductsViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: LoadMoreTableView!
    var viewModel: ProductsViewModel!
    
    fileprivate var editProductTrigger = PublishSubject<IndexPath>()
    fileprivate var deleteProductTrigger = PublishSubject<IndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        tableView.do {
            $0.estimatedRowHeight = 550
            $0.rowHeight = UITableViewAutomaticDimension
            $0.register(cellType: ProductCell.self)
        }
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = ProductsViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: tableView.refreshTrigger,
            loadMoreTrigger: tableView.loadMoreTrigger,
            selectProductTrigger: tableView.rx.itemSelected.asDriver(),
            editProductTrigger: editProductTrigger.asDriverOnErrorJustComplete(),
            deleteProductTrigger: deleteProductTrigger.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input)
        output.productList
            .drive(tableView.rx.items) { [unowned self] tableView, index, product in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: ProductCell.self)
                    .then {
                        $0.bindViewModel(ProductViewModel(product: product))
                        $0.editProductAction = {
                            self.editProductTrigger.onNext(IndexPath(row: index, section: 0))
                        }
                        $0.deleteProductAction = {
                            self.deleteProductTrigger.onNext(IndexPath(row: index, section: 0))
                        }
                    }
            }
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.loading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.refreshing
            .drive(tableView.refreshing)
            .disposed(by: rx.disposeBag)
        output.loadingMore
            .drive(tableView.loadingMore)
            .disposed(by: rx.disposeBag)
        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)
        output.selectedProduct
            .drive()
            .disposed(by: rx.disposeBag)
        output.isEmptyData
            .drive(tableView.isEmptyData)
            .disposed(by: rx.disposeBag)
        output.editedProduct
            .drive()
            .disposed(by: rx.disposeBag)
        output.deletedProduct
            .drive()
            .disposed(by: rx.disposeBag)
    }

}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension ProductsViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
