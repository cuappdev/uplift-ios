//
//  DropdownViewCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class DropdownViewCell: UITableViewCell {

    static let height: CGFloat = 32

    // MARK: - INITIALIZATION
    private let checkBox = UIView()
    private let checkBoxColoring = UIView()
    private let titleLabel = UILabel()

    var wasSelected = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .clear

        // TITLE LABEL
        titleLabel.sizeToFit()
        titleLabel.font = ._14MontserratLight
        titleLabel.textColor = .primaryBlack
        titleLabel.text = ""
        addSubview(titleLabel)

        // CHECKBOX
        checkBox.layer.cornerRadius = 3
        checkBox.layer.borderColor = UIColor.gray04.cgColor
        checkBox.layer.borderWidth = 0.5
        checkBox.layer.masksToBounds = false
        addSubview(checkBox)

        // CHECKBOX COLOURING
        checkBoxColoring.backgroundColor = .white
        checkBoxColoring.layer.cornerRadius = 1
        checkBox.addSubview(checkBoxColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func configure(for title: String, selected: Bool) {
        titleLabel.text = title
        wasSelected = selected
        checkBoxColoring.backgroundColor = wasSelected ? .primaryYellow : .white
    }

    func getTitle() -> String {
        return titleLabel.text ?? ""
    }

    func setTitle(to string: String) {
        titleLabel.text = string
    }

    func select() {
        wasSelected = !wasSelected
        checkBoxColoring.backgroundColor = wasSelected ? .primaryYellow : .white
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        let checkBoxBottomOffset = -10
        let checkBoxColoringOffsets = 3
        let checkBoxTopOffset = 2
        let checkBoxTrailingOffset = -23
        let checkBoxWidth = 20
        let titleLabelBottomOffset = -16
        let titleLabelLeadingOffset = 16

        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(titleLabelLeadingOffset)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(titleLabelBottomOffset)
        }

        checkBox.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(checkBoxTopOffset)
            make.trailing.equalToSuperview().offset(checkBoxTrailingOffset)
            make.width.equalTo(checkBoxWidth)
            make.bottom.equalToSuperview().offset(checkBoxBottomOffset)
        }

        checkBoxColoring.snp.updateConstraints { make in
            make.top.leading.equalToSuperview().offset(checkBoxColoringOffsets)
            make.bottom.trailing.equalToSuperview().offset(-checkBoxColoringOffsets)
        }
    }
    
}
