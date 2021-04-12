//
//  ViewModelTest.swift
//  MTestTests
//
//  Created by Amit  Chakradhari on 11/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
import RxTest
@testable import MTest
class ViewModelTest: XCTestCase {

    var viewModel: ViewModel!
    var networkWorker: NetworkWorker!
    var session: Session!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses?.append(URLProtocolStub.self)
        session = Session(configuration: configuration)
        
        networkWorker = NetworkWorker(session: session)
        viewModel = ViewModel(networkWorker: networkWorker)
    }

    override func tearDownWithError() throws {
        networkWorker = nil
        viewModel = nil
        session = nil
        super.tearDown()
    }

    func testShouldFetchUsers() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let path = Bundle.main.path(forResource: "userResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        URLProtocolStub.testURLs = [url: data]
        
        let requestExpectation = expectation(description: "Request should finish")

        session.request(url).responseDecodable(of: [User].self) { (response) in
            XCTAssertNil(response.error)
            switch response.result {
            case .success(let user):
                print(user, "user")
                XCTAssert(user.count > 0, "user is empty")
            default:
                break
            }
            requestExpectation.fulfill()
        }.resume()
        viewModel.getUsers()
        
        wait(for: [requestExpectation], timeout: 5)
    }

    func testShouldUpdateCellState() {
        let path = Bundle.main.path(forResource: "userResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let users = try! JSONDecoder().decode([User].self, from: data)
        let updatedUsers = viewModel.updateCellState(id: 1, oldState: .unstarred, users: users)
        XCTAssertTrue(updatedUsers[0].isFavorite!)
        
    }
}

class URLProtocolStub: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()
    
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolStub.testURLs[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
