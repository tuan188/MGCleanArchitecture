//
//  StaticProductDetailViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/22/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class StaticProductDetailViewController: UITableViewController, Bindable {
    
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
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$name
            .asDriver()
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.$price
            .asDriver()
            .drive(priceLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - StoryboardSceneBased
extension StaticProductDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
