//
//  LoadingScrollView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

enum LoadingCollectionViewType {
    case smallGrid
    case largeGrid
    case horizontallyScrolling
}

class LoadingScrollView: UIView {
    
    static let defaultLoadingArrangement: [LoadingCollectionViewType] = [.smallGrid, .horizontallyScrolling, .largeGrid]
    
    var collectionViews: [UICollectionView] = []

    init(frame: CGRect, collectionViewTypes: [LoadingCollectionViewType] = LoadingScrollView.defaultLoadingArrangement) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectyionView(szieForItem at: indexPath) {
        
    }
}
