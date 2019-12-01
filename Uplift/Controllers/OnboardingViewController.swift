//
//  OnboardingViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Presentation
import SnapKit
import UIKit

class OnboardingViewController: PresentationController {

    private var gyms: [String] = []
    private var classInstances: [GymClassInstance] = []

    // MARK: - Views
    private var viewSlides: [OnboardingView] = []
    private var nextButtons: [OnboardingArrowButton] = []
    private var backButtons: [OnboardingArrowButton] = []
    private var skipButton = UIButton()
    private var endButton = UIButton()
    private var runningManView = UIImageView(image: UIImage(named: ImageNames.runningMan))
    private var dividerView = UIImageView(image: UIImage(named: ImageNames.divider))

    // MARK: - Scaling
    /// Are 0..1 inclusive
    private var horizScaling: CGFloat = 1.0
    private var vertScaling: CGFloat = 1.0

    // MARK: - Animation Progress
    private var selectedOneGym = false
    private var selectedOneClass = false

    // MARK: - Animations

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryWhite
        self.showPageControl = false

        setupOnboardingViews()
        setupViews()
        setupSlides()
        setupBackground()
    }

    /// Initialize with default values
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])

        gyms = ["Helen Newman", "Appel", "Teagle", "Noyes"]
        classInstances = [
                GymClassInstance(classDescription: "", classDetailId: ClassIds.yogaVinyasa, className: "Yoga Vinyasa", duration: 0, endTime: Date(), gymId: "", imageURL: URL(fileURLWithPath: ""), instructor: "", isCancelled: false, location: "", startTime: Date(), tags: []),
                GymClassInstance(classDescription: "", classDetailId: ClassIds.cuRowShockwave, className: "CU Row (Shockwave)", duration: 0, endTime: Date(), gymId: "", imageURL: URL(fileURLWithPath: ""), instructor: "", isCancelled: false, location: "", startTime: Date(), tags: []),
                GymClassInstance(classDescription: "", classDetailId: ClassIds.zumba, className: "Zumba", duration: 0, endTime: Date(), gymId: "", imageURL: URL(fileURLWithPath: ""), instructor: "", isCancelled: false, location: "", startTime: Date(), tags: []),
                GymClassInstance(classDescription: "", classDetailId: ClassIds.musclePump, className: "Muscle Pump", duration: 0, endTime: Date(), gymId: "", imageURL: URL(fileURLWithPath: ""), instructor: "", isCancelled: false, location: "", startTime: Date(), tags: [])
            ]
    }

    init(gymNames: [String], classes: [GymClassInstance]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])

        gyms = gymNames
        classInstances = classes
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Setup
    private func setupOnboardingViews() {
        // Create Slides of Onboarding Views
        viewSlides = [
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding1),
                text: ClientStrings.Onboarding.onboarding1
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding2),
                text: ClientStrings.Onboarding.onboarding2,
                gymNames: gyms
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding3),
                text: ClientStrings.Onboarding.onboarding3,
                classNames: classInstances.map { $0.className }
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding4),
                text: ClientStrings.Onboarding.onboarding4
            )
        ]

        // Calculate Scaling Info
        let viewSize = viewSlides[1].getSize()
        /// Calculations are based off a iPhone 11 Pro Max
        /// Horizontal Scaling resizes the OnboardingViews and  aims to keep the side padding of the table view and phone frame constant
        horizScaling = min(1, (self.view.frame.width - 26) / viewSize.width)
        /// Vertical Scaling resizes the running man and moves divider + button to not intersect OnboardingView
        vertScaling = min(1, (self.view.frame.height - (viewSize.height * horizScaling)) / 50)
        viewSlides.forEach { view in
            let viewSize = view.getSize()
            view.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
            view.transform = CGAffineTransform(
                scaleX: horizScaling,
                y: horizScaling
            )
        }

        // Delegation
        viewSlides[1].favoritesSelectedDelegate = { [weak self] in
            if let `self` = self {
                self.selectedOneGym = !$0.isEmpty
                self.nextButtons[1].isEnabled = self.selectedOneGym
                UIView.animate(withDuration: 0.5, animations: {
                    self.nextButtons[1].backgroundColor = self.selectedOneGym ? .primaryYellow : .none
                })
            }
        }
        viewSlides[2].favoritesSelectedDelegate = { [weak self] in
            if let `self` = self {
                self.selectedOneClass = !$0.isEmpty
                self.nextButtons[2].isEnabled = self.selectedOneClass
                UIView.animate(withDuration: 0.5, animations: {
                    self.nextButtons[2].backgroundColor = self.selectedOneClass ? .primaryYellow : .none
                })
            }
        }

    }

    private func setupViews() {
        endButton.backgroundColor = .primaryYellow
        endButton.setTitle(ClientStrings.Onboarding.endButton, for: .normal)
        endButton.titleLabel?.font = ._16MontserratBold
        endButton.setTitleColor(.primaryBlack, for: .normal)
        endButton.layer.shadowOpacity = 0.125
        endButton.layer.cornerRadius = 5
        endButton.layer.shadowRadius = 5
        endButton.layer.shadowOffset = CGSize(width: 2, height: 4)
        endButton.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        endButton.frame = CGRect(x: 0, y: 0, width: 269, height: 48)
        endButton.alpha = 0

        nextButtons = [
            OnboardingArrowButton(arrowFacesRight: true),
            OnboardingArrowButton(arrowFacesRight: true, enabled: false),
            OnboardingArrowButton(arrowFacesRight: true, enabled: false)
        ]
        nextButtons.forEach {
            $0.frame = CGRect(x: 0, y: 90, width: 35, height: 35)
            $0.addTarget(self, action: #selector(arrowsPressed(sender:)), for: .touchUpInside)
        }
        nextButtons[1...2].forEach { $0.alpha = 0 }

        backButtons = [
            OnboardingArrowButton(arrowFacesRight: false, changesColor: false),
            OnboardingArrowButton(arrowFacesRight: false, changesColor: false)
        ]
        backButtons.forEach {
            $0.backgroundColor = .none
            $0.frame = CGRect(x: 0, y: 90, width: 35, height: 35)
            $0.addTarget(self, action: #selector(arrowsPressed(sender:)), for: .touchUpInside)
        }
        backButtons[1].alpha = 0

        skipButton.setTitle(ClientStrings.Onboarding.skipButton, for: .normal)
        skipButton.titleLabel?.font = ._16MontserratBold
        skipButton.setTitleColor(.gray05, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        skipButton.frame = CGRect(x: 0, y: 0, width: 40, height: 20)

        dividerView.contentMode = .scaleAspectFill
        dividerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: 2))
        }

        runningManView.contentMode = .scaleAspectFit
        runningManView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64 * vertScaling, height: 64 * vertScaling))
        }
    }

    private func setupSlides() {
        // Onboarding View without TableView
        let slidesTitleEnding = [viewSlides[0], viewSlides[3]].map { view -> Content in
            let position = Position(left: 0.5, top: 0.45 * horizScaling)
            return Content(view: view, position: position)
        }
        // Onboarding View with TableView
        let slidesGymsClasses = viewSlides[1...2].map { view -> Content in
            let position = Position(left: 0.5, top: 0.52 * horizScaling)
            return Content(view: view, position: position)
        }
        let contentSlides = [
            slidesTitleEnding[0], slidesGymsClasses[0], slidesGymsClasses[1], slidesTitleEnding[1]
        ]

        let slides = contentSlides.map { SlideController(contents: [$0]) }
        add(slides)
    }

    private func setupBackground() {
        let scalingOffset = 0.25 - (vertScaling * 0.25)

        let dividerPosition = Position(left: 0.5, bottom: 0.162 - scalingOffset)
        let divider = Content(view: dividerView, position: dividerPosition)

        let runningManVerticalPosition = 0.197 - scalingOffset
        let runningInitPosition = Position(left: -0.3, bottom: runningManVerticalPosition)
        let runningMan = Content(view: runningManView, position: runningInitPosition)

        let skipButtonPosition = Position(left: 0.5, bottom: 0.11 - scalingOffset)
        let skipButtonContent = Content(view: skipButton, position: skipButtonPosition)

        let backButtonContents = backButtons.map { button -> Content in
            let position = Position(left: 0.154, bottom: 0.11 - scalingOffset)
            return Content(view: button, position: position)
        }

        let nextButtonContents = nextButtons.map { button -> Content in
            let position = Position(right: 0.154, bottom: 0.11 - scalingOffset)
            return Content(view: button, position: position)
        }

        let buttonPosition = Position(left: 0.5, bottom: 0.11 - scalingOffset)
        let endOnboardingContent = Content(view: endButton, position: buttonPosition, centered: true)

        var backgroundContents = [divider, runningMan, endOnboardingContent, skipButtonContent]
        backgroundContents += nextButtonContents
        backgroundContents += backButtonContents 
        addToBackground(backgroundContents)

        // Bring buttons to front so user can tap
        backgroundContents.forEach {
            if let button = $0.view as? UIButton { view.bringSubviewToFront(button) }
        }

        // Running Man Animations
         addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.1, bottom: runningManVerticalPosition))
            ], forPage: 0)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.3, bottom: runningManVerticalPosition))
            ], forPage: 1)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.6, bottom: runningManVerticalPosition))
            ], forPage: 2)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.8, bottom: runningManVerticalPosition))
            ], forPage: 3)

        addAnimations([
            FadeOutAnimation(content: endOnboardingContent, duration: 0.5, willFadeIn: true)
        ], forPage: 3)

        // Arrow Animations
        addAnimations([
            DissolveAnimation(content: nextButtonContents[0], duration: 0.5, initial: true)
        ], forPage: 0)
        addAnimations([
            FadeOutAnimation(content: nextButtonContents[0], duration: 0.5, willFadeIn: false),

            DissolveAnimation(content: nextButtonContents[1], duration: 0.5),
            DissolveAnimation(content: backButtonContents[0], duration: 0.5)
        ], forPage: 1)

        addAnimations([
            FadeOutAnimation(content: nextButtonContents[1], duration: 0.5, willFadeIn: false),
            FadeOutAnimation(content: backButtonContents[0], duration: 0.5, willFadeIn: false),

            DissolveAnimation(content: nextButtonContents[2], duration: 0.5),
            DissolveAnimation(content: backButtonContents[1], duration: 0.5)
        ], forPage: 2)

        // Fade Animations
        addAnimations([
            FadeOutAnimation(content: backButtonContents[1], duration: 0.5)
        ], forPage: 3)
        addAnimations([
            FadeOutAnimation(content: skipButtonContent, duration: 0.5)
        ], forPage: 3)
        addAnimations([
            FadeOutAnimation(content: nextButtonContents[2], duration: 0.5)
        ], forPage: 3)

        addAnimations([
            FadeOutAnimation(content: endOnboardingContent, duration: 0.5, willFadeIn: true)
        ], forPage: 3)

    }

    // MARK: - Helper
    @objc private func arrowsPressed(sender: UIButton) {
        if let button = sender as? OnboardingArrowButton {
            goTo(nextButtons.contains(button) ? currentIndex + 1 : currentIndex - 1)
        }
    }

    @objc func dismissOnboarding() {
        // update UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Identifiers.hasSeenOnboarding)
        updateUserDefaults(with: viewSlides[1].favorites, and: viewSlides[2].favorites)

        // snapshot current view
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let snapshot = appDelegate.window?.snapshotView(afterScreenUpdates: true) else { return }

        // set new rootViewController
        appDelegate.window?.rootViewController = TabBarController()

        // exit transition for snapshot
        UIView.animate(withDuration: 0.5, animations: {
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }) { _ in
            snapshot.removeFromSuperview()
        }
    }

    private func updateUserDefaults(with gyms: [String], and classNames: [String]) {
        let defaults = UserDefaults.standard
        // Gyms
        var favoriteGyms: [String] = []
        // If User selected "Teagle", set "Teagle Up" and "Teagle Down" as their favorite gyms
        gyms.forEach {
            if $0 == "Teagle" {
                favoriteGyms.append(contentsOf: ["Teagle Up", "Teagle Down"])
            } else {
                favoriteGyms.append($0)
            }
        }
        defaults.set(favoriteGyms, forKey: Identifiers.favoriteGyms)

        // Classes
        var favoriteClasses: [String] = []
        for i in 0..<classNames.count where classNames[i] == classInstances[i].classDetailId {
            favoriteClasses.append(classInstances[i].classDetailId)
        }
        defaults.set(favoriteClasses, forKey: Identifiers.favoriteClasses)
    }

}
