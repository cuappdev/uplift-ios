//
//  ListCollectionViewCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

/// This class provides data used to configure ListCollectionViewCell
class ListConfiguration {
    
    var backgroundColor: UIColor!
    var delaysContentTouches: Bool!
    var isScrollEnabled: Bool!
    var itemSize: CGSize!
    var minimumItemSpacing: CGFloat!
    var sectionInset: UIEdgeInsets!
    var scrollDirection: UICollectionView.ScrollDirection!
    var showsScrollIndicator: Bool!

    init(backgroundColor: UIColor = .white,
         delaysContentTouches: Bool = false,
         isScrollEnabled: Bool = true,
         itemSize: CGSize = .zero,
         minimumItemSpacing: CGFloat = 0,
         scrollDirection: UICollectionView.ScrollDirection = .horizontal,
         sectionInset: UIEdgeInsets = .zero,
         showsScrollIndicator: Bool = false) {
        self.backgroundColor = backgroundColor
        self.delaysContentTouches = delaysContentTouches
        self.isScrollEnabled = isScrollEnabled
        self.itemSize = itemSize
        self.minimumItemSpacing = minimumItemSpacing
        self.scrollDirection = scrollDirection
        self.sectionInset = sectionInset
        self.showsScrollIndicator = showsScrollIndicator
    }
}

/// This is a generic cell that whose contentView is a collection view
/// It takes in two generic type parameters
/// - T: the data model type that is going to be used to configure each cell inside the collection view
/// - U: the cell type to be used inside the collection view (must subclass ListItemCollectionViewCell<T>)
class ListCollectionViewCell<T, U: ListItemCollectionViewCell<T>>: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Private view vars
    private var collectionView: UICollectionView!

    // MARK: - Public data vars
    var config: ListConfiguration {
        return ListConfiguration()
    }
    var models: [T] = []

    // MARK: - Private data vars
    private let cellIdentifier = "cellIdentifier"
    private let layout = UICollectionViewFlowLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout.scrollDirection = config.scrollDirection
        layout.minimumLineSpacing = config.minimumItemSpacing
        layout.itemSize = config.itemSize
        layout.sectionInset = config.sectionInset

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = config.backgroundColor
        collectionView.isScrollEnabled = config.isScrollEnabled
        if !config.showsScrollIndicator {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
        collectionView.delaysContentTouches = config.delaysContentTouches
        collectionView.register(U.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Functions for subclasses to implement (optional)
    func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {}
    func didHighlightItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {}
    func didUnhighlightItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {}

    // MARK: - Public configure
    func configure(for models: [T]) {
        self.models = models
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! U
        let model = models[indexPath.item]
        cell.configure(for: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt(collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        didHighlightItemAt(collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        didUnhighlightItemAt(collectionView, indexPath: indexPath)
    }

    func reloadLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = config.itemSize
        layout.invalidateLayout()
    }

    func reloadConfig() {
        layout.scrollDirection = config.scrollDirection
        layout.minimumLineSpacing = config.minimumItemSpacing

        layout.itemSize = config.itemSize
        layout.sectionInset = config.sectionInset

        collectionView.backgroundColor = config.backgroundColor
        collectionView.isScrollEnabled = config.isScrollEnabled
        if !config.showsScrollIndicator {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
        collectionView.delaysContentTouches = config.delaysContentTouches
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
