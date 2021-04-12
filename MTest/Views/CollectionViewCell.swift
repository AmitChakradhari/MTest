//
//  CollectionViewCell.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "CollectionViewCell"
    let utility = Utility()
    
    var id: Int?
    var nameLabel: UILabel!
    var phoneLabel: UILabel!
    var websiteLabel: UILabel!
    var companyLabel: UILabel!
    var starButton: FavoriteButton!
    
    weak var actionDelegate: CellActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel = utility.getLabel(alignment: .left, lines: 3)
        contentView.addSubview(nameLabel)
        
        phoneLabel = utility.getLabel(alignment: .left, lines: 1)
        contentView.addSubview(phoneLabel)
        
        websiteLabel = utility.getLabel(alignment: .left, lines: 1)
        contentView.addSubview(websiteLabel)
        
        companyLabel = utility.getLabel(alignment: .left, lines: 1)
        contentView.addSubview(companyLabel)
        
        starButton = utility.getButton()
        contentView.addSubview(starButton)
        
        starButton.addTarget(self, action: #selector(handleStarClick(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -10),
            
            starButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            starButton.widthAnchor.constraint(equalToConstant: 44),
            starButton.heightAnchor.constraint(equalToConstant: 44),
            
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            websiteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            websiteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            websiteLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            
            companyLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            companyLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 5)
        ])
    }
    
    override func prepareForReuse() {
        self.id = nil
    }
    
    @objc func handleStarClick(_ sender: FavoriteButton) {
        guard let cellId = id else {return}
        actionDelegate?.handleStarClicked(id: cellId, currentState: sender.favoriteState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
