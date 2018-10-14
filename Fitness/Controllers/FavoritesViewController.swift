//
//  FavoritesViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/13/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController {

    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var quoteLabel: UILabel!
    
    var favoritesNames: [String]!
    var favorites: [GymClassInstance]! {
        willSet(newFavorites) {
            if newFavorites.count == 0 {
                view.addSubview(emptyStateView)
            } else {
                view.addSubview(classesCollectionView)
            }
            
//            remakeConstraints()
        }
    }
    
    var classesCollectionView: UICollectionView!
    var emptyStateView: NoFavoritesEmptyStateView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        //NAVIGATION BAR
        navigationController?.navigationBar.clipsToBounds = false
        navigationController?.isNavigationBarHidden = true
        additionalSafeAreaInsets.top = 76

        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "Favorites"
        view.addSubview(titleLabel)
        
        quoteLabel = UILabel()
        quoteLabel.font = ._24MontserratBold
        quoteLabel.textColor = .fitnessBlack
        quoteLabel.text = "quote"
        view.addSubview(quoteLabel)
        
        // EMPTY STATE
        emptyStateView = NoFavoritesEmptyStateView(frame: .zero)
        view.addSubview(emptyStateView)

        // COLLECTION VIEW
        classesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        classesCollectionView.bounces = false
        classesCollectionView.showsHorizontalScrollIndicator = false
        classesCollectionView.delegate = self
        classesCollectionView.dataSource = self
        classesCollectionView.backgroundColor = .white

        classesCollectionView.register(FavoritesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesHeaderView.identifier)
        classesCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)

        setupConstraints()
        
        // TODO : fetch favorites
        favoritesNames = []
        
        favorites = []
        
        remakeConstraints()
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        titleLabel.snp.updateConstraints {make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(120)
        }

    }
    
    func remakeConstraints() {
        if favorites.count == 0 {
            emptyStateView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            quoteLabel.snp.updateConstraints {make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(64)
                make.height.equalTo(58)
            }
            
            classesCollectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}


extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        
        // TODO : set up cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesHeaderView.identifier, for: indexPath) as! FavoritesHeaderView
//
//        return header
//    }
    
}
