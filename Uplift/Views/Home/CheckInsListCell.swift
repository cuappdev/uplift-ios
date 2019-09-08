//
//  CheckInsListCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CheckInsListCell: ListCollectionViewCell<Habit, CheckInListItemCell> {

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: UIScreen.main.bounds.width, height: 53),
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 32.0, right: 0.0)
        )
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
