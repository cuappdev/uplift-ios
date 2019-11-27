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
    private var classInstances: [GymClassInstance] = []

    // MARK: - Views
    private var viewSlides: [OnboardingView] = []
    private var horizScaling: CGFloat = 1.0
    private var vertScaling: CGFloat = 1.0
    private var endButton = UIButton()
    private var runningPersonView = UIImageView(image: UIImage(named: ImageNames.runningMan))
    private var dividerView = UIImageView(image: UIImage(named: ImageNames.divider))

    // MARK: - Animation Progress
    private var selectedOneGym = false
    private var selectedOneClass = false

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryWhite
        self.showPageControl = false

        self.setupOnboardingViews()
        self.setupViews()
        self.setupSlides()
        self.setupBackground()
    }

    init(gymNames: [String], classes: [GymClassInstance]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        gyms = gymNames
        classInstances = classes
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupOnboardingViews() {
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
                classNames: classInstances.map { $0.className }
            ),
            OnboardingView(
                image: UIImage(named: ImageNames.onboarding4)!,
                text: ClientStrings.Onboarding.onboarding4
            )
        ]

        // Calculaten Scaling Info, Using a slide with table view as reference
        let viewSize = viewSlides[1].getSize()
        // Horizontal Scaling based off maintaing side spacing
        horizScaling = min(1, (self.view.frame.width - 26) / viewSize.width)
         // Vertical Spacing maintains bottom spacing for running man
        // TODO: fix this since we dont have frames anymore
        vertScaling = min(1, (self.view.frame.height - (viewSize.height * horizScaling)) / 50)//196
        print("full frame height: \(self.view.frame.height)")
        print("view frame height: \(viewSize.height * horizScaling)")
        print("view frame scaling math: \(self.view.frame.height - (viewSize.height * horizScaling))")
        print("full frame width: \(self.view.frame.width)")
        print("view frame width: \(viewSize.width * horizScaling)")
        print("---")
        print("horizScaling: \(horizScaling)")
        print("vertScaling: \(vertScaling)")
        print("---")

        viewSlides.forEach { view in
            let viewSize = view.getSize()
            view.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
            view.transform = CGAffineTransform(
                scaleX: horizScaling,
                y: horizScaling
            )
        }

        // Delegation
        viewSlides[1].delegate = { [weak self] in
            if let `self` = self {
                self.selectedOneGym = !$0.isEmpty
            }
        }
        viewSlides[2].delegate = { [weak self] in
            if let `self` = self {
                self.selectedOneClass = !$0.isEmpty
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
        endButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 269, height: 48))
        }

        dividerView.contentMode = .scaleAspectFill
        dividerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: 2))
        }

        runningPersonView.contentMode = .scaleAspectFit
        runningPersonView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64 * vertScaling, height: 64 * vertScaling))
        }
    }

    // MARK: - Setup
    private func setupSlides() {
        let contentSlides = [
            [viewSlides[0]].map { view -> Content in
                let position = Position(left: 0.5, top: 0.45 * horizScaling)//0.47)
                return Content(view: view, position: position)
            },
            viewSlides[1...2].map { view -> Content in
                let position = Position(left: 0.5, top: 0.52 * horizScaling)//0.47)
                return Content(view: view, position: position)
            },
            [viewSlides[3]].map { view -> Content in
                let position = Position(left: 0.5, top: 0.45 * horizScaling)
                return Content(view: view, position: position)
            }
        ].flatMap { $0 }

        var slides = [SlideController]()
        contentSlides.forEach {
            slides.append(SlideController(contents: [$0]))
        }

        add(slides)
    }

    private func setupBackground() {
        let scalingOffset = 0.25 - (vertScaling * 0.25)

        let dividerPosition = Position(left: 0.5, bottom: 0.162 - scalingOffset)//0.195)
        let divider = Content(view: dividerView, position: dividerPosition)

        let runningInitPosition = Position(left: -0.3, bottom: 0.197 - scalingOffset)//0.23)
        let runningPerson = Content(view: runningPersonView, position: runningInitPosition)

        let buttonPosition = Position(left: 0.5, bottom: 0.11 - scalingOffset)//0.71)
        let endOnboardingContent = Content(view: endButton, position: buttonPosition, centered: true)

        let backgroundContents = [divider, runningPerson, endOnboardingContent]
        addToBackground(backgroundContents)
        view.bringSubviewToFront(endOnboardingContent.view)

        // Running Man Animations
         addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.1, bottom: 0.197 - scalingOffset))
            ], forPage: 0)

        addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.3, bottom: 0.197 - scalingOffset))
            ], forPage: 1)

        addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.6, bottom: 0.197 - scalingOffset))
            ], forPage: 2)

        addAnimations([
            TransitionAnimation(content: runningPerson, destination: Position(left: 0.8, bottom: 0.197 - scalingOffset))
            ], forPage: 3)

        addAnimations([
            FadeOutAnimation(content: endOnboardingContent, duration: 0.5, delay: 0.5, willFadeIn: true)
        ], forPage: 3)

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

    // MARK: - Helper
    private func updateUserDefaults(with gyms: [String], and classNames: [String]) {
        let defaults = UserDefaults.standard
        // Gyms
        var favoriteGyms: [String] = []
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
