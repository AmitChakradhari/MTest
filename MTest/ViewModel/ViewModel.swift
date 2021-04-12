//
//  ViewModel.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel {
    var loading: PublishSubject<Bool> = PublishSubject()
    var users: PublishSubject<[User]> = PublishSubject()
    var networkWorker: NetworkWorker
    
    init(networkWorker: NetworkWorker) {
        self.networkWorker = networkWorker
    }
    
    func updateCellState(id: Int, oldState: FavoriteState, users: [User]) -> [User] {
        let updatedUsers = users
        let index = updatedUsers.firstIndex(where: { user in
            return user.id == id
        })
        guard let idx = index else {return updatedUsers}
        let newState: FavoriteState = oldState == .starred ? .unstarred : .starred
        updatedUsers[idx].isFavorite = newState == .starred
        self.users.onNext(updatedUsers)
        return updatedUsers
    }
    
    func getUsers() {
        loading.onNext(true)
        networkWorker.getUsers { [weak self] result in
            guard let self = self else {return}
            self.loading.onNext(false)
            switch result {
            case .success(let userList):
                self.users.onNext(userList)
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
