//
//  StretchyHeaderLayout.swift
//  StretchyHeaderLBTA
//
//  Created by Brian Voong on 12/22/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//
//  Credits to: https://www.letsbuildthatapp.com

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {

    // We want to modify the attributes of our header component.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        layoutAttributes?.forEach({ (attributes) in

            // Find header component
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {

                guard let collectionView = collectionView else { return }

                let contentOffsetY = collectionView.contentOffset.y
                // Check to see when we have scrolled past the top of the screen
                if contentOffsetY > 0 {
                    return
                }

                let width = collectionView.frame.width
                // We are subtracting here because the contentOffsetY is negative and we want to increase the height
                let height = attributes.frame.height - contentOffsetY

                // Adjust header's frame
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)

            }
        })

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
