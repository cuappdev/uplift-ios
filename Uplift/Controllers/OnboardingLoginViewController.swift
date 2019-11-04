//
//  OnboardingLoginViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 2/27/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit
import GoogleSignIn

class OnboardingLoginViewController: UIViewController {
    
    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var signUpLabel: UILabel!
    var googleBtn: UIButton!
    var nextButton: UIButton!
    var nextButtonArrow: UIImageView!
    
    // Display Info
    let titleToContentPadding: CGFloat = 120//187
    let buttonPadding: CGFloat = 16
    let edgePadding: CGFloat = 27
    
    let buttonHeight: CGFloat = 48
    let cornerRadius: CGFloat = 5

    let nextButtonSize: CGFloat = 35
    let nextButtonPadding = CGSize(width: 40, height: 70)
    let buttonBorderSize: CGFloat = 2
    
    let checkSymbolSize: CGFloat = 24
    let checkArrowSize = CGSize(width: 16.95, height: 11.59)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .primaryWhite

        // Google Sign in
        GIDSignIn.sharedInstance()?.presentingViewController = self

        titleLabel = UILabel()
        titleLabel.text = ClientStrings.Onboarding.vcTitleLabel
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .primaryBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        signUpLabel = UILabel()
        signUpLabel.text = ClientStrings.Onboarding.signupLabel
        signUpLabel.font = ._16MontserratBold
        signUpLabel.textColor = .primaryBlack
        view.addSubview(signUpLabel)

        googleBtn = UIButton()
        googleBtn.titleLabel?.font = ._16MontserratBold
        googleBtn.setTitleColor(.gray01, for: .normal)
        let googleWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let googleBorder = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        googleBtn.backgroundColor = googleWhite
        googleBtn.layer.borderColor = googleBorder
        googleBtn.setImage(UIImage(named: "google-logo"), for: .normal)
        googleBtn.backgroundColor = googleWhite
        googleBtn.layer.borderWidth = 1
        googleBtn.layer.cornerRadius = cornerRadius
        googleBtn.addTarget(self, action: #selector(googleButtonTapped), for: .touchDown)
        view.addSubview(googleBtn)

        nextButton = UIButton()
        nextButton.clipsToBounds = false
        nextButton.layer.cornerRadius = nextButtonSize / 2
        nextButton.backgroundColor = .primaryWhite
        nextButton.layer.borderColor = UIColor.upliftMediumGrey.cgColor
        nextButton.layer.borderWidth = buttonBorderSize
        nextButton.addTarget(self, action: #selector(goToNextView), for: .touchDown)
        nextButton.isEnabled = false
        nextButtonArrow = UIImageView(image: UIImage(named: ImageNames.backArrowDark))
        nextButtonArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        nextButton.addSubview(nextButtonArrow)
        view.addSubview(nextButton)

        // If already signed in, make Next Button Yellow
        toggleNextButton(enabled: isGoogleSignedIn())

        // Check for google sign in
        NotificationCenter.default.addObserver(self, selector: #selector(userSignedInWithGoogle), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)

        setUpConstraints()
    }

    // MARK: UI Control
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(edgePadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(titleToContentPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
        
        googleBtn.snp.makeConstraints { make in
            make.top.equalTo(signUpLabel.snp.bottom).offset(buttonPadding / 2)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(buttonHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.height)
        }
        
        nextButtonArrow.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(checkArrowSize)
        }
    }

    /// Toggles whether the Next button can be pressed (also adds the checkmark in the email field)
    func toggleNextButton(enabled: Bool) {
        if enabled {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .primaryYellow
            nextButton.layer.borderColor = UIColor.primaryBlack.cgColor
            nextButton.alpha = 1
            nextButtonArrow.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0
            nextButtonArrow.alpha = 0
        }
    }

    func displayEmail() {
        /// Changes the google button to display the user's email instead of the google logo
        googleBtn.setImage(nil, for: .normal)
        googleBtn.contentHorizontalAlignment = .left
        googleBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonPadding, bottom: 0, right: 0)
        googleBtn.setTitle(User.currentUser?.email, for: .normal)
    }

    @objc func goToNextView() {
        if UserDefaults.standard.bool(forKey: Identifiers.hasSeenOnboarding) {
            // Seen Onboarding and had to relogin
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appDelegate.window?.rootViewController = TabBarController()
        } else { // Continue rest of Onboarding
            navigationController?.pushViewController(OnboardingGymsViewController(), animated: true)
        }
    }
    
    @objc func userSignedIn(didSignIn: Bool=true) {
        toggleNextButton(enabled: didSignIn)
        googleBtn.isUserInteractionEnabled = !didSignIn
    }

    @objc func userSignedInWithGoogle() {
        toggleNextButton(enabled: true)
        signUpLabel.alpha = 0
        displayEmail()
        googleBtn.isUserInteractionEnabled = false
    }

    // MARK: - Google Sign In
    @objc func googleButtonTapped() {
        if let appDelegate = UIApplication.shared.delegate as? GIDSignInDelegate {
            GIDSignIn.sharedInstance()?.delegate = appDelegate
        }
        if !isGoogleSignedIn() {
            GIDSignIn.sharedInstance()?.signIn()
        }
    }

    // MARK: - Helpers
    private func isGoogleSignedIn() -> Bool {
        return (UIApplication.shared.delegate as! AppDelegate).isGoogleLoggedIn()
    }
}
