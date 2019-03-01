//
//  OnboardingLoginViewController.swift
//  Fitness
//
//  Created by Phillip OReggio on 2/27/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class OnboardingLoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var signUpLabel: UILabel!
    var emailField: UITextField!
    var facebookBtn: UIButton!
    var googleBtn: UIButton!
    var nextButton: UIButton!
    var checkSymbol: UIView! // To be an Image once the asset becomes available
    
    // Display Info
    let titleToContentPadding: CGFloat = 187
    let buttonPadding: CGFloat = 16
    let finalButtonPadding: CGFloat = 39
    let edgePadding: CGFloat = 27
    let buttonHeight: CGFloat = 48
    let checkSymbolSize: CGFloat = 24
    let cornerRadius: CGFloat = 5
    
    // Facebook Login Manager
    var facebookLoginManager: FBSDKLoginManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fitnessWhite
        
        // Initialize Facebook Login Manager
        facebookLoginManager = FBSDKLoginManager()
        
        // DEBUG--- sign out
        GIDSignIn.sharedInstance().signOut()
//        FBSDKAccessToken.setCurrent(nil)
//        FBSDKProfile.setCurrent(nil)
        
        FBSDKLoginManager().logOut()
        
        
        print("Login Status?")
        print("Google signed in: \(isGoogleSignedIn())")
        print("Facebook signed in: \(isFacebookSignedIn())")
        
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
        emailField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingDidEndOnExit)
        view.addSubview(emailField)
        
        checkSymbol = UIView()
        checkSymbol.layer.cornerRadius = 12
        checkSymbol.backgroundColor = .fitnessGreen
        checkSymbol.alpha = 0
        emailField.addSubview(checkSymbol)
        
        facebookBtn = UIButton()
        let facebookBlue = UIColor(displayP3Red: 66.0 / 255, green: 103 / 255, blue: 178 / 255, alpha: 1)
        facebookBtn.backgroundColor = facebookBlue
        facebookBtn.setImage(UIImage(named: "facebookLogo"), for: .normal)
        facebookBtn.layer.cornerRadius = cornerRadius
        facebookBtn.addTarget(self, action: #selector(facebookButtonTapped), for: .touchDown)
        view.addSubview(facebookBtn)
        
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
        
        // If already signed in, make Next Button Yellow
        toggleNextButton(enabled: isGoogleSignedIn() || isFacebookSignedIn())
        
        setUpConstraints()
    }
    
    // MARK: UI Control
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(edgePadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
        
        signUpLabel.snp.makeConstraints { (make) in
            //make.top.equalTo(titleLabel.snp.bottom).offset(titleToContentPadding)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(titleToContentPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
        
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(buttonPadding / 2)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(buttonHeight)
        }
        
        checkSymbol.snp.makeConstraints { (make) in
            make.size.equalTo(checkSymbolSize)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(13)
        }
        
        facebookBtn.snp.makeConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(buttonPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(buttonHeight)
        }
        
        googleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(facebookBtn.snp.bottom).offset(buttonPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(buttonHeight)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(googleBtn.snp.bottom).offset(finalButtonPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(buttonHeight)
        }
    }
    
    /// Toggles whether the Next button can be pressed (also adds the checkmark in the email field)
    func toggleNextButton(enabled: Bool) {
        if enabled {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .fitnessYellow
            nextButton.setTitleColor(.fitnessBlack, for: .normal)
            checkSymbol.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .fitnessMediumGrey
            nextButton.setTitleColor(.fitnessWhite, for: .normal)
            checkSymbol.alpha = 0
        }
    }
    
    @objc func goToNextView() {
        //navigationController?.pushViewController(OnboardingGymsViewController(), animated: true)
        self.present(OnboardingGymsViewController(), animated: true, completion: nil)
    }
    
    // MARK: Email
    func validEmail(email: String) -> Bool {
        // May have multiple .s but only after the @
        
        // Check Validity
        if (email.count < 5 || !email.contains("@") || !email.split(separator: "@")[1].contains(".")) {
            return false
        }
        // ( Send an email to see if it exists )
        return true
    }
    
    @objc func textChanged(sender: Any) {
        if let textField = sender as? UITextField {
            if textField.text != nil && validEmail(email: textField.text!) { // Valid
               toggleNextButton(enabled: true)
            } else { // Not Valid
                toggleNextButton(enabled: false)
            }
        }
    }
    
    // MARK: Log in Helper Function
    /// Returns true if the user is logged in with facebook or google
    func isLoggedIn() -> Bool {
        return isGoogleSignedIn() || false//isFacebookSignedIn() cuz it broke 
    }
    
    
    // MARK:- Facebook Sign In
    @objc func facebookButtonTapped() {
        print("Loggin In??? Google: \(isGoogleSignedIn())   Facebook: \(isFacebookSignedIn())")
        if !isLoggedIn() {
            logIntoFacebook()
        }
    }
    
    func logIntoFacebook() {
        facebookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (loginManagerResult, error) in
            if let loginFailed = error { // Error
                print("facebook login FAILED.")
                print(loginFailed.localizedDescription)
            } else { // Login Success
                self.toggleNextButton(enabled: true)
            }
        }
    }
    
    /// Should be called before actually logging out fo Facebook with the LoginManager
    func logOutOfFacebook() {
//        if !isFacebookSignedIn() { return }
//        let tokenString = FBSDKAccessToken.description()
//        let logout = FBSDKGraphRequest(
//            graphPath: "me/permissions/",
//            parameters: ["accessToken": tokenString],
//            httpMethod: "DELETE")
//        logout?.start(completionHandler: { (connection, whoKnows, error) in
//            switch connection {
//                case .
//            }
//        })
//        logout?.start { (urlResponse, requestResult) in
//            switch requestResult {
//            case .failed(let error):
//                print("Error in Graph: \(error.localizedDescription)")
//            case .success(let graphResponse):
//                self.facebookLoginManager.logOut()
//            }
//        }
        
    }
    
    func isFacebookSignedIn() -> Bool {
        return FBSDKAccessToken.currentAccessTokenIsActive()
    }
    
    // MARK:- Google Sign In
    @objc func googleButtonTapped() {
        print("Loggin In??? Google: \(isGoogleSignedIn())   Facebook: \(isFacebookSignedIn())")
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        if !isLoggedIn() {
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            print("Shared Instance is:  \(GIDSignIn.sharedInstance())")
            print("Has authentication? : \(GIDSignIn.sharedInstance()?.hasAuthInKeychain())")
        }
    }
    
    // Helper
    func isGoogleSignedIn() -> Bool {
        return GIDSignIn.sharedInstance()?.hasAuthInKeychain() ?? false
    }
    
    //MARK: Google Sign In Delegate
    
    // Sign in has stopped loading
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // Nothing
    }
    
    // Present View prompting user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss View that prompted user to sign in
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Sign in Complete
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Store Google Sign in stuff like userID, token, name, email, etc.
            // userID = user.userID
            toggleNextButton(enabled: true)
        } else {
            print(error.localizedDescription)
        }
    }
}
