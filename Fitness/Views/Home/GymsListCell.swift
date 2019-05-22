//
//  AllGymsCell.swift
//  Fitness
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

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: 271.0, height: 90.0),
            minimumInteritemSpacing: 16,
            sectionInset: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 12.0)
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
