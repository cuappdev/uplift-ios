//
//  EquipmentListCell.swift
//  Uplift
//
//  Created by Yana Sang on 10/9/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class EquipmentListCell: ListCollectionViewCell<EquipmentCategory, EquipmentListItemCell> {

    // MARK: - Constraint Constants
    struct Constraints {
        static let contentPadding: CGFloat = 16
        static let equipmentTopPadding: CGFloat = 4
        static let labelHeight: CGFloat = 20
        static let lineHeight: CGFloat = 18
    }

    // MARK: - Overrides
    override var config: ListConfiguration {
        let baseHeight = Constraints.contentPadding + Constraints.labelHeight + Constraints.equipmentTopPadding + Constraints.contentPadding

        let equipmentCounts = models.map { $0.equipment.count }
        var maxCellHeight: CGFloat = 236
        if let maxCount = equipmentCounts.max() {
            maxCellHeight = baseHeight + Constraints.lineHeight * CGFloat(maxCount)
        }

        return ListConfiguration(
            itemSize: CGSize(width: 247.0, height: maxCellHeight),
            minimumInteritemSpacing: 16,
            sectionInset: UIEdgeInsets(top: 0.0, left: 18.0, bottom: 16.0, right: 18.0)
        )
    }

    override func configure(for models: [EquipmentCategory]) {
        super.configure(for: models)

        let baseHeight = Constraints.contentPadding + Constraints.labelHeight + Constraints.equipmentTopPadding + Constraints.contentPadding

        let equipmentCounts = models.map { $0.equipment.count }
        var maxCellHeight: CGFloat = 236
        if let maxCount = equipmentCounts.max() {
            maxCellHeight = baseHeight + Constraints.lineHeight * CGFloat(maxCount)
        }

//        config.itemSize = CGSize(width: 247.0, height: maxCellHeight)
    }
}
