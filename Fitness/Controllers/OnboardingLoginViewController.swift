//
//  OnboardingLoginViewController.swift
//  Fitness
//
//  Created by Phillip OReggio on 2/27/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit
import GoogleSignIn

class OnboardingLoginViewController: UIViewController, GIDSignInUIDelegate {
    
    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var signUpLabel: UILabel!
    var emailField: UITextField!
    var googleBtn: UIButton!
    var nextButton: UIButton!
    var nextButtonArrow: UIImageView!
    var checkSymbol: UIImageView!
    
    // Display Info
    let titleToContentPadding: CGFloat = 187
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
        
        view.backgroundColor = .fitnessWhite
        
        // Google Sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        
        titleLabel = UILabel()
        titleLabel.text = "Welcome to Uplift!\nStart your Journey Today!"
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        signUpLabel = UILabel()
        signUpLabel.text = "Sign Up"
        signUpLabel.font = ._16MontserratBold
        signUpLabel.textColor = .fitnessBlack
        view.addSubview(signUpLabel)
        
        emailField = UITextField()
        emailField.layer.masksToBounds = false
        emailField.layer.cornerRadius = cornerRadius
        emailField.textColor = .fitnessDarkGrey
        emailField.backgroundColor = .fitnessWhite
        emailField.placeholder = "Email"
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.fitnessDarkGrey.cgColor
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        // Padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailField.frame.height))
        emailField.leftView = paddingView
        emailField.leftViewMode = UITextField.ViewMode.always
//        emailField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEndOnExit)
        view.addSubview(emailField)
        
        checkSymbol = UIImageView()
        checkSymbol.layer.cornerRadius = 12
        checkSymbol.image = UIImage(named: "green check")
        checkSymbol.alpha = 0
        emailField.addSubview(checkSymbol)
        
        googleBtn = UIButton()
        let googleWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let googleBorder = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        googleBtn.backgroundColor = googleWhite
        googleBtn.layer.borderColor = googleBorder
        googleBtn.setImage(UIImage(named: "googleLogo"), for: .normal)
        googleBtn.backgroundColor = googleWhite
        googleBtn.layer.borderWidth = 1
        googleBtn.layer.cornerRadius = cornerRadius
        googleBtn.addTarget(self, action: #selector(googleButtonTapped), for: .touchDown)
        view.addSubview(googleBtn)
        
        nextButton = UIButton()
        nextButton.clipsToBounds = false
        nextButton.layer.cornerRadius = nextButtonSize / 2
        nextButton.backgroundColor = .fitnessWhite
        nextButton.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        nextButton.layer.borderWidth = buttonBorderSize
        nextButton.addTarget(self, action: #selector(goToNextView), for: .touchDown)
        nextButton.isEnabled = false
        nextButtonArrow = UIImageView(image: UIImage(named: "arrow"))
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
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(edgePadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
        
        signUpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(titleToContentPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
        
//        emailField.snp.makeConstraints { (make) in
//            make.top.equalTo(signUpLabel.snp.bottom).offset(buttonPadding / 2)
//            make.leading.trailing.equalToSuperview().inset(edgePadding)
//            make.height.equalTo(buttonHeight)
//        }
        
//        checkSymbol.snp.makeConstraints { (make) in
//            make.size.equalTo(checkSymbolSize)
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().inset(13)
//        }
        
        googleBtn.snp.makeConstraints { (make) in
            //make.top.equalTo(emailField.snp.bottom).offset(buttonPadding)
            make.top.equalTo(signUpLabel.snp.bottom).offset(buttonPadding / 2)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(buttonHeight)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(nextButtonSize)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(nextButtonPadding.height)
        }
        
        nextButtonArrow.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(checkArrowSize)
        }
    }
    
    /// Toggles whether the Next button can be pressed (also adds the checkmark in the email field)
    func toggleNextButton(enabled: Bool) {
        if enabled {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .fitnessYellow
            nextButton.layer.borderColor = UIColor.fitnessBlack.cgColor
            nextButtonArrow.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .fitnessWhite
            nextButton.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
            nextButtonArrow.alpha = 0.5
        }
    }
    
    /// Toggles whether the green check in the email field is displayed
    func toggleEmailFieldCheck(enabled: Bool) {
        checkSymbol.alpha = enabled ? 1 : 0
    }
    
    @objc func goToNextView() {
        if UserDefaults.standard.bool(forKey: Identifiers.hasSeenOnboarding) {
            // Seen Onboarding and had to relogin
            navigationController?.pushViewController(HomeController(), animated: true)
        } else { // Continue rest of Onboarding
            navigationController?.pushViewController(OnboardingGymsViewController(), animated: true)
        }
    }
    
    @objc func userSignedIn(didSignIn: Bool=true) {
        toggleNextButton(enabled: didSignIn)
        toggleEmailFieldCheck(enabled: didSignIn)
        googleBtn.isUserInteractionEnabled = !didSignIn
    }
    
    @objc func userSignedInWithGoogle() {
        var isSignedIn = isGoogleSignedIn()
        toggleNextButton(enabled: true)
        emailField.text = ""
        emailField.isUserInteractionEnabled = false
        googleBtn.isUserInteractionEnabled = false
        print(User.currentUser?.email)
    }

    // MARK:- Google Sign In
    @objc func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.delegate = UIApplication.shared.delegate as! GIDSignInDelegate
        GIDSignIn.sharedInstance()?.uiDelegate = self
        if !isGoogleSignedIn() {
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    // MARK:- Helpers
    private func isGoogleSignedIn() -> Bool {
        return (UIApplication.shared.delegate as! AppDelegate).isGoogleLoggedIn()
    }
}
