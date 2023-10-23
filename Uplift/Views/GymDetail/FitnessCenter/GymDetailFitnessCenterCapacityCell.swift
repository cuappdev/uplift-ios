//
//  GymDetailFitnessCenterCapacityCell.swift
//  Uplift
//
//  Created by alden lamp on 10/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class GymDetailFitnessCenterCapacityCell: UITableViewCell {

    enum LayoutConstants {
        static let lineWidth: CGFloat = 20
        static let capacityCirleTopPadding: CGFloat = 15
        static let lastUpdatedTopPadding: CGFloat = 5
        static let lastUpdatedLabelHeight: CGFloat = 10
    }

    let capacitiesLabel = {
        let label = UILabel()
        label.font = ._16MontserratBold
        label.textColor = .primaryBlack
        label.textAlignment = .center
        label.text = ClientStrings.GymDetail.capacitiesLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var capacityView: CapacityView!
    var capacityViewWidth: CGFloat!

    let lastUpdatedLabel = {
        let label = UILabel()
        label.font = ._12MontserratMedium
        label.textColor = .gray02
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Updated: 2:30 PM"
        return label
    }()

    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .gray01
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    static let reuseId = "GymDetailFitnessCenterCapacityCellReuseID"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        capacityViewWidth = self.contentView.frame.width / 2
        capacityView = CapacityView(width: capacityViewWidth, lineWidth: LayoutConstants.lineWidth)
        capacityView.translatesAutoresizingMaskIntoConstraints = false
        capacityView.configure(percent: 0.7, progressColor: .accentOrange)

        contentView.addSubview(capacitiesLabel)
        contentView.addSubview(capacityView)
        contentView.addSubview(lastUpdatedLabel)
        contentView.addSubview(dividerView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        capacitiesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(GymDetailConstraints.verticalPadding)
            make.height.equalTo(GymDetailConstraints.titleLabelHeight)
        }

        capacityView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(capacityViewWidth)
            make.top.equalTo(capacitiesLabel.snp.bottom).offset(LayoutConstants.capacityCirleTopPadding)
        }

        lastUpdatedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(capacityView.snp.bottom).offset(LayoutConstants.lastUpdatedTopPadding)
            make.height.equalTo(LayoutConstants.lastUpdatedLabelHeight)
        }

        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(GymDetailConstraints.dividerViewHeight)
            make.bottom.equalToSuperview()
        }
    }

    func configure(capacity: Capacity) {
        self.capacityView.configure(percent: capacity.percent, progressColor: capacity.status.color)
        self.lastUpdatedLabel.text = "Updated: \(Date.getTimeStringFromDate(time: capacity.updated))"
    }

    static func getHeight(capacityHeight: CGFloat) -> CGFloat {
        var height: CGFloat = GymDetailConstraints.verticalPadding
        height += GymDetailConstraints.titleLabelHeight
        height += LayoutConstants.capacityCirleTopPadding
        height += capacityHeight
        height += LayoutConstants.lastUpdatedTopPadding
        height += LayoutConstants.lastUpdatedLabelHeight
        return height
    }

}
