//
//  ProductsViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class ProductsViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: PagingTableView!
    
    // MARK: - Properties

    var viewModel: ProductsViewModel!
    
    private var editProductTrigger = PublishSubject<IndexPath>()
    private var deleteProductTrigger = PublishSubject<IndexPath>()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        tableView.do {
            $0.estimatedRowHeight = 550
            $0.rowHeight = UITableView.automaticDimension
            $0.register(cellType: ProductCell.self)
        }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        view.backgroundColor = ColorCompatibility.systemBackground
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
        
        let output = viewModel?.transform(input, disposeBag: rx.disposeBag)
        
        output?.$productList
            .asDriver()
            .drive(tableView.rx.items) { [unowned self] tableView, index, product in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: ProductCell.self)
                    .then {
                        $0.bindViewModel(product)
                        
                        $0.editProductAction = {
                            self.editProductTrigger.onNext(IndexPath(row: index, section: 0))
                        }
                        
                        $0.deleteProductAction = {
                            self.deleteProductTrigger.onNext(IndexPath(row: index, section: 0))
                        }
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output?.$error
            .asDriver()
            .unwrap()
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output?.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output?.$isReloading
            .asDriver()
            .drive(tableView.isRefreshing)
            .disposed(by: rx.disposeBag)
        
        output?.$isLoadingMore
            .asDriver()
            .drive(tableView.isLoadingMore)
            .disposed(by: rx.disposeBag)
        
        output?.$isEmpty
            .asDriver()
            .drive(tableView.isEmpty)
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
