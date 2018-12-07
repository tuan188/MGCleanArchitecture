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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Properties

    var viewModel: StaticProductDetailViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - Methods

    func bindViewModel() {
        let input = StaticProductDetailViewModel.Input(
            loadTrigger: Driver.just(())
        )
        
        let output = viewModel.transform(input)
        
        output.name
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.price
            .drive(priceLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - StoryboardSceneBased
extension StaticProductDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
