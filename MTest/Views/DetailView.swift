//
//  DetailView.swift
//  MTest
//
//  Created by Amit  Chakradhari on 11/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailView: UIView {

    let utility = Utility()
    let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!
    
    var nameLabel: UILabel!
    var addressDetailLabel: UILabel!
    var companyDetailLabel: UILabel!
    var phoneWebsiteLabel: UILabel!
    var starButton: FavoriteButton!
    
    weak var detailDelegate: CellActionDelegate?
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        configureView()
        
        viewModel.name
            .observe(on: MainScheduler.instance)
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addressDetail
            .observe(on: MainScheduler.instance)
            .bind(to: addressDetailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.companyDetail
            .observe(on: MainScheduler.instance)
            .bind(to: companyDetailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.phoneWebsite
            .observe(on: MainScheduler.instance)
            .bind(to: phoneWebsiteLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.favoriteStatus
            .observe(on: MainScheduler.instance)
            .bind(to: starButton.rx.favoriteState)
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        nameLabel = utility.getLabel(alignment: .center, lines: 0)
        nameLabel.text = "nameLabel"
        addSubview(nameLabel)
        
        addressDetailLabel = utility.getLabel(alignment: .center, lines: 0)
        addressDetailLabel.text = "addressDetailLabel"
        addSubview(addressDetailLabel)
        
        companyDetailLabel = utility.getLabel(alignment: .center, lines: 0)
        companyDetailLabel.text = "companyDetailLabel"
        addSubview(companyDetailLabel)
        
        phoneWebsiteLabel = utility.getLabel(alignment: .center, lines: 0)
        phoneWebsiteLabel.text = "phoneWebsiteLabel"
        addSubview(phoneWebsiteLabel)
        
        starButton = utility.getButton()
        addSubview(starButton)
        
        starButton.addTarget(self, action: #selector(handleStarClick(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            starButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            starButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: starButton.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            addressDetailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            addressDetailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addressDetailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            companyDetailLabel.topAnchor.constraint(equalTo: addressDetailLabel.bottomAnchor, constant: 20),
            companyDetailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            companyDetailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            phoneWebsiteLabel.topAnchor.constraint(equalTo: companyDetailLabel.bottomAnchor, constant: 20),
            phoneWebsiteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            phoneWebsiteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc func handleStarClick(_ sender: FavoriteButton) {
        guard let id = viewModel.id else {return}
        detailDelegate?.handleStarClicked(id: id, currentState: sender.favoriteState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
