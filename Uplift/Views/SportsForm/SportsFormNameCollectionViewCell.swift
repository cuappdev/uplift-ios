//
//  SportsFormNameCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 5/24/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFormNameCollectionViewCell: UICollectionViewCell {
    
    private let divider = UIView()
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.font = ._16MontserratMedium
        textField.textColor = .primaryBlack
        textField.placeholder = "Game Name"
        textField.delegate = self
        textField.returnKeyType = .done
        contentView.addSubview(textField)
        
        divider.backgroundColor = .gray01
        contentView.addSubview(divider)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let dividerHeight = 1
        let horizontalPadding = 16
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(dividerHeight)
        }
    }
    
    func getSportName() -> String {
        return textField.text ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SportsFormNameCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
