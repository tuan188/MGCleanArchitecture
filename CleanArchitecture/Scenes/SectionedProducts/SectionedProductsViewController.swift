//
// SectionedProductsViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/11/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

import RxDataSources
final class SectionedProductsViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: LoadMoreTableView!
    var viewModel: SectionedProductsViewModel!

    fileprivate typealias ProductSectionModel = SectionModel<String, SectionedProductsViewModel.ProductModel>
    fileprivate var dataSource: RxTableViewSectionedReloadDataSource<ProductSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        tableView.do {
            $0.estimatedRowHeight = 550
            $0.rowHeight = UITableViewAutomaticDimension
            $0.register(cellType: SectionedProductCell.self)
        }
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = SectionedProductsViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: tableView.refreshTrigger,
            loadMoreTrigger: tableView.loadMoreTrigger,
            selectProductTrigger: tableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input)
        dataSource = RxTableViewSectionedReloadDataSource<ProductSectionModel>(
            configureCell: { (_, tableView, indexPath, product) -> UITableViewCell in
                return tableView.dequeueReusableCell(for: indexPath, cellType: SectionedProductCell.self).then {
                    $0.configView(with: product)
                }
            },
            titleForHeaderInSection: { dataSource, section in
                return dataSource.sectionModels[section].model
            })
        output.productSections
            .map {
                $0.map { section in
                    ProductSectionModel(model: section.header, items: section.productList)
                }
            }
            .drive(tableView.rx.items(dataSource: dataSource))
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
            .drive()
            .disposed(by: rx.disposeBag)
    }

}

// MARK: - UITableViewDelegate
extension SectionedProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension SectionedProductsViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
