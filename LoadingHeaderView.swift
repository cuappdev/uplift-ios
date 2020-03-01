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
    let titleViewHeight: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray01
        isSkeletonable = true
        showAnimatedSkeleton()
        
        titleView.backgroundColor = .white
        titleView.layer.cornerRadius = titleViewHeight / 2.0
        addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(186)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
