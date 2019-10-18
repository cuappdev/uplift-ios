//
//  ClassDetailTimeCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ClassDetailTimeCellDelegate: class {
    func classDetailTimeCellShouldAddToCalendar()
}

class ClassDetailTimeCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let addToCalendarButtonHeight: CGFloat = 21
        static let addToCalendarButtonTopPadding: CGFloat = 26
        static let addToCalendarLabelHeight: CGFloat = 10
        static let addToCalendarLabelTopPadding: CGFloat = 5
        static let timeLabelTopPadding: CGFloat = 8
    }

    // MARK: - Private view vars
    private let addToCalendarButton = UIButton()
    private let addToCalendarLabel = UILabel()
    private let dateLabel = UILabel()
    private let dividerView = UIView()
    private let timeLabel = UILabel()

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
        dateLabel.textColor = .primaryBlack
        dateLabel.sizeToFit()
        contentView.addSubview(dateLabel)

        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.textColor = .primaryBlack
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)

        addToCalendarButton.setImage(UIImage(named: ImageNames.calendar), for: .normal) //temp
        addToCalendarButton.sizeToFit()
        contentView.addSubview(addToCalendarButton)

        addToCalendarLabel.text = ClientStrings.ClassDetail.addToCalendarButton
        addToCalendarLabel.font = ._8SFLight
        addToCalendarLabel.textAlignment = .center
        addToCalendarLabel.textColor = .primaryBlack
        addToCalendarLabel.sizeToFit()
        addToCalendarButton.addTarget(self, action: #selector(addToCalendar), for: .touchUpInside)
        contentView.addSubview(addToCalendarLabel)

        dividerView.backgroundColor = .gray01
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let addToCalendarButtonWidth = 21

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(Constraints.verticalPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constraints.titleLabelHeight)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.timeLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constraints.titleLabelHeight)
        }

        addToCalendarButton.snp.makeConstraints { make in
            make.width.equalTo(addToCalendarButtonWidth)
            make.height.equalTo(Constants.addToCalendarButtonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(Constants.addToCalendarButtonTopPadding)
        }

        addToCalendarLabel.snp.makeConstraints { make in
            make.top.equalTo(addToCalendarButton.snp.bottom).offset(Constants.addToCalendarLabelTopPadding)
            make.height.equalTo(Constants.addToCalendarLabelHeight)
            make.centerX.equalToSuperview()
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(Constraints.dividerViewHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(addToCalendarLabel.snp.bottom).offset(Constraints.verticalPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
