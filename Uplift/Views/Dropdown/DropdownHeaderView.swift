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
    
    var filtersAppliedCircle: UIView!
    var selectedFiltersLabel: UILabel!
    var titleLabel: UILabel!
    
    private let arrowHeight: CGFloat = 9
    private let arrowImageView = UIImageView()
    private let arrowWidth: CGFloat = 5
    private var isArrowRotated = false
    
    weak var delegate: DropdownHeaderViewDelegate?
    
    var filtersApplied: Bool = false {
        didSet {
            self.filtersAppliedCircle.layer.backgroundColor = filtersApplied ? UIColor.primaryYellow.cgColor : UIColor.primaryWhite.cgColor
        }
    }
    var selectedFilters: [String] = [] {
        didSet {
            selectedFiltersLabel.text = selectedFilters.joined(separator: "  ·  ")
        }
    }

    init(frame: CGRect, arrowImage: UIImage? = nil, arrowImageTrailingOffset: CGFloat = -24) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        
        titleLabel = UILabel()
        titleLabel.font = ._12MontserratBold
        titleLabel.textColor = .gray04
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        filtersAppliedCircle = UIView()
        filtersAppliedCircle.layer.cornerRadius = 4
        addSubview(filtersAppliedCircle)

        selectedFiltersLabel = UILabel()
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
        
        titleLabel.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        filtersAppliedCircle.snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
            make.centerY.equalTo(titleLabel)
        }
        
        selectedFiltersLabel.snp.makeConstraints { make in
               make.trailing.equalTo(arrowImageView.snp.leading).offset(-12)
               make.centerY.equalTo(filtersAppliedCircle)
        make.leading.equalTo(self.snp.centerX)
           }
    }
    
    func updateDropdownHeader(selectedFilters: [String]) {
        self.filtersApplied = !selectedFilters.isEmpty
        self.selectedFilters = selectedFilters
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
