//
//  DropdownHeaderView.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

class OldDropdownHeaderView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.dropdownViewCell
    var downArrow: UIImageView!
    var filtersAppliedCircle: UIView!
    var rightArrow: UIImageView!
    var selectedFiltersLabel: UILabel!
    var titleLabel: UILabel!
    
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

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.white.cgColor

        titleLabel = UILabel()
        titleLabel.font = ._12MontserratBold
        titleLabel.textColor = .gray04
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        
        filtersAppliedCircle = UIView()
        filtersAppliedCircle.layer.cornerRadius = 4
        contentView.addSubview(filtersAppliedCircle)

        selectedFiltersLabel = UILabel()
        selectedFiltersLabel.textAlignment = .right
        selectedFiltersLabel.font = UIFont._14MontserratRegular
        selectedFiltersLabel.textColor = .primaryBlack
        selectedFiltersLabel.adjustsFontSizeToFitWidth = false
        selectedFiltersLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(selectedFiltersLabel)

        rightArrow = UIImageView(image: UIImage(named: ImageNames.rightArrow))
        contentView.addSubview(rightArrow)
        
        downArrow = UIImageView(image: .none)
        contentView.addSubview(downArrow)
    }

    func updateDropdownHeader(selectedFilters: [String]) {
        self.filtersApplied = !selectedFilters.isEmpty
        self.selectedFilters = selectedFilters
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupConstraints() {
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
            make.trailing.equalTo(rightArrow.snp.leading).offset(-12)
            make.centerY.equalTo(filtersAppliedCircle)
            make.leading.equalTo(contentView.snp.centerX)
        }

        rightArrow.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.right.equalToSuperview().offset(-31)
            make.left.equalTo(rightArrow.snp.right).offset(-8)
        }

        downArrow.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(6)
            make.right.equalToSuperview().offset(-29)
            make.left.equalTo(downArrow.snp.right).offset(-12)
        }
    }
}
