//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UIView {

    // MARK: - Public Vars
    var onChangeDay: ((Int) -> Void)?

    // MARK: - Private Vars
    private let timesText = NSMutableAttributedString()
    private let timesTextView = UITextView()
    private let paragraphStyle = NSMutableParagraphStyle()

    private var displayedText = ""
    private var emptyStateView: UIView?
    private var facilityDetail: FacilityDetail!
    private var hours: [FacilityHoursRange] = []
    private var paragraphStyleAttributes: [NSAttributedString.Key: Any] = [:]
    private var selectedDayIndex = 0
    
    static let emptyStateHeight: CGFloat = 151

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        timesText.mutableString.setString(displayedText)

        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.alignment = .center
        paragraphStyleAttributes = [
            .font: UIFont._16MontserratLight,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.primaryBlack
        ]

        timesTextView.attributedText = timesText
        timesTextView.backgroundColor = .primaryWhite
        timesTextView.font = ._16MontserratLight
        timesTextView.isScrollEnabled = false
        timesTextView.isEditable = false
        timesTextView.isSelectable = false
        timesTextView.textContainerInset = .zero
        timesTextView.textContainer.lineFragmentPadding = 0

        addSubview(timesTextView)

        setupConstraints()
    }

    func configure(facilityDetail: FacilityDetail, dayIndex: Int, onChangeDay: ((Int) -> Void)?) {
        self.facilityDetail = facilityDetail
        self.onChangeDay = onChangeDay
        self.selectedDayIndex = dayIndex

        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        timesTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    // MARK: - Update
    private func updateAppearance() {
        emptyStateView?.removeFromSuperview()

        updateTags()
        updateTimes()
    }

    private func updateTimes() {
        makeDisplayText(dayIndex: selectedDayIndex)
        updateAttributedText()
    }

    private func updateTags() {
        let tagLabelWidth = 81
        let tagLabelHeight = 17
        let tagSideOffset = 4.5
        let textLineHeight = timesTextView.font?.lineHeight ?? 0
        let textLineSpace: CGFloat = 5

        let dailyFacilityHoursRange = facilityDetail.times.filter { $0.dayOfWeek == selectedDayIndex }
        let restrictions = dailyFacilityHoursRange.flatMap { $0.timeRanges.map { $0.restrictions} }

        subviews.filter { $0 != timesTextView }.forEach { $0.removeFromSuperview() }

        for i in 0..<restrictions.count {
            if restrictions[i].isEmpty { // Ignore Blank Tags
                continue
            } else {
                let restrictionView = AdditionalInfoView()
                let spacing = (textLineHeight + textLineSpace) * CGFloat(i)
                let inset: CGFloat = 2

                restrictionView.configure(for: restrictions[i].lowercased())
                addSubview(restrictionView)
                restrictionView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(spacing + inset)
                    make.leading.equalTo(timesTextView.snp.trailing).offset(tagSideOffset)
                    make.width.equalTo(tagLabelWidth)
                    make.height.equalTo(tagLabelHeight)
                }
            }
        }
    }

    func updateAttributedText() {
        timesText.mutableString.setString(displayedText)
        let range = NSRange(location: 0, length: timesText.length)
        timesText.addAttributes(paragraphStyleAttributes, range: range)
        timesTextView.attributedText = timesText
        onChangeDay?(selectedDayIndex)
    }

    // MARK: - Helper
    func makeDisplayText(dayIndex: Int) {
        let dailyFacilityHoursRange = facilityDetail.times.filter { $0.dayOfWeek == dayIndex }
        hours = dailyFacilityHoursRange.flatMap { $0.timeRanges }
        let timeStrings: [String] = hours.map { getStringFromDailyGymHours(facilityHours: $0) }
        if let isEmpty = timeStrings.first?.isEmpty, isEmpty {
            displayedText = ""
            setupEmptyState()
        } else {
            displayedText = timeStrings.joined(separator: "\n")
        }
    }

    func getStringFromDailyGymHours(facilityHours: FacilityHoursRange) -> String {
        let openTime = facilityHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = facilityHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if facilityHours.openTime != facilityHours.closeTime {
            return "\(openTime) - \(closeTime)"
        }

        return ""
    }

    func setupEmptyState() {
        let emptyStateView = HoursEmptyStateView()
        addSubview(emptyStateView)

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.emptyStateView = emptyStateView
    }

    static func getTimesHeight(for dailyHours: DailyFacilityHoursRanges) -> CGFloat {
        let lineHeight: CGFloat = 19.6
        let lineSpacing: CGFloat = 5.0

        let hours = dailyHours.timeRanges
        let hoursCount = CGFloat(hours.count)
        let emptyState = hoursCount == 1 && hours[0].openTime == hours[0].closeTime
        return emptyState ? emptyStateHeight : lineHeight * hoursCount + lineSpacing * (hoursCount - 1)
    }

    func didChangeDay(day: WeekDay) {
        selectedDayIndex = day.index - 1
        updateAppearance()
    }

}
