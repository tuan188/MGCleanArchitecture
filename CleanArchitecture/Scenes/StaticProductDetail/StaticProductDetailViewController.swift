//
// StaticProductDetailViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/22/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class StaticProductDetailViewController: UITableViewController, BindableType {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var viewModel: StaticProductDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = StaticProductDetailViewModel.Input(
            loadTrigger: Driver.just(())
        )
        let output = viewModel.transform(input)
        output.name
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.price
            .map { $0.currency }
            .drive(priceLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }

}

// MARK: - StoryboardSceneBased
extension StaticProductDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
