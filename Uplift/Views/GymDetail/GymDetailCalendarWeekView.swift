//
//  GymDetailCalendarView.swift
//  Uplift
//
//  The header calendar used to select which content to display based on day of the week
//
//  Created by Phillip OReggio on 10/2/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class GymDetailCalendarWeekView: UIView {

    private var calendarCollectionView: UICollectionView!
    private var days: [Date] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        // TODO: make WeekCollectionView cell, set up that whole thing
        // think about delegation since this is gonna be used in a lot of things

        // visible / public state. Look into proper delegation tactics for passing info between viewss


        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .fitnessWhite

        days = createCalendarDates()
    }
    
    private func setupConstraints() {
        //...?
    }

    /// Returns Dates for each day of the current week
    private func createCalendarDates() -> [Date] {
        let cal = Calendar.current
        print("--------???")
        print(cal)
        print(cal.weekdaySymbols)

        return [] //...?
    }
}
