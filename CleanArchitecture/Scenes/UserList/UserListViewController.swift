//
//  UserListViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class UserListViewController: UIViewController, BindableType {
    
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
            $0.refreshHeader = nil
        }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }

    func bindViewModel() {
        let input = UserListViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: Driver.empty(),
            loadMoreTrigger: Driver.empty(),
            selectUserTrigger: tableView.rx.itemSelected.asDriver()
        )

        let output = viewModel.transform(input)
        
        output.userList
            .drive(tableView.rx.items) { tableView, index, user in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: UserCell.self)
                    .then {
                        $0.bindViewModel(UserViewModel(user: user))
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.isReloading
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.isLoadingMore
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.selectedUser
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.isEmpty
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
