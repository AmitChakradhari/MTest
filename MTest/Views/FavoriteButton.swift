//
//  FavoriteButton.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {
    
    var favoriteState: FavoriteState = .unstarred {
        didSet {
            switch favoriteState {
            case .starred:
                self.setImage(UIImage(systemName: "star.fill"), for: .normal)
            default:
                self.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
