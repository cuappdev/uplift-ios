//
//  GamesListHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 3/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class GamesListHeaderView: UICollectionReusableView {
    
    static let height = 29
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        label.textAlignment = .center
        label.textColor = .black
        label.font = ._24BebasBold
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(for text: String) {
        label.text = text
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
