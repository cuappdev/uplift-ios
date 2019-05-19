//
//  ClassDetailTimeCell.swift
//  Fitness
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ClassDetailTimeCellDelegate: class {
    func classDetailTimeCellShouldAddToCalendar()
}

class ClassDetailTimeCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let addToCalendarButton = UIButton()
    private let addToCalendarLabel = UILabel()
    private let dateDivider = UIView()

    // MARK: - Private data vars
    private weak var delegate: ClassDetailTimeCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ClassDetailTimeCellDelegate, gymClassInstance: GymClassInstance) {
        self.delegate = delegate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateLabel.text = dateFormatter.string(from: gymClassInstance.startTime)

        // Set time zone to EDT
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
        dateFormatter.dateFormat = "h:mm a"
        let timeLabelText = dateFormatter.string(from: gymClassInstance.startTime) + " - " + dateFormatter.string(from: gymClassInstance.endTime)
        timeLabel.text = timeLabelText
    }

    // MARK: - Targets
    @objc func addToCalendar() {
        delegate?.classDetailTimeCellShouldAddToCalendar()
    }

    // MARK: - Private helpers
    private func setupViews() {
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.sizeToFit()
        contentView.addSubview(dateLabel)

        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.textColor = .fitnessBlack
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)

        addToCalendarButton.setImage(#imageLiteral(resourceName: "calendar-icon"), for: .normal) //temp
        addToCalendarButton.sizeToFit()
        contentView.addSubview(addToCalendarButton)

        addToCalendarLabel.text = "ADD TO CALENDAR"
        addToCalendarLabel.font = ._8SFBold
        addToCalendarLabel.textAlignment = .center
        addToCalendarLabel.textColor = .fitnessBlack
        addToCalendarLabel.sizeToFit()
        addToCalendarButton.addTarget(self, action: #selector(addToCalendar), for: .touchUpInside)
        contentView.addSubview(addToCalendarLabel)

        dateDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dateDivider)
    }

    private func setupConstraints() {
        let addToCalendarButtonSize = CGSize(width: 23, height: 23)
        let addToCalendarButtonTopPadding = 26
        let addToCalendarLabelHeight = 10
        let addToCalendarLabelTopPadding = 5
        let dateDividerHeight = 1
        let dateDividerTopPadding = 32
        let dateLabelHeight = 19
        let dateLabelTopPadding = 36
        let timeLabelHeight = 19
        let timeLabelTopPadding = 8

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(dateLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(dateLabelHeight)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(timeLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(timeLabelHeight)
        }

        addToCalendarButton.snp.makeConstraints { make in
            make.size.equalTo(addToCalendarButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(addToCalendarButtonTopPadding)
        }

        addToCalendarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(addToCalendarButton.snp.bottom).offset(addToCalendarLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(addToCalendarLabelHeight)
        }

        dateDivider.snp.makeConstraints { make in
            make.height.equalTo(dateDividerHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(addToCalendarLabel.snp.bottom).offset(dateDividerTopPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
