//
//  PriceInformationView.swift
//  Uplift
//
//  Created by Yana Sang on 10/17/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class PriceInformationView: UIView {
    // MARK: - Private view vars
    private let backgroundView: UIView = UIView()
    private let costsList: UITextView = UITextView()
    private let itemsList: UITextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupViews() {
        backgroundView.layer.cornerRadius = 4.0
        backgroundView.backgroundColor = 
    }

    private func setupConstraints() {
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
