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
    private let arrowImageView = UIImageView()

    private var isArrowRotated = false

    weak var delegate: DropdownHeaderViewDelegate?

    init(frame: CGRect, arrowImage: UIImage? = nil, arrowImageTrailingOffset: CGFloat = -24) {
        super.init(frame: frame)

        isUserInteractionEnabled = true

        if let image = arrowImage {
            arrowImageView.image = image
            arrowImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(arrowImageTrailingOffset)
            }
        }

        let openCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(openCloseDropdownGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapView() {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: self.isArrowRotated ? 0 : .pi/2)
        }
        delegate?.didTapHeaderView()
    }
}
