//
//  EquipmentListCell.swift
//  Uplift
//
//  Created by Yana Sang on 10/9/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class EquipmentListCell: ListCollectionViewCell<EquipmentCategory, EquipmentListItemCell> {

    static var height: CGFloat {
        return Constraints.contentPadding + Constraints.labelHeight + Constraints.equipmentTopPadding + Constraints.contentPadding
    }

    // MARK: - Constraint Constants
    struct Constraints {
        static let contentPadding: CGFloat = 16
        static let equipmentTopPadding: CGFloat = 4
        static let labelHeight: CGFloat = 20
        static let lineHeight: CGFloat = 18
    }

    // MARK: - Overrides
    override var config: ListConfiguration {
        let maxCellHeight = EquipmentListCell.getHeight(models: models)

        return ListConfiguration(
            itemSize: CGSize(width: 247.0, height: maxCellHeight),
            minimumInteritemSpacing: 16,
            minimumLineSpacing: 16,
            sectionInset: UIEdgeInsets(top: 12.0, left: 24.0, bottom: 12.0, right: 24.0)
        )
    }

    static func getHeight(models: [EquipmentCategory]) -> CGFloat {
        let baseHeight = Constraints.contentPadding + Constraints.labelHeight + Constraints.equipmentTopPadding + Constraints.contentPadding

        let equipmentCounts = models.map { $0.equipment.count }
        var maxCellHeight: CGFloat = 236
        if let maxCount = equipmentCounts.max() {
            maxCellHeight = baseHeight + Constraints.lineHeight * CGFloat(maxCount)
        }
        
        return maxCellHeight
    }

    override func configure(for models: [EquipmentCategory]) {
        super.configure(for: models)

        reloadLayout()
    }

}
