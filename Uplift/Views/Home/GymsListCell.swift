//
//  GymsListCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol GymsListCellDelegate: class {
    func allGymsCellShouldOpenGym(_ gym: Gym)
}

class GymsListCell: ListCollectionViewCell<Gym, GymListItemCell> {

    // MARK: - Public data vars
    weak var delegate: GymsListCellDelegate?
    static let itemHeight: CGFloat = 60.0
    static let minimumInterItemSpacing: CGFloat = 16.0
    static let minimumLineSpacing: CGFloat = 16.0
    static let sectionInsetBottom: CGFloat = 32.0
    static let sectionInsetLeft: CGFloat = 16.0
    static let sectionInsetRight: CGFloat = 12.0

    // MARK: - Overrides
    override var config: ListConfiguration {
        let width: CGFloat = (self.bounds.width - GymsListCell.minimumInterItemSpacing - GymsListCell.sectionInsetLeft - GymsListCell.sectionInsetRight)
        return ListConfiguration(
            isScrollEnabled: true,
            itemSize: CGSize(width: width, height: GymsListCell.itemHeight),
            minimumInteritemSpacing: GymsListCell.minimumInterItemSpacing,
            minimumLineSpacing: GymsListCell.minimumLineSpacing,
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: 0.0, left: GymsListCell.sectionInsetLeft, bottom: GymsListCell.sectionInsetBottom, right: GymsListCell.sectionInsetRight)
        )
    }

    override func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let gym = models[indexPath.item]
        delegate?.allGymsCellShouldOpenGym(gym)
    }

    override func didHighlightItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.zoomIn()
    }

    override func didUnhighlightItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.zoomOut()
    }

}
