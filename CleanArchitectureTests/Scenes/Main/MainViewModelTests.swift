//
// MainViewModelTests.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/4/18.
// Copyright © 2018 Framgia. All rights reserved.
//

@testable import CleanArchitecture
import XCTest
import RxSwift
import RxBlocking

final class MainViewModelTests: XCTestCase {
    
    private var viewModel: MainViewModel!
    private var navigator: MainNavigatorMock!
    private var useCase: MainUseCaseMock!
    
    private var input: MainViewModel.Input!
    private var output: MainViewModel.Output!
    
    private var disposeBag: DisposeBag!
    
    private let loadTrigger = PublishSubject<Void>()
    private let selectMenuTrigger = PublishSubject<IndexPath>()
    
    override func setUp() {
        super.setUp()
        navigator = MainNavigatorMock()
        useCase = MainUseCaseMock()
        viewModel = MainViewModel(navigator: navigator, useCase: useCase)
        
        input = MainViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            selectMenuTrigger: selectMenuTrigger.asDriverOnErrorJustComplete()
        )
        
        output = viewModel.transform(input)
        
        disposeBag = DisposeBag()
        
        output.menuSections.drive().disposed(by: disposeBag)
        output.selectedMenu.drive().disposed(by: disposeBag)
    }
    
    func test_loadTriggerInvoked_loadMenuList() {
        // act
        loadTrigger.onNext(())
        let menuSections = try? output.menuSections.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(menuSections??.count, 2)
    }
    
    private func indexPath(of menu: MainViewModel.Menu) -> IndexPath? {
        let menuSections = viewModel.menuSections()
        for (section, menuSection) in menuSections.enumerated() {
            for (row, aMenu) in menuSection.menus.enumerated() {
                if aMenu == menu { // swiftlint:disable:this for_where
                    return IndexPath(row: row, section: section)
                }
            }
        }
        return nil
    }
    
    func test_selectMenuTriggerInvoked_toProductList() {
        // act
        loadTrigger.onNext(())
        guard let indexPath = indexPath(of: .products) else {
            XCTFail()
            return
        }
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toProductsCalled)
    }
    
    func test_selectMenuTriggerInvoked_toSectionedProductList() {
        // act
        loadTrigger.onNext(())
        guard let indexPath = indexPath(of: .sectionedProducts) else {
            XCTFail()
            return
        }
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toSectionedProductsCalled)
    }
    
    func test_selectMenuTriggerInvoked_toRepoList() {
        // act
        loadTrigger.onNext(())
        guard let indexPath = indexPath(of: .repos) else {
            XCTFail()
            return
        }
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toReposCalled)
    }
    
    func test_selectMenuTriggerInvoked_toRepoCollection() {
        // act
        loadTrigger.onNext(())
        guard let indexPath = indexPath(of: .repoCollection) else {
            XCTFail()
            return
        }
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toRepoCollectionCalled)
    }
    
}

