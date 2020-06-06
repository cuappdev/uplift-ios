//
//  DropdownHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 11/15/19.
//  Copyright © 2019 Uplift. All rights reserved.
//

import SnapKit
import UIKit

protocol DropdownHeaderViewDelegate: class {

    func didTapHeaderView()

}

class DropdownHeaderView: UIView {

    private let arrowImageView = UIImageView()
    private let filtersAppliedCircle: UIView = UIView()
    private let selectedFiltersLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()

    private let arrowHeight: CGFloat = 9
    private let arrowWidth: CGFloat = 5

    private var isArrowRotated = false

    weak var delegate: DropdownHeaderViewDelegate?

    var filtersApplied: Bool = false {
        didSet {
            self.filtersAppliedCircle.layer.backgroundColor = filtersApplied
                ? UIColor.primaryYellow.cgColor
                : UIColor.primaryWhite.cgColor
        }
    }
    var selectedFilters: [String] = [] {
        didSet {
            selectedFiltersLabel.text = selectedFilters.joined(separator: "  ·  ")
        }
    }

    init(title: String, arrowImage: UIImage? = nil, arrowImageTrailingOffset: CGFloat = -24) {
        super.init(frame: .zero)

        isUserInteractionEnabled = true

        titleLabel.text = title
        titleLabel.font = ._12MontserratBold
        titleLabel.textColor = .gray04
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        filtersAppliedCircle.layer.cornerRadius = 4
        addSubview(filtersAppliedCircle)

        selectedFiltersLabel.textAlignment = .right
        selectedFiltersLabel.font = UIFont._14MontserratRegular
        selectedFiltersLabel.textColor = .primaryBlack
        selectedFiltersLabel.adjustsFontSizeToFitWidth = false
        selectedFiltersLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        addSubview(selectedFiltersLabel)

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

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
        }

        filtersAppliedCircle.snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
            make.centerY.equalTo(titleLabel)
        }

        selectedFiltersLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-12)
            make.centerY.equalTo(filtersAppliedCircle)
            make.leading.equalTo(filtersAppliedCircle.snp.trailing).offset(20)
       }
    }

    func updateDropdownHeader(selectedFilters: [String]) {
        filtersApplied = !selectedFilters.isEmpty
        self.selectedFilters = selectedFilters
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rotateArrow() {
        if isArrowRotated {
            rotateArrowUp()
        } else {
            rotateArrowDown()
        }
    }

    func rotateArrowDown() {
        arrowImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
        isArrowRotated = true
    }

    func rotateArrowUp() {
        arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
        isArrowRotated = false
    }

    @objc func didTapView() {
        rotateArrow()
        delegate?.didTapHeaderView()
    }

}
