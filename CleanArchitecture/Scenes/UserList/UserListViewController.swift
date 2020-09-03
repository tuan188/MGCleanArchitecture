//
//  UserListViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class UserListViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: RefreshTableView!

    // MARK: - Properties
    
    var viewModel: UserListViewModel!

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
            $0.register(cellType: UserCell.self)
            $0.refreshFooter = nil
        }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        view.backgroundColor = ColorCompatibility.systemBackground
    }

    func bindViewModel() {
        let input = UserListViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: tableView.loadMoreTopTrigger,
            selectUserTrigger: tableView.rx.itemSelected.asDriver()
        )

        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$userList
            .asDriver()
            .drive(tableView.rx.items) { tableView, index, user in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: UserCell.self)
                    .then {
                        $0.bindViewModel(user)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.$error
            .asDriver()
            .unwrap()
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.$isReloading
            .asDriver()
            .drive(tableView.isLoadingMoreTop)
            .disposed(by: rx.disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension UserListViewController {

}

// MARK: - UITableViewDelegate
extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension UserListViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.user
}
