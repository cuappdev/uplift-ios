//
//  EquipmentListCell.swift
//  Uplift
//
//  Created by Yana Sang on 10/9/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class EquipmentListCell: ListCollectionViewCell<EquipmentCategory, EquipmentListItemCell> {

    // MARK: - Overrides
    override var config: ListConfiguration {
        return ListConfiguration(
            itemSize: CGSize(width: 247.0, height: 222.0),
            minimumInteritemSpacing: 16,
            sectionInset: UIEdgeInsets(top: 0.0, left: 18.0, bottom: 16.0, right: 18.0)
        )
    }
}
