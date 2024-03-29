//
//  GymsListCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol GymsListCellDelegate: AnyObject{
    func openGymDetail(gymId: Int)
}

class GymsListCell: ListCollectionViewCell<FitnessCenter, GymListItemCell> {

    // MARK: - Public data vars
    weak var delegate: GymsListCellDelegate?

    static let itemHeight: CGFloat = 190.0

    static let minimumItemSpacing: CGFloat = 30.0

    static let sectionInsetBottom: CGFloat = 32.0
    static let sectionInsetLeft: CGFloat = 12.0
    static let sectionInsetRight: CGFloat = 12.0

    // MARK: - Overrides
    override var config: ListConfiguration {
        let width: CGFloat = (self.bounds.width - GymsListCell.sectionInsetLeft - GymsListCell.sectionInsetRight)
        return ListConfiguration(
            isScrollEnabled: true,
            itemSize: CGSize(width: width, height: GymsListCell.itemHeight),
            minimumItemSpacing: GymsListCell.minimumItemSpacing,
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: 0.0, left: GymsListCell.sectionInsetLeft, bottom: GymsListCell.sectionInsetBottom, right: GymsListCell.sectionInsetRight)
        )
    }

    override func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        delegate?.openGymDetail(gymId: models[indexPath.item].gymId)
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
