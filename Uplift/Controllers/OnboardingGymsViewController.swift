//
//  OnboardingGymsViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 3/5/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ChooseGymsDelegate: class {
    func updateFavorites(favorites: [String])
}

class OnboardingGymsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - INITIALIZATION
    private var titleLabel: UILabel!
    private var nextButton: UIButton!
    private var nextButtonArrow: UIImageView!
    private var backButton: UIButton!
    private var backButtonArrow: UIImageView!
    
    // TableView
    private var gymsTableView: UITableView!
    
    // Display Info
    private var currentScreenSize: CGSize?
    private var xrSize = CGSize(width: 768, height: 375)
    private let nextButtonSize: CGFloat = 35
    private let gymCellHeight: CGFloat = 60
    private let gymCellVerticalPadding: CGFloat = 14
    
    // Gyms
    private var gymNames: [String] = []
    private var favoriteGyms: [String] = []
    
    weak var delegate: ChooseGymsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fitnessWhite

        let buttonBorderSize: CGFloat = 2
        
        // Set up screen sizes for scaling
        currentScreenSize = computeScreenDimensions()
        xrSize = CGSize(width: 375, height: 768)
        
        titleLabel = UILabel()
        titleLabel.text = "Pick a Gym! Any gym! Cuz we know their Hours!"
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.fitTextToBounds()
        view.addSubview(titleLabel)
        
        gymsTableView = UITableView(frame: .zero, style: .plain)
        gymsTableView.delegate = self
        gymsTableView.dataSource = self
        gymsTableView.register(FavoriteGymCell.self, forCellReuseIdentifier: FavoriteGymCell.reuseIdentifier)
        gymsTableView.isScrollEnabled = false 
        gymsTableView.separatorStyle = .none
        gymsTableView.clipsToBounds = false 
        view.addSubview(gymsTableView)
        
        nextButton = UIButton()
        nextButton.clipsToBounds = false
        nextButton.layer.cornerRadius = nextButtonSize / 2
        nextButton.backgroundColor = .fitnessYellow
        nextButton.layer.borderColor = UIColor.fitnessBlack.cgColor
        nextButton.layer.borderWidth = buttonBorderSize
        nextButton.addTarget(self, action: #selector(goToNextView), for: .touchDown)
        nextButton.isEnabled = false
        nextButtonArrow = UIImageView(image: UIImage(named: "arrow"))
        nextButtonArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        nextButton.addSubview(nextButtonArrow)
        view.addSubview(nextButton)
        
        backButton = UIButton()
        backButton.clipsToBounds = false
        backButton.layer.cornerRadius = nextButtonSize / 2
        backButton.backgroundColor = .fitnessWhite
        backButton.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        backButton.layer.borderWidth = buttonBorderSize
        backButton.addTarget(self, action: #selector(goBackAView), for: .touchDown)
        backButton.isEnabled = true
        backButtonArrow = UIImageView(image: UIImage(named: "arrow"))
        backButtonArrow.alpha = 0.5
        backButton.addSubview(backButtonArrow)
        view.addSubview(backButton)
        
        toggleButton(button: nextButton, arrow: nextButtonArrow, enabled: false)
        
        NetworkManager.shared.getGyms { (gyms) in
            var namesArray = [String]()
            gyms.forEach {
                namesArray.append($0.name)
            }
            DispatchQueue.main.async {
                self.gymNames = namesArray
                self.gymsTableView.reloadData()
            }
        }

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(goBackAView))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)

        setUpConstraints()
    }

    func setUpConstraints() {
        // title
        let titleLeadingPadding = scale(width: 27) 
        let titleTrailingPadding = scale(width: 22)
        let titleTopPadding = scale(height: 34)
        // table view
        let tableViewTopPadding = scale(height: 28)
        let tableViewSidePadding = scale(width: 16)
        let tableViewBottomPadding = scale(height: 14)
        // next button
        let nextButtonPaddingWidth = 40
        let nextButtonPaddingHeight = 70
        // check arrow
        let checkArrowWidth = 16.95
        let checkArrowHeight = 11.59
        let checkArrowSize = CGSize(width: checkArrowWidth, height: checkArrowHeight)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(titleLeadingPadding)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(titleTrailingPadding)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(titleTopPadding)
        }
        
        // Table View
        gymsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(tableViewTopPadding)
            make.leading.trailing.equalToSuperview().inset(tableViewSidePadding)
            make.bottom.equalTo(nextButton.snp.top).offset(tableViewBottomPadding)
        }
        
        // Arrows
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPaddingWidth)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPaddingHeight)
        }
        
        nextButtonArrow.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(checkArrowSize)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPaddingWidth)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPaddingHeight)
        }
        
        backButtonArrow.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(checkArrowSize)
        }
    }
    
    /// Save favorite gyms to UserDefualts
    func saveFavoriteGyms() {
        let defaults = UserDefaults.standard
        defaults.set(favoriteGyms, forKey: Identifiers.favoriteGyms)
    }

    //MARK: UI Helper Methods
    /// Scales measurements based off the height of an iPhone XR
    func scale(height: Double) -> Double {
        return Double(currentScreenSize?.height ?? 0) * (height / Double(xrSize.height))
    }

    /// Scales measurements based off the width of an iPhone XR
    func scale(width: Double) -> Double {
        return Double(currentScreenSize?.width ?? 0) * (width / Double(xrSize.width))
    }

    /// Computes the dimensions of the current device
    func computeScreenDimensions() -> CGSize {
        var safeInsetHeight: CGFloat = 0
        var safeInsetWidth: CGFloat = 0
        if #available(iOS 11.0, *) { // Compensate for safe area layout guide insets
            let window = UIApplication.shared.keyWindow
            safeInsetHeight = window?.safeAreaInsets.top ?? 0
            safeInsetWidth = window?.safeAreaInsets.left ?? 0
        }
        let screenRect = UIScreen.main.bounds
        let screenHeight: Double = Double(screenRect.height - safeInsetHeight)
        let screenWidth: Double = Double(screenRect.width - safeInsetWidth)
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    /// Toggles whether the Next button can be pressed (also adds the checkmark in the email field)
    func toggleButton(button: UIButton, arrow: UIView, enabled: Bool) {
        if enabled {
            button.isEnabled = true
            button.alpha = 1
            arrow.alpha = 1
        } else {
            button.isEnabled = false
            button.alpha = 0
            arrow.alpha = 0
        }
    }
    
    /// Checks whether the user has selected at least one gym, so the continue button can be enabled
    func checkNextCriteria() -> Bool {
        return favoriteGyms.count >= 1
    }
    
    //MARK: Button Actions
    @objc func goToNextView() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Identifiers.hasSeenOnboarding)
        saveFavoriteGyms()
        appDelegate.window?.rootViewController = TabBarController()
    }
    
    @objc func goBackAView() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = gymsTableView.cellForRow(at: indexPath) as! FavoriteGymCell
        cell.toggleSelectedView(selected: !cell.isOn)
        if cell.isOn {
            favoriteGyms.append(gymNames[indexPath.section])
        } else {
            for i in 0...favoriteGyms.count {
                if favoriteGyms[i] == gymNames[indexPath.section] {
                    favoriteGyms.remove(at: i)
                    break
                }
            }
        }
        
        // Update next button with whether the user has selected at least one gym
        toggleButton(button: nextButton, arrow: nextButtonArrow, enabled: checkNextCriteria())
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return gymCellHeight
        return CGFloat(scale(height: Double(gymCellHeight)))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return gymCellVerticalPadding
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let blankView = UIView()
        blankView.backgroundColor = .clear
        return blankView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return gymNames.count
    }

    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteGymCell.reuseIdentifier, for: indexPath) as! FavoriteGymCell
        let gym = gymNames[indexPath.section]
        cell.configure(with: gym)
        cell.setNeedsUpdateConstraints()
        cell.selectionStyle = .none
        return cell
    }
}
