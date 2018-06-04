//
// MainViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class MainViewController: UIViewController, BindableType {
    
    @IBOutlet weak var tableView: UITableView!

    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = MainViewModel.Input()
        let output = viewModel.transform(input)
    }

}

// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
