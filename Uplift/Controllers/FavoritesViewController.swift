//
//  FavoritesViewController.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/13/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - INITIALIZATION
    var titleBackground: UIView!
    var titleLabel: UILabel!

    var favoritesNames: [String]! = []
    var favorites: [GymClassInstance]! = [] {
        didSet {
            if favoritesNames.isEmpty {
                classesCollectionView.removeFromSuperview()
                emptyStateView.layer.zPosition = -1
                view.addSubview(emptyStateView)
            } else {
                emptyStateView.removeFromSuperview()
                classesCollectionView.layer.zPosition = -1
                view.addSubview(classesCollectionView)
                classesCollectionView.reloadData()
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
        titleBackground.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        titleBackground.layer.shadowOpacity = 0.4
        titleBackground.layer.shadowRadius = 10.0
        titleBackground.layer.shadowColor = UIColor.buttonShadow.cgColor
        titleBackground.layer.masksToBounds = false
        titleBackground.clipsToBounds = false
        view.addSubview(titleBackground)

        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "Favorites"
        titleBackground.addSubview(titleLabel)

        // EMPTY STATE
        emptyStateView = NoFavoritesEmptyStateView(frame: .zero)
        emptyStateView.delegate = self
        emptyStateView.layer.zPosition = -1
        view.addSubview(emptyStateView)

        // COLLECTION VIEW
        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: view.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .init(width: view.bounds.width, height: 233.0)

        classesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classesCollectionView.showsHorizontalScrollIndicator = false
        classesCollectionView.showsVerticalScrollIndicator = false
        classesCollectionView.delegate = self
        classesCollectionView.dataSource = self
        classesCollectionView.backgroundColor = .clear
        classesCollectionView.bounces = true

        classesCollectionView.register(FavoritesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesHeaderView.identifier)
        classesCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        classesCollectionView.layer.zPosition = -1
        view.addSubview(classesCollectionView)

        setupConstraints()

        favoritesNames = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []
        favorites = []

        NetworkManager.shared.getGymClassInstancesByClass(gymClassDetailIds: favoritesNames) { gymClasses in
            self.favorites = gymClasses
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let newFavoritesNames = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []

        if newFavoritesNames != favoritesNames {
            favoritesNames = newFavoritesNames
            if !favoritesNames.isEmpty {
                NetworkManager.shared.getGymClassInstancesByClass(gymClassDetailIds: favoritesNames) { gymClasses in
                    self.favorites = gymClasses
                }
            } else {
                favorites = []
            }
        }
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        let titleBackgroundHeight = 120
        let titleLeading = 24
        let titleBottom = -20
        let titleHeight = 26

        titleBackground.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(titleBackgroundHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(titleLeading)
            make.bottom.equalToSuperview().offset(titleBottom)
            make.height.equalTo(titleHeight)
            make.trailing.lessThanOrEqualTo(titleBackground)
        }
    }

    func remakeConstraints() {
        if favoritesNames.isEmpty {
            emptyStateView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(titleBackground.snp.bottom)
            }
        } else {
            classesCollectionView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(titleBackground.snp.bottom).offset(12)
            }
        }
    }
}

extension FavoritesViewController: ClassListCellDelegate, NavigationDelegate {
    func toggleFavorite(classDetailId: String) {
        favoritesNames = favoritesNames.filter { $0 != classDetailId }
        favorites = favorites.filter { $0.classDetailId != classDetailId }
        classesCollectionView.reloadData()
    }
    
    func viewTodaysClasses() {
        guard let classNavigationController = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
        guard let classListViewController = classNavigationController.viewControllers[0] as? ClassListViewController else { return }

        classListViewController.updateCalendarDateSelectedToToday()

        classNavigationController.setViewControllers([classListViewController], animated: false)

        tabBarController?.selectedIndex = 1
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell

        cell.configure(gymClassInstance: favorites[indexPath.row], style: .date)
        cell.delegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoritesHeaderView.identifier, for: indexPath) as! FavoritesHeaderView
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classDetailViewController = ClassDetailViewController(gymClassInstance: favorites[indexPath.row])
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }
}
