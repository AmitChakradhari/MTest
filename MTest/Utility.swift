//
//  Utility.swift
//  MTest
//
//  Created by Amit  Chakradhari on 11/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

class Utility {
    func getLabel(alignment: NSTextAlignment, lines: Int) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = alignment
        label.numberOfLines = lines
        return label
    }
    
    func getButton() -> FavoriteButton {
        let button = FavoriteButton(frame: .zero)
        button.favoriteState = .unstarred
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
