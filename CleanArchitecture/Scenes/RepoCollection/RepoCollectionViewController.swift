//
//  RepoCollectionViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/9/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit
import MJRefresh

final class RepoCollectionViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: PagingCollectionView!
    
    // MARK: - Properties
    
    var viewModel: ReposViewModel!
    
    private var repoList = [RepoItemViewModel]()
    
    struct LayoutOptions {
        var itemSpacing: CGFloat = 16
        var lineSpacing: CGFloat = 16
        var itemsPerRow: Int = 2
        
        var sectionInsets = UIEdgeInsets(
            top: 16.0,
            left: 16.0,
            bottom: 16.0,
            right: 16.0
        )
        
        var itemSize: CGSize {
            let screenSize = UIScreen.main.bounds
            
            let paddingSpace = sectionInsets.left
                + sectionInsets.right
                + CGFloat(itemsPerRow - 1) * itemSpacing
            
            let availableWidth = screenSize.width - paddingSpace
            let widthPerItem = availableWidth / CGFloat(itemsPerRow)
            let heightPerItem = widthPerItem
            
            return CGSize(width: widthPerItem, height: heightPerItem)
        }
    }
    
    private var layoutOptions = LayoutOptions()

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
        collectionView.do {
            $0.register(cellType: RepoCollectionCell.self)
            $0.alwaysBounceVertical = true
            $0.prefetchDataSource = self
        }
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        view.backgroundColor = ColorCompatibility.systemBackground
        collectionView.backgroundColor = ColorCompatibility.systemBackground
    }
    
    func bindViewModel() {
        let input = ReposViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: collectionView.refreshTrigger,
            loadMoreTrigger: collectionView.loadMoreTrigger,
            selectRepoTrigger: collectionView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$repoList
            .asDriver()
            .do(onNext: { [unowned self] repoList in
                self.repoList = repoList
            })
            .drive(collectionView.rx.items) { collectionView, index, repo in
                return collectionView.dequeueReusableCell(for: IndexPath(row: index, section: 0),
                                                          cellType: RepoCollectionCell.self)
                    .then {
                        $0.bindViewModel(repo)
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
            .drive(collectionView.isRefreshing)
            .disposed(by: rx.disposeBag)
        
        output.$isLoadingMore
            .asDriver()
            .drive(collectionView.isLoadingMore)
            .disposed(by: rx.disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive(collectionView.isEmpty)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - StoryboardSceneBased
extension RepoCollectionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.repo
}

// MARK: - UICollectionViewDelegate
extension RepoCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layoutOptions.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return layoutOptions.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layoutOptions.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return layoutOptions.itemSpacing
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension RepoCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths
            .compactMap { repoList[$0.row].url }
        
        print("Preheat", urls)
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}
