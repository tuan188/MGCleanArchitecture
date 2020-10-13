//
//  API+RepoTest.swift
//  CleanArchitectureTests
//
//  Created by Anh Nguyen on 6/7/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@testable import CleanArchitecture
import Mockingjay
import XCTest
import RxTest
import RxSwift

final class APIRepoTests: XCTestCase {
    private let repoURL = API.Urls.getRepoList
    private let queries = "?page=1&q=language:swift&per_page=10"
    private var getRepoListOutput: TestableObserver<API.GetRepoListOutput>!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        getRepoListOutput = scheduler.createObserver(API.GetRepoListOutput.self)
        disposeBag = DisposeBag()
    }

    func test_APIRepo_Success() {
        // arrange
        let data = loadStub(name: "repo", extension: "json")
        let stubURL = repoURL + queries

        // act
        self.stub(uri(stubURL), jsonData(data as Data))
        let input = API.GetRepoListInput(page: 1)
        API.shared.getRepoList(input)
            .subscribe(getRepoListOutput)
            .disposed(by: disposeBag)
        
        // assert
        wait {
            XCTAssertNotNil(self.getRepoListOutput.firstEventElement)
            XCTAssertEqual(self.getRepoListOutput.firstEventElement?.repos?.count, 10)
            XCTAssertEqual(self.getRepoListOutput.firstEventElement?.repos?.first?.id, 21_700_699)
            XCTAssertEqual(self.getRepoListOutput.firstEventElement?.repos?.first?.fullname, "vsouza/awesome-ios")
        }
    }

    func test_APIRepo_Error_404() {
        // arrange
        let error = NSError(domain: "404 Not Found", code: 404, userInfo: nil)
        let stubURL = repoURL + queries
        
        // act
        self.stub(uri(stubURL), failure(error))
        let input = API.GetRepoListInput(page: 1)
        API.shared.getRepoList(input)
            .subscribe(getRepoListOutput)
            .disposed(by: disposeBag)
        
        // assert
        // https://github.com/ReactiveX/RxSwift/issues/1355
        wait {
            XCTAssertNotNil(self.getRepoListOutput.events.first?.value.error)
        }
    }
    
    func test_APIRepo_Error_500() {
        // arrange
        let error = NSError(domain: "Internal Server Error", code: 500, userInfo: nil)
        let stubURL = repoURL + queries
        
        // act
        self.stub(uri(stubURL), failure(error))
        let input = API.GetRepoListInput(page: 1)
        API.shared.getRepoList(input)
            .subscribe(getRepoListOutput)
            .disposed(by: disposeBag)
        
        // assert
        // https://github.com/ReactiveX/RxSwift/issues/1355
        wait {
            XCTAssertNotNil(self.getRepoListOutput.events.first?.value.error)
        }
    }
}
