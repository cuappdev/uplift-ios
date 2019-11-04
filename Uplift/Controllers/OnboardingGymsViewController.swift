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

class OnboardingGymsViewController: UIViewController {

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
    private let nextButtonSize: CGFloat = 35
    private let gymCellHeight: CGFloat = 60
    private let gymCellVerticalPadding: CGFloat = 14

    // Gyms
    private var gymNames: [String] = []
    private var favoriteGyms: [String] = []

    weak var delegate: ChooseGymsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryWhite
        let defaults = UserDefaults.standard
        
        // Get Favorite Gyms from UserDefaults
        if let favorites = defaults.array(forKey: Identifiers.favoriteGyms) as? [String] {
            favoriteGyms = favorites
        }

        // Set up screen sizes for scaling
        currentScreenSize = computeScreenDimensions()

        NetworkManager.shared.getGymNames { gyms in
            DispatchQueue.main.async {
                self.gymNames = gyms.map({ $0.name }).sorted()
                self.gymsTableView.reloadData()
            }
        }

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(goBackAView))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)

        setupViews()
        setUpConstraints()
    }

    func setupViews() {
        let buttonBorderSize: CGFloat = 2

        titleLabel = UILabel()
        titleLabel.text = ClientStrings.Onboarding.selectGyms
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .primaryBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
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
        nextButton.backgroundColor = .primaryYellow
        nextButton.layer.borderColor = UIColor.primaryBlack.cgColor
        nextButton.layer.borderWidth = buttonBorderSize
        nextButton.addTarget(self, action: #selector(goToNextView), for: .touchDown)
        nextButton.isEnabled = false
        nextButtonArrow = UIImageView(image: UIImage(named: ImageNames.backArrowDark))
        nextButtonArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        nextButton.addSubview(nextButtonArrow)
        view.addSubview(nextButton)

        backButton = UIButton()
        backButton.clipsToBounds = false
        backButton.layer.cornerRadius = nextButtonSize / 2
        backButton.backgroundColor = .primaryWhite
        backButton.layer.borderColor = UIColor.upliftMediumGrey.cgColor
        backButton.layer.borderWidth = buttonBorderSize
        backButton.addTarget(self, action: #selector(goBackAView), for: .touchDown)
        backButton.isEnabled = true
        backButtonArrow = UIImageView(image: UIImage(named: ImageNames.backArrowDark))
        backButtonArrow.alpha = 0.5
        backButton.addSubview(backButtonArrow)
        view.addSubview(backButton)

        toggleButton(enabled: false)
    }

    func setUpConstraints() {
        // title
        let titleLeadingPadding = 27 
        let titleTrailingPadding = 22
        let titleTopPadding = 34
        // table view
        let tableViewTopPadding = 28
        let tableViewSidePadding = 16
        let tableViewBottomPadding = 14
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

    /// Save favorite gyms to UserDefaults
    func saveFavoriteGyms() {
        let defaults = UserDefaults.standard
        defaults.set(favoriteGyms, forKey: Identifiers.favoriteGyms)
    }

    // MARK: UI Helper Methods
    /// Scales measurements based off the height of an iPhone XR
    func scale(height: Double) -> Double {
        let xrHeight = 768
        return Double(currentScreenSize?.height ?? 0) * (height / Double(xrHeight))
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
    func toggleButton(enabled: Bool) {
        if enabled {
            nextButton.isEnabled = true
            nextButton.alpha = 1
            nextButtonArrow.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0
            nextButtonArrow.alpha = 0
        }
    }

    /// Checks whether the user has selected at least one gym, so the continue button can be enabled
    func checkNextCriteria() -> Bool {
        return favoriteGyms.count >= 1
    }

    // MARK: - Button Actions
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

}

extension OnboardingGymsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteGymCell.reuseIdentifier, for: indexPath) as! FavoriteGymCell
        let gym = gymNames[indexPath.section]
        cell.configure(with: gym)
        // Toggle if already in UserDefaults
        if favoriteGyms.contains(gym) {
            cell.toggleSelectedView(selected: true)
        }
        cell.selectionStyle = .none
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return gymNames.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}

extension OnboardingGymsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //swiftlint:disable:next force_cast
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
        toggleButton(enabled: checkNextCriteria())
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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

}
