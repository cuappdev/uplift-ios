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
    var data: [Int]!
    var bars: [UIView]!

    /// index of bars representing the bar that is currently selected. Must be in range 0..bars.count-1
    var selectedIndex: Int!
    var selectedLine: UIView!
    var selectedTime: UILabel!

    var selectedTimeDescriptor: UILabel!
    let timeDescriptors = ["Usually not too busy", "Usually a little busy", "Usually as busy as it gets"]
    let mediumThreshold = 43
    let highThreshold = 85

    var openHour: Int!

    var bottomAxis: UIView!
    var bottomAxisTicks: [UIView]!

    init(frame: CGRect, data: [Int], todaysHours: DailyGymHours) {
        super.init(frame: frame)
        self.data = data

        //AXIS
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

        //BARS
        bars = []
        for _ in openHour..<closeHour {
            let bar = UIView()
            bar.backgroundColor = .fitnessYellow
            addSubview(bar)
            bars.append(bar)

            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.selectBar(sender:)))
            bar.addGestureRecognizer(gesture)
        }

        //TIME
        let currentHour = Calendar.current.component(.hour, from: Date())
        selectedIndex = currentHour - openHour
        if selectedIndex < bars.count {
            bars[selectedIndex].backgroundColor = UIColor(red: 216/255, green: 200/255, blue: 0, alpha: 1.0)
        }

        //SELECTED INFO
        selectedLine = UIView()
        selectedLine.backgroundColor = .fitnessLightGrey
        addSubview(selectedLine)

        selectedTime = UILabel()
        selectedTime.textColor = .fitnessDarkGrey
        selectedTime.font = ._12LatoBold
        selectedTime.textAlignment = .right
        if (openHour + selectedIndex) < 12 {
            selectedTime.text = String(openHour + selectedIndex) + "AM :"
        } else if (openHour + selectedIndex) > 12 {
            selectedTime.text = String(openHour + selectedIndex - 12) + "PM :"
        } else {
            selectedTime.text = "12PM :"
        }
        selectedTime.sizeToFit()
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
        //AXIS
        bottomAxis.snp.updateConstraints {make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(2)
        }

        let tickSpacing = (Int(frame.width) - bottomAxisTicks.count*2 + 4)/(bottomAxisTicks.count + 1)
        for i in 0..<bottomAxisTicks.count {

            let tick = bottomAxisTicks[i]

            tick.snp.updateConstraints {make in
                if (i == 0) {
                    make.left.equalToSuperview().offset(tickSpacing)
                } else {
                    make.left.equalTo(bottomAxisTicks[i - 1].snp.right).offset(tickSpacing)
                }
                make.top.equalTo(bottomAxis.snp.top)
                make.width.equalTo(2)
                make.height.equalTo(3)
            }
        }

        //BARS
        for i in 0..<bars.count {

            let bar = bars[i]

            bar.snp.updateConstraints {make in
                make.bottom.equalTo(bottomAxis.snp.top)
                if i == 0 {
                    make.left.equalToSuperview().offset(2)
                    make.right.equalTo(bottomAxisTicks[i].snp.left)
                } else if i == bars.count - 1 {
                    make.right.equalToSuperview().offset(-2)
                    make.left.equalTo(bottomAxisTicks[i - 1].snp.right)
                } else {
                    make.left.equalTo(bottomAxisTicks[i - 1].snp.right)
                    make.right.equalTo(bottomAxisTicks[i].snp.left)
                }
                let height = 72 * (data[i + openHour]) / 100
                make.height.equalTo(height)
            }
        }

        setupSelectedConstraints()
    }

    func setupSelectedConstraints() {

        if selectedIndex < bars.count {
            selectedLine.snp.remakeConstraints {make in
                make.centerX.equalTo(bars[selectedIndex].snp.centerX)
                make.bottom.equalTo(bars[selectedIndex].snp.top)
                make.width.equalTo(2)
                make.top.equalToSuperview().offset(26)
            }
        }

        selectedTimeDescriptor.snp.remakeConstraints {make in
            make.top.equalToSuperview()
            make.height.equalTo(15)

            if CGFloat(selectedIndex)/CGFloat(bars.count) > 2/3 {
                make.right.equalToSuperview()
            } else if CGFloat(selectedIndex)/CGFloat(bars.count) < 1/3 {
                make.left.equalToSuperview().offset(selectedTime.frame.width)
            } else {
                make.centerX.equalTo(selectedLine.snp.centerX)
            }
        }

        selectedTime.snp.remakeConstraints {make in
            make.top.equalToSuperview()
            make.height.equalTo(15)
            make.right.equalTo(selectedTimeDescriptor.snp.left).offset(-3)
        }
    }

    @objc func selectBar( sender: UITapGestureRecognizer) {
        if selectedIndex < bars.count {
            bars[selectedIndex].backgroundColor = .fitnessYellow
        }
        let selectedBar = sender.view!
        selectedBar.backgroundColor = UIColor(red: 216/255, green: 200/255, blue: 0, alpha: 1.0)

        let indexSelected = bars.firstIndex(of: selectedBar)

        if let indexSelected = indexSelected {
            selectedIndex = indexSelected
        }

        //update selectedTime and the descriptor
        if data[selectedIndex + openHour - 1] < mediumThreshold {
            selectedTimeDescriptor.text = timeDescriptors[0]
        } else if data[selectedIndex + openHour - 1] < highThreshold {
            selectedTimeDescriptor.text = timeDescriptors[1]
        } else {
            selectedTimeDescriptor.text = timeDescriptors[2]
        }
        selectedTimeDescriptor.sizeToFit()

        if (openHour + selectedIndex) < 12 {
            selectedTime.text = String(openHour + selectedIndex) + "AM :"
        } else if (openHour + selectedIndex) > 12 {
            selectedTime.text = String(openHour + selectedIndex - 12) + "PM :"
        } else {
            selectedTime.text = "12PM :"
        }
        selectedTime.sizeToFit()

        setupSelectedConstraints()
    }
}
