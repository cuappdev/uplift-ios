//
//  TodaysClassesListCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SkeletonView

protocol TodaysClassesListCellDelegate: class {
    func todaysClassesCellShouldOpenGymClassInstance(_ gymClassInstance: GymClassInstance)
}

class TodaysClassesListCell: ListCollectionViewCell<GymClassInstance, TodaysClassListItemCell> {

    // MARK: - Public data vars
    weak var delegate: TodaysClassesListCellDelegate?

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: 228.0, height: 195.0),
            minimumInteritemSpacing: 16,
            sectionInset: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 12.0)
        )
    }

    override func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let gymClassInstance = models[indexPath.item]
        delegate?.todaysClassesCellShouldOpenGymClassInstance(gymClassInstance)
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

extension TodaysClassesListCell: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return Identifiers.classesCell
    }

}
