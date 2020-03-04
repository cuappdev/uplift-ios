//
//  LoadingHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class LoadingHeaderView: UIView {

    private let titleView = UIView()
    
    // MARK: - Constraint constants
    private let titleViewHeight: CGFloat = 20.0
    private let leadingOffset = 24
    private let width = 186
    private let height = 20
    private let bottomOffset = -24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray01
        isSkeletonable = true
        showAnimatedSkeleton()
        
        titleView.backgroundColor = .white
        titleView.layer.cornerRadius = titleViewHeight / 2.0
        addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.bottom.equalToSuperview().offset(bottomOffset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
