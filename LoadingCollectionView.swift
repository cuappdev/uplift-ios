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
    case largeGrid
    case horizontallyScrolling
    case calendar
    case classes
}

class LoadingCollectionView: UICollectionView {

    let collectionViewType: LoadingCollectionViewType!
    let collectionViewWidth: CGFloat!
    
    var height: CGFloat = 0

    var headerWidth: CGFloat = 0

    init(frame: CGRect, collectionViewType: LoadingCollectionViewType, collectionViewWidth: CGFloat) {
        self.collectionViewType = collectionViewType
        self.collectionViewWidth = collectionViewWidth

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 12)

        switch collectionViewType {
        case .smallGrid:
            let itemWidth = (collectionViewWidth - 16 - 16 - 12) / 2.0
            layout.itemSize = CGSize(width: itemWidth, height: 60)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 16
            height += (16 + 60) * 3 - 16
            headerWidth = 75
        case .horizontallyScrolling:
            layout.itemSize = CGSize(width: 228, height: 195)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 18
            height += 195
            headerWidth = 135
        case .largeGrid:
            layout.itemSize = CGSize(width: 164, height: 107)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 15
            height += 107
            headerWidth = 135
        case .calendar:
            layout.itemSize = CGSize(width: 24, height: 24)
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 43.0
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            height += 24
            headerWidth = 59
        case .classes:
            let itemWidth = collectionViewWidth - 16 - 16
            layout.itemSize = CGSize(width: itemWidth, height: 100)
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            height += (100 + 12) * 5 - 12
            headerWidth = 59
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
            let itemWidth = (collectionViewWidth - 16 - 16 - 12) / 2.0
            return CGSize(width: itemWidth, height: 60)
        case .horizontallyScrolling:
            return CGSize(width: 228, height: 195)
        case .largeGrid:
            return CGSize(width: 164, height: 107)
        case .calendar:
            return CGSize(width: 24, height: 24)
        case .classes:
            return CGSize(width: collectionViewWidth - 16 - 16, height: 100)
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
            return 5
        case .horizontallyScrolling:
            return 3
        case .largeGrid:
            return 2
        case .calendar:
            return 10
        case .classes:
            return 5
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: Identifiers.loadingCollectionViewCell, for: indexPath) as! LoadingCollectionViewCell
        if collectionViewType == .calendar {
            cell.contentView.layer.cornerRadius = 24 / 2.0
        }
        return cell
    }

}


