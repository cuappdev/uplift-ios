//
//  LoadingCollectionView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/20/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SkeletonView
import UIKit

enum LoadingCollectionViewType {
    case smallGrid
    case horizontallyScrolling
    case largeGrid
    case calendar
    case classes
}

class LoadingCollectionView: UICollectionView {

    let calendarClassSideInsets: CGFloat = 16
    let collectionViewType: LoadingCollectionViewType!
    let collectionViewWidth: CGFloat!
    let leftInset: CGFloat = 12
    let minimumLineSpacing: CGFloat = 16
    let rightInset: CGFloat = 16

    // MARK: - Small grid collection view properties
    let smallGridCellCount = 5
    let smallGridCellHeight: CGFloat = 60
    let smallGridHeaderWidth: CGFloat = 75
    let smallGridMinimumInteritemSpacing: CGFloat = 16
    let smallGridRowCount = 3

    // MARK: - Horizontally scrolling collection view properties
    let horizontallyScrollingCellCount = 3
    let horizontallyScrollingCellHeight: CGFloat = 195
    let horizontallyScrollingCellWidth: CGFloat = 228
    let horizontallyScrollingHeaderWidth: CGFloat = 135
    let horizontallyScrollingMinimumInteritemSpacing: CGFloat = 18

    // MARK: - Large grid collection view properties
    let largeGridCellCount = 2
    let largeGridCellHeight: CGFloat = 107
    let largeGridCellWidth: CGFloat = 164
    let largeGridHeaderWidth: CGFloat = 135
    let largeGridMinimumInteritemSpacing: CGFloat = 15

    // MARK: - Calendar collection view properties
    let calendarCellCount = 14
    let calendarCellSize: CGFloat = 24
    let calendarHeaderWidth: CGFloat = 59
    let calendarMinimumLineSpacing: CGFloat = 43.0

    // MARK: - Class collection view properties
    let classesCellCount = 5
    let classesCellHeight: CGFloat = 100
    let classesHeaderWidth: CGFloat = 59
    let classesMinimumLineSpacing: CGFloat = 12

    var headerWidth: CGFloat = 0
    var height: CGFloat = 0

    init(frame: CGRect, collectionViewType: LoadingCollectionViewType, collectionViewWidth: CGFloat) {
        self.collectionViewType = collectionViewType
        self.collectionViewWidth = collectionViewWidth

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)

        switch collectionViewType {
        case .smallGrid:
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = smallGridMinimumInteritemSpacing
            height = (smallGridMinimumInteritemSpacing + smallGridCellHeight) * CGFloat(smallGridRowCount) - smallGridMinimumInteritemSpacing
            headerWidth = smallGridHeaderWidth
        case .horizontallyScrolling:
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = horizontallyScrollingMinimumInteritemSpacing
            height = horizontallyScrollingCellHeight
            headerWidth = horizontallyScrollingHeaderWidth
        case .largeGrid:
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = largeGridMinimumInteritemSpacing
            height = largeGridCellHeight
            headerWidth = largeGridHeaderWidth
        case .calendar:
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = calendarMinimumLineSpacing
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: calendarClassSideInsets, bottom: 0.0, right: calendarClassSideInsets)
            height = calendarCellSize
            headerWidth = calendarHeaderWidth
        case .classes:
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = classesMinimumLineSpacing
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: calendarClassSideInsets, bottom: 0.0, right: calendarClassSideInsets)
            height = (classesCellHeight + classesMinimumLineSpacing) * CGFloat(classesCellCount) - classesMinimumLineSpacing
            headerWidth = classesHeaderWidth
        }

        super.init(frame: frame, collectionViewLayout: layout)

        delegate = self
        dataSource = self

        backgroundColor = .clear

        register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.loadingCollectionViewCell)
        register(LoadingCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.loadingHeaderView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LoadingCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionViewType {
        case .smallGrid:
            let itemWidth = (collectionViewWidth - leftInset - smallGridMinimumInteritemSpacing - rightInset) / 2.0
            return CGSize(width: itemWidth, height: smallGridCellHeight)
        case .horizontallyScrolling:
            return CGSize(width: horizontallyScrollingCellWidth, height: horizontallyScrollingCellHeight)
        case .largeGrid:
            return CGSize(width: largeGridCellWidth, height: largeGridCellHeight)
        case .calendar:
            return CGSize(width: calendarCellSize, height: calendarCellSize)
        case .classes:
            return CGSize(width: collectionViewWidth - (2 * calendarClassSideInsets), height: classesCellHeight)
        case .none:
            return CGSize(width: 0, height: 0)
        }
    }

}

extension LoadingCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionViewType {
        case .smallGrid:
            return smallGridCellCount
        case .horizontallyScrolling:
            return horizontallyScrollingCellCount
        case .largeGrid:
            return largeGridCellCount
        case .calendar:
            return calendarCellCount
        case .classes:
            return classesCellCount
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: Identifiers.loadingCollectionViewCell, for: indexPath) as! LoadingCollectionViewCell
        if collectionViewType == .calendar {
            cell.contentView.layer.cornerRadius = calendarCellSize / 2.0
        }
        return cell
    }

}


