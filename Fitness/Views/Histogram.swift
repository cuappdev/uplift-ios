//
//  Histogram.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/23/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
//  Creates a histogram styled after the gym-detail-view histogram
//  on zeplin. Has data.count bars with ticks in bewteen
//  Must be initialized with the suspected frame width to correctly
//  function.

import UIKit
import SnapKit

class Histogram: UIView {

    // MARK: - INITIALIZATION
    var bars: [UIView]!
    var data: [Int]!

    /// index of bars representing the bar that is currently selected. Must be in range 0..bars.count-1
    var selectedIndex: Int!
    var selectedLine: UIView!
    var selectedTime: UILabel!

    let highThreshold = 85
    let mediumThreshold = 43
    let secondsPerHour: Double = 3600.0
    let timeDescriptors = ["Not too busy", "A little busy", "As busy as it gets"]
    var selectedTimeDescriptor: UILabel!

    var hours: DailyGymHours!
    var openHour: Int!

    var bottomAxis: UIView!
    var bottomAxisTicks: [UIView]!

    init(frame: CGRect, data: [Int], todaysHours: DailyGymHours) {
        super.init(frame: frame)
        self.data = data
        self.hours = todaysHours

        // AXIS
        bottomAxis = UIView()
        bottomAxis.backgroundColor = .fitnessLightGrey
        addSubview(bottomAxis)

        bottomAxisTicks = []
        openHour = Calendar.current.component(.hour, from: todaysHours.openTime)
        let closeHour = Calendar.current.component(.hour, from: todaysHours.closeTime)

        for _ in openHour..<(closeHour - 1) {
            let tick = UIView()
            tick.backgroundColor = .fitnessLightGrey
            addSubview(tick)
            bottomAxisTicks.append(tick)
        }

        // BARS
        bars = []
        for _ in openHour..<closeHour {
            let bar = UIView()
            bar.backgroundColor = .fitnessYellow
            addSubview(bar)
            bars.append(bar)

            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.selectBar(sender:)))
            bar.addGestureRecognizer(gesture)
        }

        // TIME
        let currentHour = Calendar.current.component(.hour, from: Date())

        if currentHour >= closeHour {
            selectedIndex = bars.count - 1
        } else if currentHour < openHour {
            selectedIndex = 0
        } else {
            selectedIndex = currentHour - openHour
        }

        if selectedIndex < bars.count {
            bars[selectedIndex].backgroundColor = UIColor(red: 216/255, green: 200/255, blue: 0, alpha: 1.0)
        }

        // SELECTED INFO
        selectedLine = UIView()
        selectedLine.backgroundColor = .fitnessLightGrey
        addSubview(selectedLine)

        selectedTime = UILabel()
        selectedTime.textColor = .fitnessDarkGrey
        selectedTime.font = ._12LatoBold
        selectedTime.textAlignment = .right
        selectedTime.text = todaysHours.openTime.addingTimeInterval( Double(selectedIndex) * secondsPerHour ).getStringOfDatetime(format: "ha :")
        addSubview(selectedTime)

        selectedTimeDescriptor = UILabel()
        selectedTimeDescriptor.textColor = .fitnessDarkGrey
        selectedTimeDescriptor.font = ._12LatoRegular
        selectedTimeDescriptor.textAlignment = .left
        if data[selectedIndex + openHour - 1] < mediumThreshold {
            selectedTimeDescriptor.text = timeDescriptors[0]
        } else if data[selectedIndex + openHour - 1] < highThreshold {
            selectedTimeDescriptor.text = timeDescriptors[1]
        } else {
            selectedTimeDescriptor.text = timeDescriptors[2]
        }
        selectedTimeDescriptor.sizeToFit()
        addSubview(selectedTimeDescriptor)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        // AXIS
        bottomAxis.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(2)
        }

        let tickSpacing = (Int(frame.width) - bottomAxisTicks.count * 2 - 4) / (bottomAxisTicks.count + 1)
        let padding = Int(frame.width) - (tickSpacing * (bottomAxisTicks.count + 1) + 4 + bottomAxisTicks.count * 2)

        for i in 0..<bottomAxisTicks.count {

            let tick = bottomAxisTicks[i]
            let tickWidth: CGFloat = 2
            let tickHeight: CGFloat = 3

            tick.snp.makeConstraints { make in
                if i == 0 {
                    make.leading.equalToSuperview().offset(padding / 2 + tickSpacing)
                } else {
                    make.leading.equalTo(bottomAxisTicks[i - 1].snp.trailing).offset(tickSpacing)
                }
                make.top.equalTo(bottomAxis.snp.top)
                make.width.equalTo(tickWidth)
                make.height.equalTo(tickHeight)
            }
        }

        // BARS
        for i in 0..<bars.count {

            let bar = bars[i]

            bar.snp.makeConstraints { make in
                make.bottom.equalTo(bottomAxis.snp.top)
                if i == 0 {
                    make.width.equalTo(tickSpacing)
                    make.trailing.equalTo(bottomAxisTicks[i].snp.leading)
                } else if i == bars.count - 1 {
                    make.width.equalTo(tickSpacing)
                    make.leading.equalTo(bottomAxisTicks[i - 1].snp.trailing)
                } else {
                    make.leading.equalTo(bottomAxisTicks[i - 1].snp.trailing)
                    make.trailing.equalTo(bottomAxisTicks[i].snp.leading)
                }
                let height = 72 * (data[i + openHour]) / 100
                make.height.equalTo(height)
            }
        }

        setupSelectedConstraints()
    }

    func setupSelectedConstraints() {
        if selectedIndex < bars.count {
            selectedLine.snp.remakeConstraints { make in
                make.centerX.equalTo(bars[selectedIndex].snp.centerX)
                make.bottom.equalTo(bars[selectedIndex].snp.top)
                make.width.equalTo(2)
                make.top.equalToSuperview().offset(26)
            }
        }

        selectedTimeDescriptor.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(selectedTimeDescriptor.intrinsicContentSize.width)

            let descriptorInset: CGFloat = 5
            let timeWidth = 3 + selectedTime.intrinsicContentSize.width

            make.centerX.equalTo(bars[selectedIndex]).priority(.high)
            make.trailing.lessThanOrEqualToSuperview().offset(-descriptorInset).priority(.required)
            make.leading.greaterThanOrEqualToSuperview().offset(timeWidth + descriptorInset).priority(.required)
        }

        selectedTime.snp.remakeConstraints { make in
            make.top.bottom.equalTo(selectedTimeDescriptor)
            make.width.equalTo(selectedTime.intrinsicContentSize.width)
            make.trailing.equalTo(selectedTimeDescriptor.snp.leading).offset(-3)
        }
    }

    @objc func selectBar( sender: UITapGestureRecognizer) {
        let selectedBar = sender.view!

        if let indexSelected = bars.firstIndex(of: selectedBar) {
            // Only update if user selected a different bar
            if selectedIndex != indexSelected {
                if selectedIndex < bars.count {
                    bars[selectedIndex].backgroundColor = .fitnessYellow
                }

                selectedIndex = indexSelected
                selectedBar.backgroundColor = .fitnessSelectedYellow

                // update selectedTime and the descriptor
                if data[selectedIndex + openHour - 1] < mediumThreshold {
                    selectedTimeDescriptor.text = timeDescriptors[0]
                } else if data[selectedIndex + openHour - 1] < highThreshold {
                    selectedTimeDescriptor.text = timeDescriptors[1]
                } else {
                    selectedTimeDescriptor.text = timeDescriptors[2]
                }
                selectedTimeDescriptor.sizeToFit()
                
                selectedTime.text = hours.openTime.addingTimeInterval( Double(selectedIndex) * secondsPerHour ).getStringOfDatetime(format: "ha :")

                setupSelectedConstraints()
            }
        }
    }
}
