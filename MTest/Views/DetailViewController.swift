//
//  DetailViewController.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    weak var actionDelegate: DetailActionDelegate?
    
    var viewModel: DetailViewModel!
    var detailView: DetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView = DetailView(viewModel: viewModel)
        detailView.detailDelegate = self
        view.addSubview(detailView)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension DetailViewController: CellActionDelegate {
    func handleStarClicked(id: Int, currentState: FavoriteState) {
        actionDelegate?.handleStarClicked(id: id, currentState: currentState) { [weak self] userDetail in
                guard let self = self, let userDetail = userDetail else {return}
                self.viewModel.updateUser(user: userDetail)
        }
    }
}
