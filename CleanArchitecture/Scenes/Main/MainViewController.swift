//
// MainViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable
import RxDataSources

final class MainViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties

    var viewModel: MainViewModel!
    
    private typealias MainMenuSectionModel = SectionModel<String, MainViewModel.Menu>
    private var dataSource: RxTableViewSectionedReloadDataSource<MainMenuSectionModel>?
    
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
            $0.rowHeight = 60
            $0.register(cellType: MenuCell.self)
            $0.delegate = self
        }
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input(
            loadTrigger: Driver.just(()),
            selectMenuTrigger: tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<MainMenuSectionModel>(
            configureCell: { (_, tableView, indexPath, menu) -> UITableViewCell in
                return tableView.dequeueReusableCell(for: indexPath, cellType: MenuCell.self)
                    .then {
                        $0.titleLabel.text = menu.description
                    }
            }, titleForHeaderInSection: { dataSource, section in
                return dataSource.sectionModels[section].model
            })
        
        self.dataSource = dataSource
        
        output.menuSections
            .map {
                $0.map { section in
                    MainMenuSectionModel(model: section.title, items: section.menus)
                }
            }
            .drive(tableView.rx.items(dataSource: dataSource))
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

