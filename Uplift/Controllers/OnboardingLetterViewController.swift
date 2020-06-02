//
//  OnboardingLetterViewController.swift
//  Fitness
//
//  Created by Phillip OReggio on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class OnboardingLetterViewController: UIViewController {

    //MARK:- UI Elements + Init
    // First Message
    var text1: UILabel!
    var text2: UILabel!
    var image: UIImageView!
    var nextButton: UIButton!
    var arrowIcon: UIImageView!

    // Sizing
    let sidePadding: CGFloat = 30
    let topPadding: CGFloat = 20
    let imageSize = CGSize(width: 50, height: 50)
    let buttonSize: CGFloat = 35

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fitnessWhite

        text1 = UILabel()
        text1.font = UIFont(name: "Montserrat-Regular", size: 24)
        let formattedString = NSMutableAttributedString()
        formattedString.normal("At Uplift, we're not ")
        formattedString.bold("6 pack athletes.")
        text1.attributedText = formattedString
        text1.numberOfLines = 0
        view.addSubview(text1)

        text2 = UILabel()
        text2.font = UIFont(name: "Montserrat-Regular", size: 24)
        let formattedString2 = NSMutableAttributedString()
        formattedString2.normal("Just peeps trying to be ")
        formattedString2.bold("healthy")
        formattedString2.normal(" & improve ourselves everyday.")
        text2.attributedText = formattedString2
        text2.numberOfLines = 0
        view.addSubview(text2)

        image = UIImageView()
        image.image = UIImage(named: "onboarding_4")
        image.contentMode = .scaleAspectFit
        view.addSubview(image)

        nextButton = UIButton()
        nextButton.backgroundColor = UIColor.fitnessYellow
        nextButton.layer.cornerRadius = buttonSize / 2
        nextButton.layer.masksToBounds = false
        nextButton.layer.shadowOpacity = 0.25
        nextButton.layer.shadowRadius = 6
        nextButton.layer.shadowOffset = CGSize(width: 2, height: 4)
        nextButton.addTarget(self, action: #selector(goToNext), for: .touchDown)
        view.addSubview(nextButton)

        arrowIcon = UIImageView(image: UIImage(named: "down_arrow"))
        arrowIcon.contentMode = .scaleAspectFit
        nextButton.addSubview(arrowIcon)

        setUpConstraints()
    }

    func setUpConstraints() {
        text1.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topPadding)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
        }

        text2.snp.makeConstraints { (make) in
            make.top.equalTo(text1.snp.bottom).offset(topPadding)
            make.leading.trailing.equalToSuperview().inset(sidePadding)
        }

        image.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(imageSize)
        }

        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(topPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(buttonSize)
        }

        arrowIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(buttonSize * (2/3))
        }
    }

    @objc func goToNext() {

    }

}

// MARK: - Partial Bolding
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Montserrat-Bold", size: 24)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)

        return self
    }

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)

        return self
    }
}
