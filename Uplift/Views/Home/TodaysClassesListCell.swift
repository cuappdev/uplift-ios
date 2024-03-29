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

    static let itemWidth: CGFloat = 228.0
    static let itemHeight: CGFloat = 80.0
    static let minimumItemSpacing: CGFloat = 25.0
    static let sectionInsetBottom: CGFloat = 10.0
    static let sectionInsetLeftRight: CGFloat = 12.0

    static var totalHeight: CGFloat {
        itemHeight + sectionInsetBottom
    }

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: TodaysClassesListCell.itemWidth, height: TodaysClassesListCell.itemHeight),
            minimumItemSpacing: TodaysClassesListCell.minimumItemSpacing,
            sectionInset: UIEdgeInsets(top: 0.0, left: TodaysClassesListCell.sectionInsetLeftRight, bottom: TodaysClassesListCell.sectionInsetBottom, right: TodaysClassesListCell.sectionInsetLeftRight)
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
