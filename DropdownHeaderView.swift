//
//  DropdownHeaderView.swift
//  
//
//  Created by Cameron Hamidi on 11/15/19.
//

import UIKit
import SnapKit

protocol DropdownHeaderViewDelegate {
    func didTapView()
}

class DropdownHeaderView: UIView {
    var delegate: HeaderViewDelegate?
    private var arrowImageView = UIImageView()
    private var arrowImageTrailingOffset: CGFloat = -24
    
    init(frame: CGRect, arrowImage: UIImage? = nil, arrowImageTrailingOffset: CGFloat = -24) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        if let image = arrowImage {
            arrowImageView.image = image
            self.arrowImageTrailingOffset = arrowImageTrailingOffset
            setupConstraints()
        }
        
        let openCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(openCloseDropdownGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(arrowImageTrailingOffset)
        }
    }

    @objc func didTapView() {
        delegate?.didTapView()
    }
}
