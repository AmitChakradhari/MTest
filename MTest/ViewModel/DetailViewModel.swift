//
//  DetailViewModel.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import Foundation
import RxSwift

class DetailViewModel {
    var user: User
    var id: Int?
    
    var name: BehaviorSubject<String> = BehaviorSubject(value: "")
    var addressDetail: BehaviorSubject<String> = BehaviorSubject(value: "")
    var companyDetail: BehaviorSubject<String> = BehaviorSubject(value: "")
    var phoneWebsite: BehaviorSubject<String> = BehaviorSubject(value: "")
    var favoriteStatus: BehaviorSubject<FavoriteState> = BehaviorSubject(value: .unstarred)
    
    init(selectedUser: User) {
        user = selectedUser
        updateUser(user: selectedUser)
    }
    
    func updateUser(user: User) {
        id = user.id
        name.onNext("\(user.name) \n \(user.username)")
        addressDetail.onNext("\(user.address.suite), \(user.address.street) \n \(user.address.city) -  (\(user.address.zipcode))")
        companyDetail.onNext("\(user.company.name) \n \(user.company.catchPhrase) \n \(user.company.bs)")
        phoneWebsite.onNext("\(user.phone) \n \(user.website)")
        favoriteStatus.onNext(user.isFavorite ?? false ? .starred : .unstarred)
    }
}
