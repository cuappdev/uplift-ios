//
//  SportsListCell.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/9/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class SportsListCell: ListCollectionViewCell<Sport, SportListItemCell> {

    // MARK: - Public data vars
    static let itemHeight: CGFloat = 110.0
    static let minimumInterItemSpacing: CGFloat = 16.0
    static let minimumLineSpacing: CGFloat = 16.0
    static let sectionInsetBottom: CGFloat = 32.0
    static let sectionInsetLeft: CGFloat = 12.0
    static let sectionInsetRight: CGFloat = 12.0

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: 80, height: SportsListCell.itemHeight),
            minimumInteritemSpacing: SportsListCell.minimumInterItemSpacing,
            sectionInset: UIEdgeInsets(top: 0.0, left: 12.0, bottom: 32.0, right: 12.0)
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
