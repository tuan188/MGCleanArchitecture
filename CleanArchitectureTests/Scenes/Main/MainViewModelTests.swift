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
        
        output.menuList.drive().disposed(by: disposeBag)
        output.selectedMenu.drive().disposed(by: disposeBag)
    }
    
    func test_loadTriggerInvoked_loadMenuList() {
        // act
        loadTrigger.onNext(())
        let menuList = try? output.menuList.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssertEqual(menuList??.count, MainViewModel.Menu.allCases.count)
    }
    
    func test_selectMenuTriggerInvoked_toProductList() {
        // act
        loadTrigger.onNext(())
        let index = MainViewModel.Menu.products.rawValue
        let indexPath = IndexPath(row: index, section: 0)
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toProducts_Called)
    }
    
    func test_selectMenuTriggerInvoked_toSectionedProductList() {
        // act
        loadTrigger.onNext(())
        let index = MainViewModel.Menu.sectionedProducts.rawValue
        let indexPath = IndexPath(row: index, section: 0)
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toSectionedProducts_Called)
    }
    
    func test_selectMenuTriggerInvoked_toRepoList() {
        // act
        loadTrigger.onNext(())
        let index = MainViewModel.Menu.repos.rawValue
        let indexPath = IndexPath(row: index, section: 0)
        selectMenuTrigger.onNext(indexPath)
        
        // assert
        XCTAssert(navigator.toRepos_Called)
    }
    
}

