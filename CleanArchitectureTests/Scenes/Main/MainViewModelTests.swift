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
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        navigator = MainNavigatorMock()
        useCase = MainUseCaseMock()
        viewModel = MainViewModel(navigator: navigator, useCase: useCase)
        disposeBag = DisposeBag()
    }

    func test_triggerInvoked_() {
        // arrange
        let input = MainViewModel.Input()
        let output = viewModel.transform(input)

        // act

        // assert
        XCTAssert(true)
    }
}
