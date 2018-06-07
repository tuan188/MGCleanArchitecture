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
        configView()
    }
    
    private func configView() {
        tableView.do {
            $0.rowHeight = 60
            $0.register(cellType: MenuCell.self)
            $0.delegate = self
        }
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = MainViewModel.Input(
            loadTrigger: Driver.just(()),
            selectMenuTrigger: tableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input)
        output.menuList
            .drive(tableView.rx.items) { tableView, index, menu in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: MenuCell.self)
                    .then {
                        $0.configView(with: menu)
                }
            }
            .disposed(by: rx.disposeBag)
        output.selectedMenu
            .drive()
            .disposed(by: rx.disposeBag)
    }

}

// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

