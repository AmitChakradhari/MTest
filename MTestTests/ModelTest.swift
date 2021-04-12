//
//  ModelTest.swift
//  MTestTests
//
//  Created by Amit  Chakradhari on 12/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import XCTest
@testable import MTest
class ModelTest: XCTestCase {

    var user1: User!
    var user2: User!
    
    lazy var dataSource: [User] = {
        let path = Bundle.main.path(forResource: "userResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let users = try! JSONDecoder().decode([User].self, from: data)
        return users
    }()
    
    override func setUpWithError() throws {
        user1 = dataSource[0]
        user2 = dataSource[1]
    }

    override func tearDownWithError() throws {
        user1 = nil
        user2 = nil
    }

    func testShouldCheckEquality() throws {
        XCTAssertFalse(user1 == user2)
    }
    
    func testShouldExecuteHash() throws {
        var hasher = Hasher()
        user1.hash(into: &hasher)
    }
}
