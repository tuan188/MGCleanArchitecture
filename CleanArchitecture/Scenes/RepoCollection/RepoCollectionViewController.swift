//
//  RepoCollectionViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/9/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import UIKit

final class RepoCollectionViewController: UIViewController, BindableType {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ReposViewModel!
    
    fileprivate var refreshControl: UIRefreshControl = UIRefreshControl()
    
    private struct Constant {
        // colection view
        static var spaceBetweenCell: CGFloat = 8
        static var itemsPerRow: Int = 3
        static var sectionInsets: UIEdgeInsets = UIEdgeInsets(
            top: 10.0,
            left: 10.0,
            bottom: 10.0,
            right: 10.0
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cofigView()
    }
    
    private func cofigView() {
        collectionView.do {
            $0.register(cellType: RepoCollectionCell.self)
            $0.alwaysBounceVertical = true
            $0.addSubview(refreshControl)
        }
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        logDeinit()
    }
    
    func bindViewModel() {
        let input = ReposViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            loadMoreTrigger: Driver.empty(),
            selectRepoTrigger: collectionView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input)
        output.repoList
            .drive(collectionView.rx.items) { collectionView, index, repo in
                return collectionView.dequeueReusableCell(for: IndexPath(row: index, section: 0), cellType: RepoCollectionCell.self)
                    .then {
                        $0.configView(with: repo)
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
            .drive(refreshingBinding)
            .disposed(by: rx.disposeBag)
        output.loadingMore
            .drive()
            .disposed(by: rx.disposeBag)
        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)
        output.selectedRepo
            .drive()
            .disposed(by: rx.disposeBag)
        output.isEmptyData
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

extension RepoCollectionViewController {
    var refreshingBinding: Binder<Bool> {
        return Binder(self) { vc, refreshing in
            if refreshing {
                vc.refreshControl.beginRefreshing()
            } else {
                vc.refreshControl.endRefreshing()
            }
        }
    }
}

extension RepoCollectionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.repo
}

// MARK: - UICollectionViewDelegate
extension RepoCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let paddingSpace = Constant.sectionInsets.left
            + Constant.sectionInsets.right
            + CGFloat(Constant.itemsPerRow - 1) * Constant.spaceBetweenCell
        let availableWidth = screenSize.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(Constant.itemsPerRow)
        let heightPerItem = widthPerItem
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constant.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceBetweenCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceBetweenCell
    }
    
}
