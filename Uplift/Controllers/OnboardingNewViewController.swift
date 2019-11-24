//
//  OnboardingNewViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Presentation
import SnapKit
import UIKit

class OnboardingNewViewController: PresentationController {

    private var gyms: [String] = []
    private var classes: [String] = []

    // MARK: - Views
    private var viewSlides: [OnboardingView] = []
    private var nextButton = OnboardingArrowButton(arrowFacesRight: true)
    private var backButton = OnboardingArrowButton(arrowFacesRight: false, changesColor: false)
    private var skipButton = UIButton()
    private var endButton = UIButton()
    private var runningPersonView = UIImageView(image: UIImage(named: ImageNames.runningMan))
    private var dividerView = UIImageView(image: UIImage(named: ImageNames.divider))

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryWhite

        self.setupViews()
        self.setupSlides()
        self.setupBackground()
    }

    init(gymNames: [String], classNames: [String]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        gyms = gymNames
        classes = classNames
        print("gyms: \(gyms)")
        print("classes: \(classes)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        viewSlides = [
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding1)!,
                text: ClientStrings.Onboarding.onboarding1
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding2)!,
                text: ClientStrings.Onboarding.onboarding2,
                gymNames: gyms
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding3)!,
                text: ClientStrings.Onboarding.onboarding3,
                classNames: classes
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding4)!,
                text: ClientStrings.Onboarding.onboarding4
            )
        ]
        viewSlides.forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalTo(348)
                make.height.equalTo(view.getHeight())
            }
        }

        endButton.backgroundColor = .primaryYellow
        endButton.setTitle(ClientStrings.Onboarding.endButton, for: .normal)
        endButton.titleLabel?.font = ._16MontserratBold
        endButton.setTitleColor(.primaryBlack, for: .normal)
        endButton.layer.shadowOpacity = 0.125
        endButton.layer.cornerRadius = 5
        endButton.layer.shadowRadius = 5
        endButton.layer.shadowOffset = CGSize(width: 2, height: 4)
        endButton.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        endButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 269, height: 48))
        }

        nextButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }

        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }

        skipButton.setTitle(ClientStrings.Onboarding.skipButton, for: .normal)
        skipButton.titleLabel?.font = ._16MontserratBold
        skipButton.setTitleColor(.gray05, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 20))
        }

        dividerView.contentMode = .scaleAspectFit
        dividerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: 2))
        }

        runningPersonView.contentMode = .scaleAspectFit
        runningPersonView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
    }

    // MARK: - Setup
    private func setupSlides() {
        let contentSlides = [
            [viewSlides[0]].map { view -> Content in
                let position = Position(left: 0.5, top: 0.3)//0.47)
                return Content(view: view, position: position)
            },
            viewSlides[1...2].map { view -> Content in
                let position = Position(left: 0.5, top: 0.1)//0.47)
                return Content(view: view, position: position)
            },
            [viewSlides[3]].map { view -> Content in
                let position = Position(left: 0.5, top: 0.3)
                return Content(view: view, position: position)
            }
        ].flatMap { $0 }

        let buttonPosition = Position(left: 0.5, top: 0.71)
        let endOnboardingContent = Content(view: endButton, position: buttonPosition, centered: true)

        var slides = [SlideController]()

        for index in 0..<contentSlides.count {
            var contents = [contentSlides[index]]
            if index == contentSlides.count - 1 {
                contents.append(endOnboardingContent)
            }
            let controller = SlideController(contents: contents)
            slides.append(controller)
        }

        add(slides)

    }

    private func setupBackground() {
        let dividerPosition = Position(left: 0.5, bottom: 0.195)
        let divider = Content(view: dividerView, position: dividerPosition)

        let runningInitPosition = Position(left: -0.3, bottom: 0.23)
        let runningPerson = Content(view: runningPersonView, position: runningInitPosition)

        let skipButtonPosition = Position(left: 0.5, bottom: 0.095)
        let skipButtonContent = Content(view: skipButton, position: skipButtonPosition)

        let backButtonPosition = Position(left: 0.154, bottom: 0.095)
        let backButtonContent = Content(view: backButton, position: backButtonPosition)

        let nextButtonPosition = Position(right: 0.154, bottom: 0.095)
        let nextButtonContent = Content(view: nextButton, position: nextButtonPosition)

        let backgroundContents = [divider, runningPerson, skipButtonContent, backButtonContent, nextButtonContent]
        addToBackground(backgroundContents)

        // Animations
         addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.1, bottom: 0.23))
            ], forPage: 0)

        addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.3, bottom: 0.23))
            ], forPage: 1)

        addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.6, bottom: 0.23))
            ], forPage: 2)

        addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.8, bottom: 0.23))
            ], forPage: 3)
    }

    @objc func dismissOnboarding() {
        // update UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Identifiers.hasSeenOnboarding)

        // snapshot current view
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let snapshot = appDelegate.window?.snapshotView(afterScreenUpdates: true) else { return }

        // set new rootViewController
        appDelegate.window?.rootViewController = OnboardingGymsViewController()

        // exit transition for snapshot
        UIView.animate(withDuration: 0.5, animations: {
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }) { _ in
            snapshot.removeFromSuperview()
        }
    }


}
