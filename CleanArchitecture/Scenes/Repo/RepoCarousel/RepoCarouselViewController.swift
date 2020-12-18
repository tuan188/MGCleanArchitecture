//
//  RepoCarouselViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 15/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit
import MGArchitecture
import MGLoadMore
import RxSwift
import RxCocoa
import Reusable
import Then
import SDWebImage

final class RepoCarouselViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: PagingCollectionView!
    
    // MARK: - Properties
    
    var viewModel: RepoCarouselViewModel!
    var disposeBag = DisposeBag()
    
    private var sections = [PageSectionViewModel]()
    
    static let sectionLayoutDictionary: [SectionType: SectionLayout] = {
        let sectionLayouts = [
            ListSectionLayout(),
            CardSectionLayout()
        ]
        
        var sectionLayoutDictionary = [SectionType: SectionLayout]()
        
        for layout in sectionLayouts {
            sectionLayoutDictionary[layout.sectionType] = layout
        }
        
        return sectionLayoutDictionary
    }()
    
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
        // register cells
        for layout in RepoCarouselViewController.sectionLayoutDictionary.values {
            collectionView.register(cellType: layout.cellType.self)
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.prefetchDataSource = self
            $0.alwaysBounceVertical = true
            $0.backgroundColor = ColorCompatibility.systemBackground
            $0.refreshFooter = nil
        }
        
        view.backgroundColor = ColorCompatibility.systemBackground
    }

    func bindViewModel() {
        let input = RepoCarouselViewModel.Input(
            load: Driver.just(()),
            reload: collectionView.refreshTrigger,
            selectRepo: collectionView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$sections
            .asDriver()
            .drive(onNext: { [unowned self] sections in
                self.sections = sections
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.$error
            .asDriver()
            .unwrap()
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        output.$isReloading
            .asDriver()
            .drive(collectionView.isRefreshing)
            .disposed(by: disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive(collectionView.isEmpty)
            .disposed(by: disposeBag)
    }
}

// MARK: - Public methods
extension RepoCarouselViewController {
    func registerCells(_ layout: SectionLayout) {
        collectionView.register(cellType: layout.cellType)
        
//        if let childCellType = sectionInfo.childCellType {
//            collectionView.register(cellType: childCellType)
//        }
    }
    
//    func registerHeaderInfo(_ headerInfo: BaseHeaderInfo) {
//        collectionView.register(supplementaryViewType: headerInfo.viewType,
//                                ofKind: UICollectionView.elementKindSectionHeader)
//    }
    
    func sectionLayout(for section: Int, collectionView: UICollectionView) -> SectionLayout {
        let pageSection = self.pageSection(for: section, collectionView: collectionView)
        return sectionLayout(for: pageSection.type)
    }
    
    func sectionLayout(for type: SectionType) -> SectionLayout {
        return RepoCarouselViewController.sectionLayoutDictionary[type]!  // swiftlint:disable:this force_unwrapping
    }
    
//    func headerInfo(for type: PageSectionHeaderType) -> BaseHeaderInfo {
//        return RepoCarouselViewController.headerInfoDict[type]!  // swiftlint:disable:this force_unwrapping
//    }
    
    func pageSection(for section: Int, collectionView: UICollectionView) -> PageSectionViewModel {
        let sectionIndex = collectionView == self.collectionView
            ? section
            : collectionView.tag
        return sections[sectionIndex]
    }
    
    func layoutOptions(for section: Int, collectionView: UICollectionView) -> LayoutOptions {
        let layout = self.sectionLayout(for: section, collectionView: collectionView)
        return layout.layout
    }
    
    private func getSizeOfItem(_ collectionView: UICollectionView,
                               at indexPath: IndexPath,
                               with sectionInfo: SectionLayout,
                               and layout: LayoutOptions) -> CGSize {
        return layout.itemSize
//        return layout.items
//        if collectionView === self.collectionView {
//            if sectionInfo.hasChild {
//                return CGSize(width: layout.itemAutoWidth,
//                              height: (sections[indexPath.section].items.first?.height ?? 0.0))
//            }
//            if sectionInfo.sectionType == .listSquare
//                || sectionInfo.sectionType == .list
//                || sectionInfo.sectionType == .listLandscape
//                || sectionInfo.sectionType == .notice {
//                return CGSize(width: layout.itemAutoWidth,
//                              height: sections[indexPath.section].items[indexPath.row].height ?? 0.0)
//            }
//            return layout.itemSize
//        } else {
//            return CGSize(width: sections[collectionView.tag].items.first?.width ?? 0.0,
//                          height: sections[collectionView.tag].items.first?.height ?? 0.0)
//        }
    }
}

// MARK: - UICollectionViewDataSource
extension RepoCarouselViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageSection = self.pageSection(for: indexPath.section, collectionView: collectionView)
        let sectionLayout = self.sectionLayout(for: pageSection.type)
        let viewModel = sections[indexPath.section].items[indexPath.row]
        
        return collectionView.dequeueReusableCell(for: indexPath, cellType: sectionLayout.cellType).then {
            $0.bindViewModel(viewModel)
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension RepoCarouselViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set Collection View's Estimate Size to None in Storyboard
        let sectionLayout = self.sectionLayout(for: sections[indexPath.section].type)
        let layout = layoutOptions(for: indexPath.section, collectionView: collectionView)
        return getSizeOfItem(collectionView, at: indexPath, with: sectionLayout, and: layout)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let layout = layoutOptions(for: section, collectionView: collectionView)
//        if collectionView === self.collectionView {
//            let sectionInset = getSectionInset(of: section)
//            setSectionInset(sectionInset)
//            return sectionInset
//        }
        return layout.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let layout = layoutOptions(for: section, collectionView: collectionView)
        return layout.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let layout = layoutOptions(for: section, collectionView: collectionView)
        return layout.itemSpacing
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension RepoCarouselViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let urls = indexPaths
//            .compactMap { items[$0.row].imageURL }
//
//        print("Preheat", urls)
//        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

// MARK: - StoryboardSceneBased
extension RepoCarouselViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.repo
}
