//
//  HistogramViewCell.swift
//  Uplift
//
//  Created by Kevin Chan on 11/6/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import AppDevHistogram
import UIKit

class HistogramViewCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let histogramView = HistogramView()

    // MARK: - Private data vars
    private let startHour = 6
    private let overflowedEndHour = 27
    private var busynessRatings: [Int] = (0..<24).map({ $0 })
    private let buynessLevelDescriptors = [
        ClientStrings.Histogram.busynessLevel1,
        ClientStrings.Histogram.busynessLevel2,
        ClientStrings.Histogram.busynessLevel3
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym) {
        busynessRatings = gym.popularTimesList[Date().getIntegerDayOfWeekToday()]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HistogramViewCell: HistogramViewDataSource {

    func numberOfDataPoints(for histogramView: HistogramView) -> Int {
        return overflowedEndHour - startHour
    }

    func histogramView(_ histogramView: HistogramView, relativeValueOfDataPointAt index: Int) -> Double {
        print(index)
        let maxBusynessRating = Double(busynessRatings.max() ?? 1)
        return Double(busynessRatings[getBusynessRatingsIndex(for: index)]) / maxBusynessRating
    }

    func histogramView(_ histogramView: HistogramView, descriptionForDataPointAt index: Int) -> NSAttributedString? {
        return NSAttributedString(
            string: "gottem",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.yellow
            ]
        )
    }

    func numberOfDataPointsPerTickMark(for histogramView: HistogramView) -> Int? {
        return 3
    }

    func histogramView(_ histogramView: HistogramView, titleForTickMarkAt index: Int) -> String? {
        let tickHour = containOverflowedMilitaryHour(hour: startHour + index)
        return formattedHourForTime(militaryHour: tickHour)
    }

    // MARK: - Private helpers
    private func getBusynessLevelDescriptor(for index: Int) -> String {
        let highThreshold = 57
        let mediumThreshold = 25
        let busynessRating = busynessRatings[getBusynessRatingsIndex(for: index)]

        if busynessRating < mediumThreshold {
            return buynessLevelDescriptors[0]
        } else if busynessRating < highThreshold {
            return buynessLevelDescriptors[1]
        } else {
            return buynessLevelDescriptors[2]
        }
    }

    private func getBusynessRatingsIndex(for index: Int) -> Int {
        return (index + 6) % 24
    }

    /// Overflowed military hour is a time between 0...47
    private func containOverflowedMilitaryHour(hour: Int) -> Int {
        return (hour >= 24) ? hour - 24 : hour
    }

    private func formattedHourForTime(militaryHour: Int) -> String {
        var formattedHour: String!
        if militaryHour > 12 {
            formattedHour = "\(militaryHour - 12)p"
        } else if militaryHour == 12 {
            formattedHour = "12p"
        } else if militaryHour > 0 {
            formattedHour = "\(militaryHour)a"
        } else {
            formattedHour = "12a"
        }
        return formattedHour
    }

}

extension HistogramViewCell {

    func setupViews() {
        histogramView.dataSource = self
        contentView.addSubview(histogramView)
        histogramView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(166)
        }

        histogramView.reloadData()
    }

    func setupConstraints() {

    }

}
