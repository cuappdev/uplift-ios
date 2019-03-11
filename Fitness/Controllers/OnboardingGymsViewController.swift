//
//  OnboardingGymsViewController.swift
//  Fitness
//
//  Created by Phillip OReggio on 3/5/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class OnboardingGymsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var gymTableView: UITableView!
    var nextButton: UIButton!
    var nextButtonArrow: UIImageView!
    var backButton: UIButton!
    var backButtonArrow: UIImageView!
    
    // TableView
    var gymsTableView: UITableView!
    let reuseIdentifier = "gymsTableView"
    
    // Display Info
    let tableViewToNext: CGFloat = 94
    let buttonPadding: CGFloat = 27
    let buttonHeight: CGFloat = 48
    let cornerRadius: CGFloat = 5
    
    let nextButtonSize: CGFloat = 35
    let nextButtonPadding = CGSize(width: 40, height: 70)
    let buttonBorderSize: CGFloat = 2
    
    let checkSymbolSize: CGFloat = 24
    let checkArrowSize = CGSize(width: 16.95, height: 11.59)
    
    let maxGymRows = 8
    let gymCellHeight = 60
    let gymSidePadding = 16
    
    // Gyms
    var gymNames: [String] = []

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
        
        gymsTableView = UITableView(frame: .zero, style: .plain)
        gymsTableView.delegate = self
        gymsTableView.dataSource = self
        gymsTableView.register(FavoriteGymCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(gymsTableView)
        
        nextButton = UIButton()
        nextButton.clipsToBounds = false
        nextButton.layer.cornerRadius = nextButtonSize / 2
        nextButton.backgroundColor = .fitnessWhite
        nextButton.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        nextButton.layer.borderWidth = buttonBorderSize
        nextButton.addTarget(self, action: #selector(goToNextView), for: .touchDown)
        nextButton.isEnabled = false
        nextButtonArrow = UIImageView(image: UIImage(named: "darkBackArrow"))
        nextButtonArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) )
        nextButton.addSubview(nextButtonArrow)
        view.addSubview(nextButton)
        
        backButton = UIButton()
        backButton.clipsToBounds = false
        backButton.layer.cornerRadius = nextButtonSize / 2
        backButton.backgroundColor = .fitnessWhite
        backButton.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        backButton.layer.borderWidth = buttonBorderSize
        backButton.addTarget(self, action: #selector(goBackAView), for: .touchDown)
        backButton.isEnabled = false
        backButtonArrow = UIImageView(image: UIImage(named: "darkBackArrow"))
        backButton.addSubview(backButtonArrow)
        view.addSubview(backButton)
        
        toggleButton(button: backButton, enabled: true)
        
        NetworkManager.shared.getGyms { (gyms) in
            gyms.forEach {
                var namesArray = [String]()
                namesArray.append($0.name)
                DispatchQueue.main.async {
                    self.gymNames = namesArray
                }
                //print($0.name)
            }
        }
        print(gymNames)

        gymsTableView.reloadData()
        setUpConstraints()
    }

    func setUpConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(27)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        
        //TABLE VIEW...
        gymsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(28)
            make.leading.trailing.equalToSuperview().inset(gymSidePadding)
            make.height.equalTo(356)
        }
        
        // Arrows
        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(nextButtonSize)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.height)
        }
        
        nextButtonArrow.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(checkArrowSize)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.size.equalTo(nextButtonSize)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.height)
        }
        
        backButtonArrow.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(checkArrowSize)
        }
    }
    
    /// Toggles whether the Next button can be pressed (also adds the checkmark in the email field)
    func toggleButton(button: UIButton, enabled: Bool) {
        if enabled {
            button.isEnabled = true
            button.backgroundColor = .fitnessYellow
            button.layer.borderColor = UIColor.fitnessBlack.cgColor
        } else {
            button.isEnabled = false
            button.backgroundColor = .fitnessWhite
            button.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        }
    }
    
    @objc func goToNextView() {
        //navigationController?.pushViewController(HomeController(), animated: true)
        self.present(HomeController(), animated: true)
    }
    
    @objc func goBackAView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(gymCellHeight)
    }
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoriteGymCell
        let gym = gymNames[indexPath.row]
        cell.configure(with: gym)
        cell.setNeedsUpdateConstraints()
        cell.selectionStyle = .none
        return cell
    }
    
}
