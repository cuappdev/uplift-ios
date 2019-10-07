//
//  HomeScreenHeaderView.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import SnapKit
import UIKit

class HomeScreenHeaderView: UIView {

    var welcomeMessage: UILabel!

    var didSetupShadow = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BACKGROUND COLOR
        backgroundColor = .white

        // WELCOME MESSAGE
        welcomeMessage = UILabel()
        welcomeMessage.font = ._24MontserratBold
        welcomeMessage.textColor = .fitnessBlack
        welcomeMessage.lineBreakMode = .byWordWrapping
        welcomeMessage.numberOfLines = 0
        welcomeMessage.text = getGreeting()
        addSubview(welcomeMessage)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getGreeting() -> String {
        let currDate = Date()
        let hour = Calendar.current.component(.hour, from: currDate)

        if hour < 12 { return ClientStrings.Home.greetingMorning }
        if hour < 17 { return ClientStrings.Home.greetingAfternoon}
        return ClientStrings.Home.greetingEvening
    }

    // MARK: - LAYOUT
    func setupLayout() {
        welcomeMessage.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(24)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }
}
