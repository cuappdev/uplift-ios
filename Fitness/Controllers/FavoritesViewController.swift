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
    var titleBackground: UIView!
    
    var favoritesNames: [String]!
    var favorites: [GymClassInstance]! {
        didSet {
            if favorites.count == 0 {
                view.addSubview(emptyStateView)
            } else {
                view.addSubview(classesCollectionView)
            }
            
            remakeConstraints()
        }
    }
    
    var classesCollectionView: UICollectionView!
    var emptyStateView: NoFavoritesEmptyStateView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        // TITLE
        titleBackground = UIView()
        titleBackground.backgroundColor = .white
        titleBackground.layer.shadowOffset = CGSize(width: 0, height: 9)
        titleBackground.layer.shadowColor = UIColor.buttonShadow.cgColor
        titleBackground.layer.shadowOpacity = 0.25
        titleBackground.clipsToBounds = false
        view.addSubview(titleBackground)
        
        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "Favorites"
        titleBackground.addSubview(titleLabel)
        
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
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        titleBackground.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints {make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(26)
            make.trailing.lessThanOrEqualTo(titleBackground)
        }

    }
    
    func remakeConstraints() {
        if favorites.count == 0 {
            emptyStateView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
            }
        } else {
            classesCollectionView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
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
        // TODO : push class detail view
    }

//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesHeaderView.identifier, for: indexPath) as! FavoritesHeaderView
//
//        return header
//    }
    
}
