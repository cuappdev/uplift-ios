//
//  LoadingCollectionHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class LoadingCollectionHeaderView: UICollectionReusableView {

    private let titleView = UIView()
    private let titleViewHeight: CGFloat = 12.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray01
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
