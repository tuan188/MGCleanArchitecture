//
//  API+RepoTest.swift
//  CleanArchitectureTests
//
//  Created by Anh Nguyen on 6/7/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import XCTest
import Mockingjay
@testable import CleanArchitecture

final class APIRepoTests: XCTestCase {
    let repoURL = API.Urls.getRepoList
    let queries = "?page=1&q=language:swift&per_page=10"

    func test_APIRepo_Success() {
        // arrange
        var output: API.GetRepoListOutput?
        let data = loadStub(name: "repo", extension: "json")
        let stubURL = repoURL + queries

        // act
        self.stub(uri(stubURL), jsonData(data as Data))
        let input = API.GetRepoListInput(page: 1)
        output = try? API.shared.getRepoList(input).toBlocking().first()
        
        // assert
        XCTAssertNotNil(output?.repos)
        XCTAssertTrue(output?.repos?.count == 10)
        XCTAssertTrue(output?.repos?.first?.id == 21700699)
        XCTAssertTrue(output?.repos?.first?.fullname == "vsouza/awesome-ios")
    }

    func test_APIRepo_Error_404() {
        // arrange
        let error = NSError(domain: "404 Not Found", code: 404, userInfo: nil)
        let stubURL = repoURL + queries
        
        // act
        self.stub(uri(stubURL), failure(error))
        let input = API.GetRepoListInput(page: 1)
        
        // assert
        // https://github.com/ReactiveX/RxSwift/issues/1355
        XCTAssertThrowsError(try API.shared.getRepoList(input).toBlocking().first())
    }
    
    func test_APIRepo_Error_500() {
        // arrange
        let error = NSError(domain: "Internal Server Error", code: 500, userInfo: nil)
        let stubURL = repoURL + queries
        
        // act
        self.stub(uri(stubURL), failure(error))
        let input = API.GetRepoListInput(page: 1)
        
        // assert
        // https://github.com/ReactiveX/RxSwift/issues/1355
        XCTAssertThrowsError(try API.shared.getRepoList(input).toBlocking().first())
    }
}
