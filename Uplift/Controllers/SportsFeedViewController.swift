//
//  SportsFeedViewController.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol GameStatusDelegate: class {
    func didChangeStatus(id: Int, status: GameStatus)
}

class SportsFeedViewController: UIViewController {

    let headerView = SportsFeedHeaderView()
    var collectionView: UICollectionView!
    
    let sportIdentifier = "sportIdentifier"
    var posts: [Post]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true

        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.shadowRadius = 10.0
        headerView.layer.shadowColor = UIColor.buttonShadow.cgColor
        headerView.layer.masksToBounds = false
        view.addSubview(headerView)
        
        // Fill with dummy data for now.
        posts = [
            Post(comment: [], createdAt: Date(), id: 0, userId: 0, title: "Zain's Basketball Game", time: "5:00 PM", type: "Basketball", location: "Noyes Recreation Center", players: 10, gameStatus: "JOINED"),
            Post(comment: [], createdAt: Date(), id: 1, userId: 0, title: "Sports With Zain", time: "7:00 PM", type: "Soccer", location: "Zain's Backyard", players: 2, gameStatus: "CREATED"),
            Post(comment: [], createdAt: Date(), id: 2, userId: 0, title: "Open Game with Zain", time: "4:00 PM", type: "Tennis", location: "Zain's Tennis Court", players: 0, gameStatus: "OPEN")
        ]
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12.0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32.0, height: 100.0)
        layout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PickupGameCell.self, forCellWithReuseIdentifier: sportIdentifier)
        view.addSubview(collectionView)
        
        setupConstraints()
    }

    func setupConstraints() {
        let headerViewHeight = 120

        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(headerView.snp.bottom)
        }
    }
}

extension SportsFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportIdentifier, for: indexPath) as! PickupGameCell
        let post = posts[indexPath.item]
        cell.configure(post: post)
        cell.gameStatusDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: push detail view.
        let sportsDetailView = SportsDetailViewController(post: posts[indexPath.item])
        self.navigationController?.pushViewController(sportsDetailView, animated: true)
    }
}

extension SportsFeedViewController: GameStatusDelegate {
    func didChangeStatus(id: Int, status: GameStatus) {
        // TODO: perform network request and update collection view.
    }
}
