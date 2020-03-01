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

    let titleView = UIView()
    
    // MARK: - Constraint constants
    let titleViewHeight: CGFloat = 20.0
    let leadingOffset = 24
    let width = 186
    let height = 20
    let bottomOffset = -24
    
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
