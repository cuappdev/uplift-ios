//
//  LookingForListCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 9/10/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol LookingForListCellDelegate: class {
    func lookingForCellShouldTagSearch(at tag: Tag, indexPath: IndexPath)
}

class LookingForListCell: ListCollectionViewCell<Tag, LookingForListItemCell> {
    
    // MARK: - Public data vars
    weak var delegate: LookingForListCellDelegate?
    private var collectionViewWidth: CGFloat = 0
    private var height: CGFloat {
        return ((collectionViewWidth - 48) / 2) * 0.78
    }
    private var width: CGFloat {
        return (collectionViewWidth - 48) / 2
    }
    
    static let sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 16.0)

    static let minimumItemSpace: CGFloat = 16
    
    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            isScrollEnabled: false,
            itemSize: CGSize(width: self.width, height: self.height),
            minimumItemSpacing: LookingForListCell.minimumItemSpace,
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 16.0)
        )
    }
    
    func configure(for model: [Tag], width: CGFloat) {
        super.configure(for: model)
        self.collectionViewWidth = width
        self.reloadConfig()
        self.reloadInputViews()
    }
    
    override func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let tag = models[indexPath.item]
        delegate?.lookingForCellShouldTagSearch(at: tag, indexPath: indexPath)
    }
    
    override func didHighlightItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.zoomIn()
    }

    override func didUnhighlightItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.zoomOut()
    }
    
    static func getHeight(collectionViewWidth: CGFloat, numTags: Int) -> CGFloat {
        return CGFloat(numTags / 2) * (((collectionViewWidth-48)/2)*0.78 + minimumItemSpace)
    }
}
