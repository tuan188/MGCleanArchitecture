//
// ReposViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/28/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class ReposViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: RefreshTableView!
    var viewModel: ReposViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        tableView.do {
            $0.estimatedRowHeight = 550
            $0.rowHeight = UITableViewAutomaticDimension
            $0.register(cellType: RepoCell.self)
        }
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = ReposViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: tableView.loadMoreTopTrigger,
            loadMoreTrigger: tableView.loadMoreBottomTrigger,
            selectRepoTrigger: tableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input)
        output.repoList
            .drive(tableView.rx.items) { tableView, index, repo in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: RepoCell.self)
                    .then {
                        $0.bindViewModel(RepoViewModel(repo: repo))
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
            .drive(tableView.loadingMoreTop)
            .disposed(by: rx.disposeBag)
        output.loadingMore
            .drive(tableView.loadingMoreBottom)
            .disposed(by: rx.disposeBag)
        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)
        output.selectedRepo
            .drive()
            .disposed(by: rx.disposeBag)
        output.isEmptyData
            .drive(tableView.isEmptyData)
            .disposed(by: rx.disposeBag)
    }

}

// MARK: - UITableViewDelegate
extension ReposViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension ReposViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.repo
}
