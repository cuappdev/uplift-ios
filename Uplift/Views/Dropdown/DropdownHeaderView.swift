//
//  DropdownHeaderView.swift
//  
//
//  Created by Cameron Hamidi on 11/15/19.
//

import UIKit
import SnapKit

protocol DropdownHeaderViewDelegate: class {
    func didTapHeaderView()
}

class DropdownHeaderView: UIView {
    
    var titleLabel: UILabel!
    
    private let arrowHeight: CGFloat = 9
    private let arrowImageView = UIImageView()
    private let arrowWidth: CGFloat = 5
    private var isArrowRotated = false

    weak var delegate: DropdownHeaderViewDelegate?

    init(frame: CGRect, arrowImage: UIImage? = nil, arrowImageTrailingOffset: CGFloat = -24) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        
        titleLabel = UILabel()
        titleLabel.font = ._12MontserratBold
        titleLabel.textColor = .gray04
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        titleLabel.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        if let image = arrowImage {
            arrowImageView.image = image
        } else {
            // Default dropdown arrow.
            arrowImageView.image = UIImage(named: ImageNames.rightArrow)
        }
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(arrowImageTrailingOffset)
            make.height.equalTo(arrowHeight)
            make.width.equalTo(arrowWidth)
        }

        let openCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(openCloseDropdownGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rotateArrowDown() {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
        }
        isArrowRotated = true
    }

    func rotateArrowUp() {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
        isArrowRotated = false
    }

    @objc func didTapView() {
        delegate?.didTapHeaderView()
    }

}
