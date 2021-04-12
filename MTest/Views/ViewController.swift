//
//  ViewController.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, User>! = nil
    var userDataSource: [User] = []
    lazy var viewModel: ViewModel = ViewModel(networkWorker: NetworkWorker())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        
        viewModel.users
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userList in
                guard let strongSelf = self else {return}
                strongSelf.userDataSource = userList
                let snapshot = strongSelf.snapshotForCurrentState()
                strongSelf.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.getUsers()
    }

    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellReuseIdentifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/2.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, userItem: User) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellReuseIdentifier, for: indexPath) as? CollectionViewCell else {
                fatalError("could not create cell")
            }
            cell.actionDelegate = self
            cell.id = userItem.id
            cell.nameLabel.text = userItem.name
            cell.phoneLabel.text = userItem.phone
            cell.websiteLabel.text = userItem.website
            cell.companyLabel.text = userItem.company.name
            cell.starButton.favoriteState = userItem.isFavorite ?? false ? .starred : .unstarred
            return cell
        }
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, User> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        
        snapshot.appendSections([Section.users])
        snapshot.appendItems(userDataSource)
        return snapshot
    }
}


extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewController = DetailViewController()
        detailViewController.actionDelegate = self
        let detailViewModel = DetailViewModel(selectedUser: user)
        detailViewController.viewModel = detailViewModel
        
        navigationController?.pushViewController(detailViewController, animated: false)
    }
}

extension ViewController: CellActionDelegate {
    func handleStarClicked(id: Int, currentState: FavoriteState) {
        let _ = viewModel.updateCellState(id: id, oldState: currentState, users: userDataSource)
    }
}

extension ViewController: DetailActionDelegate {
    func handleStarClicked(id: Int, currentState: FavoriteState, completion: @escaping (User?) -> Void) {
        let updatedUsers = viewModel.updateCellState(id: id, oldState: currentState, users: userDataSource)
        let userDetail = updatedUsers.first(where: { user in
            return user.id == id
        })
        guard userDetail != nil else {
            completion(nil)
            return
        }
        completion(userDetail!)
    }
}
