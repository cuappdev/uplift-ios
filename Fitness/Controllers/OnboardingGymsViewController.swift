//
//  OnboardingGymsViewController.swift
//  Fitness
//
//  Created by Phillip OReggio on 3/5/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class OnboardingGymsViewController: UIViewController {
    
    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var gymTableView: UITableView!
    var placeholder: UIView!
    var nextButton: UIButton!
    
    // Display Info
    let tableViewToNext: CGFloat = 94
    let buttonPadding: CGFloat = 27
    let buttonHeight: CGFloat = 48
    let cornerRadius: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fitnessWhite
        
        titleLabel = UILabel()
        titleLabel.text = "Pick a Gym! Any gym! Cuz we know their Hours!"
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        placeholder = UIView()
        placeholder.tintColor = .fitnessLightGrey
        view.addSubview(placeholder)
        
        nextButton = UIButton()
        nextButton.backgroundColor = .fitnessMediumGrey
        nextButton.setTitleShadowColor(.buttonShadow, for: .normal)
        nextButton.setTitleColor(.fitnessWhite, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.cornerRadius = cornerRadius
        nextButton.titleLabel?.font = ._16MontserratBold
        nextButton.layer.shadowOpacity = 0.25
        nextButton.layer.shadowRadius = 6
        nextButton.layer.shadowOffset = CGSize(width: 2, height: 4)
        nextButton.addTarget(self, action: #selector(goToNextView), for: .touchDown)
        nextButton.isEnabled = false
        view.addSubview(nextButton)

        setUpConstraints()
    }

    func setUpConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(27)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        
        //TABLE VIEW...
        placeholder.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(28)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(11)
            make.height.equalTo(356)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(placeholder.snp.bottom).offset(tableViewToNext)
            make.height.equalTo(buttonHeight)
            make.leading.trailing.equalToSuperview().inset(buttonPadding)
            make.centerX.equalToSuperview()
        }
    }
    
    /// Toggles whether the Next button can be pressed (also adds the checkmark in the email field)
    func toggleNextButton(enabled: Bool) {
        if enabled {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .fitnessYellow
            nextButton.setTitleColor(.fitnessBlack, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .fitnessMediumGrey
            nextButton.setTitleColor(.fitnessWhite, for: .normal)
        }
    }
    
    @objc func goToNextView() {
        navigationController?.pushViewController(HomeController(), animated: true)
    }
}
