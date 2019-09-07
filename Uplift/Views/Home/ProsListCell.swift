//
//  ProsListCollectionViewCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ProsListCellDelegate: class {
    func prosListCellShouldOpenProBio(_ proBio: ProBio)
}

class ProsListCell: ListCollectionViewCell<ProBio, ProListItemCell> {

    // MARK: - Public data vars
    weak var delegate: ProsListCellDelegate?

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: 280.0, height: 110.0),
            minimumInteritemSpacing: 16,
            sectionInset: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 16.0)
        )
    }

    override func didSelectItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let proBio = models[indexPath.item]
        delegate?.prosListCellShouldOpenProBio(proBio)
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
