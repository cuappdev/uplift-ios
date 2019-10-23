//
//  EquipmentListItemCell.swift
//  Uplift
//
//  Created by Yana Sang on 10/9/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class EquipmentListItemCell: ListItemCollectionViewCell<EquipmentCategory> {

    // MARK: - Public static vars
    static let identifier = Identifiers.gymEquipmentCell

    // MARK: - Private view vars
    private let titleLabel = UILabel()
    private let equipmentList = UITextView()
    private let quantityList = UITextView()

    // MARK: - Private layout vars
    private let listsSpacing: CGFloat = 12
    private var equipmentListTrailingConstraint: Constraint?

    // MARK: - Private data vars
    private var equipment: [Equipment] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        contentView.layer.cornerRadius = 4
        contentView.layer.backgroundColor = UIColor.white.cgColor

        // SHADOWING
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0)
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.masksToBounds = false

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    override func configure(for equipmentCategory: EquipmentCategory) {
        super.configure(for: equipmentCategory)

        titleLabel.text = equipmentCategory.categoryName
        equipment = equipmentCategory.equipment
        equipmentList.attributedText = generateListString(for: equipment.map { $0.name })
        quantityList.attributedText = generateListString(for: equipment.map { $0.quantity }, alignment: .right)
        quantityList.sizeToFit()

        equipmentListTrailingConstraint?.update(offset: -listsSpacing)
    }

    func setupViews() {
        titleLabel.font = ._14MontserratSemiBold
        titleLabel.textColor = .fitnessLightBlack
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)

        equipmentList.isEditable = false
        equipmentList.isSelectable = false
        equipmentList.isScrollEnabled = false
        equipmentList.textContainerInset = .zero
        equipmentList.textContainer.lineFragmentPadding = 0
        contentView.addSubview(equipmentList)

        quantityList.isEditable = false
        quantityList.isSelectable = false
        quantityList.isScrollEnabled = false
        quantityList.textContainerInset = .zero
        quantityList.textContainer.lineFragmentPadding = 0
        contentView.addSubview(quantityList)
    }

    func setupConstraints() {
        let contentPadding: CGFloat = 16
        let equipmentTopPadding: CGFloat = 4
        let labelHeight: CGFloat = 20

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.leading.top.equalToSuperview().offset(contentPadding)
            make.trailing.equalToSuperview().inset(contentPadding)
        }

        quantityList.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(equipmentTopPadding)
            make.trailing.bottom.equalToSuperview().inset(contentPadding)
        }

        equipmentList.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(equipmentTopPadding)
            equipmentListTrailingConstraint = make.trailing.equalTo(quantityList.snp.leading).offset(0).constraint
            make.leading.equalToSuperview().offset(contentPadding)
            make.bottom.equalToSuperview().inset(contentPadding)
        }
    }

    private func generateListString(for stringList: [String],
                                    alignment: NSTextAlignment = .left) -> NSAttributedString {
        let listString = stringList.joined(separator: "\n")

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        style.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._12MontserratLight!,
            .paragraphStyle: style
        ]

        return NSAttributedString(string: listString, attributes: attributes)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
