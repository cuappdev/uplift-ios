//
//  EquipmentListItemCell.swift
//  Uplift
//
//  Created by Yana Sang on 10/9/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class EquipmentListItemCell: ListItemCollectionViewCell<EquipmentCategory> {

    // MARK: - Public static vars
    static let identifier = Identifiers.gymEquipmentCell

    // MARK: - Private view vars
    private let titleLabel = UILabel()
    private let equipmentList = UITextView()
    private let quantityList = UITextView()

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
        equipmentList.attributedText = generateEquipmentString()
        quantityList.attributedText = generateQuantityString()
    }

    func setupViews() {
        titleLabel.font = ._14MontserratSemiBold
        titleLabel.textColor = .fitnessLightBlack
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)

//        equipmentList.font = ._12MontserratLight
        equipmentList.isEditable = false
        equipmentList.isScrollEnabled = false
        equipmentList.textContainerInset = .zero
        equipmentList.textContainer.lineFragmentPadding = 0
        contentView.addSubview(equipmentList)

//        quantityList.font = ._12MontserratLight
        quantityList.textAlignment = .right
        quantityList.isEditable = false
        quantityList.isScrollEnabled = false
        quantityList.textContainerInset = .zero
        quantityList.textContainer.lineFragmentPadding = 0

        contentView.addSubview(quantityList)
    }

    func setupConstraints() {
        let contentPadding: CGFloat = 16
        let equipmentTopPadding: CGFloat = 2
        let labelHeight: CGFloat = 20
        let quantityListWidth: CGFloat = 25

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.leading.top.equalToSuperview().offset(contentPadding)
            make.trailing.equalToSuperview().inset(contentPadding)
        }

        quantityList.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(equipmentTopPadding)
            make.trailing.bottom.equalToSuperview().inset(contentPadding)
            make.width.equalTo(quantityListWidth)
        }

        equipmentList.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(equipmentTopPadding)
            make.leading.equalToSuperview().offset(contentPadding)
            make.bottom.equalToSuperview().inset(contentPadding)
            make.trailing.equalTo(quantityList.snp.leading).offset(-contentPadding)
        }
    }

    private func generateEquipmentString() -> NSAttributedString {
        var equipmentList = ""
        equipment.forEach { equipmentEntry in
            equipmentList += "\(equipmentEntry.name)\n"
        }

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._12MontserratLight!,
            .paragraphStyle: style
        ]
        return NSAttributedString(string: equipmentList, attributes: attributes)
    }

    private func generateQuantityString() -> NSAttributedString {
        var quantityList = ""
        equipment.forEach { equipmentEntry in
            quantityList += "\(equipmentEntry.count)\n"
        }

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        style.alignment = .right
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._12MontserratLight!,
            .paragraphStyle: style
        ]

        return NSAttributedString(string: quantityList, attributes: attributes)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
