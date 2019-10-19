//
//  PriceInformationView.swift
//  Uplift
//
//  Created by Yana Sang on 10/17/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class PriceInformationView: UIView {

    /// MARK: - Private view vars
    private let backgroundView: UIView = UIView()
    private let costsList: UITextView = UITextView()
    private let itemsList: UITextView = UITextView()

    /// MARK: - Private layout vars
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupViews() {
        backgroundView.layer.cornerRadius = 4.0
        // replace with gray01 once yana/colors is merged
        backgroundView.backgroundColor = UIColor.colorFromCode(0xE5ECED)
        addSubview(backgroundView)
    }

    private func setupConstraints() {
        let backgroundHeight: CGFloat = 202
        let backgroundWidth: CGFloat = 68
        let contentPadding: CGFloat = 12
        let costsListWidth: CGFloat = 39

        backgroundView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.width.equalTo(backgroundWidth)
            make.height.equalTo(backgroundHeight)
        }

        costsList.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(contentPadding)
            make.trailing.bottom.equalToSuperview().inset(contentPadding)
            make.width.equalTo(costsListWidth)
        }

        itemsList.snp.makeConstraints{ make in
            make.top.leading.equalToSuperview().offset(contentPadding)
            make.trailing.equalTo(costsList.snp.leading).offset(-contentPadding)
            make.bottom.equalToSuperview().inset(contentPadding)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
