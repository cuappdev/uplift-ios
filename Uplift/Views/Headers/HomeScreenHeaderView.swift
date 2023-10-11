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
    var statusButton: UIButton!

    var didSetupShadow = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BACKGROUND COLOR
        backgroundColor = .white

        // WELCOME MESSAGE
        welcomeMessage = UILabel()
        welcomeMessage.font = ._24MontserratBold
        welcomeMessage.textColor = .primaryBlack
        welcomeMessage.lineBreakMode = .byWordWrapping
        welcomeMessage.numberOfLines = 0
        welcomeMessage.text = getGreeting()
        
        addSubview(welcomeMessage)
        
        statusButton = StatusButtonView()
        statusButton.layer.borderColor = UIColor.gray01.cgColor
        statusButton.layer.borderWidth = 1
        statusButton.layer.cornerRadius = 12
        statusButton.addTarget(self, action: #selector(showCapacityView), for: .touchUpInside)
        
        addSubview(statusButton)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showCapacityView() {
        if (statusButton.tag == 0) {
            statusButton.backgroundColor = .gray
            statusButton.tag = 1
        } else {
            statusButton.backgroundColor = .gray01
            statusButton.tag = 0
        }
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
        
        statusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(welcomeMessage.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
    }
}

class StatusButtonView: UIButton {
    
    var circularView: UIView!
    
    var dropDownImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        circularView = CircularProgressView(progressColor: .green, width: 24)
        addSubview(circularView)
        
        dropDownImageView.image = UIImage(named: "dropdown")
        addSubview(dropDownImageView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        circularView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        dropDownImageView.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(8)
            make.centerY.equalTo(circularView)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
