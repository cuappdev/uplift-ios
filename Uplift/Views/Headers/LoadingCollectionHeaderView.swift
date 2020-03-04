//
//  LoadingCollectionHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SkeletonView
import UIKit

class LoadingCollectionHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray01

        isSkeletonable = true
        showAnimatedSkeleton()
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
