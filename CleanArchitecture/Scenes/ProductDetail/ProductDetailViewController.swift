//
// ProductDetailViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class ProductDetailViewController: UIViewController, BindableType {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: ProductDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        tableView.do {
            $0.estimatedRowHeight = 550
            $0.rowHeight = UITableViewAutomaticDimension
            $0.register(cellType: ProductNameCell.self)
            $0.register(cellType: ProductPriceCell.self)
        }
    }
    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = ProductDetailViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input)
        output.cells
            .drive(tableView.rx.items) { tableView, index, cellType in
                let indexPath = IndexPath(row: index, section: 0)
                switch cellType {
                case let .name(name):
                    return tableView.dequeueReusableCell(
                        for: indexPath,
                        cellType: ProductNameCell.self).then {
                            $0.nameLabel.text = name
                    }
                case let .price(price):
                    return tableView.dequeueReusableCell(
                        for: indexPath,
                        cellType: ProductPriceCell.self).then {
                            $0.priceLabel.text = price
                    }
                }
            }
            .disposed(by: rx.disposeBag)
    }

}

// MARK: - StoryboardSceneBased
extension ProductDetailViewController: StoryboardSceneBased {
    // TODO: - Update storyboard
    static var sceneStoryboard = Storyboards.product
}
