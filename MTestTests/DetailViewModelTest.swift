//
//  DetailViewModelTest.swift
//  MTestTests
//
//  Created by Amit  Chakradhari on 12/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import XCTest
import RxSwift
@testable import MTest
class DetailViewModelTest: XCTestCase {

    var viewModel: DetailViewModel!
    let disposeBag = DisposeBag()
    
    lazy var dataSource: [User] = {
        let path = Bundle.main.path(forResource: "userResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let users = try! JSONDecoder().decode([User].self, from: data)
        return users
    }()
    
    override func setUpWithError() throws {
        
        viewModel = DetailViewModel(selectedUser: dataSource[0])
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testShouldCallUpdateUser() throws {
        viewModel.updateUser(user: dataSource[1])
        viewModel.name.asObservable().debug().subscribe(onNext: { nextName in
            XCTAssertTrue(nextName.contains("Ervin Howell"))
        }).disposed(by: disposeBag)
        
        viewModel.addressDetail.asObservable().debug().subscribe(onNext: { address in
            XCTAssertTrue(address.contains("Victor Plains"))
        }).disposed(by: disposeBag)
        
        viewModel.companyDetail.asObservable().debug().subscribe(onNext: { companDetail in
            XCTAssertTrue(companDetail.contains("Deckow-Crist"))
        }).disposed(by: disposeBag)
        
        viewModel.phoneWebsite.asObservable().debug().subscribe(onNext: { phoneWebsite in
            XCTAssertTrue(phoneWebsite.contains("anastasia.net"))
        }).disposed(by: disposeBag)
        
        viewModel.favoriteStatus.asObservable().debug().subscribe(onNext: { status in
            XCTAssert(status == .unstarred, "false status coming")
        }).disposed(by: disposeBag)
    }
}

