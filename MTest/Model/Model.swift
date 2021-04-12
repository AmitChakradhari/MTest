//
//  Model.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import Foundation

class User: Codable, Hashable {
    
    private let identifier = UUID()
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    var isFavorite: Bool?
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

enum Section: String, CaseIterable {
    case users = "Users"
}

enum FavoriteState: String {
    case starred = "starred"
    case unstarred = "unstarred"
}

protocol CellActionDelegate: NSObject {
    func handleStarClicked(id: Int, currentState: FavoriteState)
}

protocol DetailActionDelegate: NSObject {
    func handleStarClicked(id: Int, currentState: FavoriteState, completion: @escaping (User?) -> Void)
}
