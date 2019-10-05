//
//  PresntationExampleViewController.swift
//  Uplift
//
//  Created by Yassin Mziya on 10/6/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Presentation
import SnapKit
import UIKit

class OnboardingViewController: PresentationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureSlides()
        configureBackground()
    }

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func configureSlides() {
        // slide images
        let images = [UIImage(named: ImageNames.onboarding1), UIImage(named: ImageNames.onboarding2), UIImage(named: ImageNames.onboarding3), UIImage(named: ImageNames.onboarding4)].map { image -> Content in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(214)
            }
            let position = Position(left: 0.5, top: 0.47)
            return Content(view: imageView, position: position)
        }

        // dismiss button
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 235, height: 64)
        button.setTitle("BEGIN", for: .normal)
        button.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        button.titleLabel?.font = ._14MontserratBold
        button.setTitleColor(UIColor.fitnessBlack, for: .normal)

        button.backgroundColor = .fitnessYellow
        button.layer.cornerRadius = 32
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.buttonShadow.cgColor
        button.layer.shadowOpacity = 0.5
        let buttonPosition = Position(left: 0.5, top: 0.71)
        let startButton = Content(view: button, position: buttonPosition, centered: true)

        // add content to slides
        var slides = [SlideController]()

        for index in 0..<images.count {
            var contents = [images[index]]
            if index == images.count - 1 {
                contents.append(startButton)
            }
            let controller = SlideController(contents: contents)
            slides.append(controller)
        }

        add(slides)
    }

    private func configureBackground() {
        // divider
        let dividerImageView = UIImageView(image: UIImage(named: ImageNames.divider))
        dividerImageView.contentMode = .scaleAspectFill
        dividerImageView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(2)
        }
        let divider = Content(view: dividerImageView, position: Position(left: 0.5, bottom: 0.195))

        // running man
        let runningManImageView = UIImageView(image: UIImage(named: ImageNames.runningMan))
        runningManImageView.contentMode = .scaleAspectFill
        runningManImageView.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(47)
        }
        let runningMan = Content(view: runningManImageView, position: Position(left: -0.3, bottom: 0.23))

        // bg content
        let contents = [runningMan, divider]
        addToBackground(contents)

        // animations
        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.1, bottom: 0.23))
            ], forPage: 0)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.3, bottom: 0.23))
            ], forPage: 1)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.6, bottom: 0.23))
            ], forPage: 2)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.8, bottom: 0.23))
            ], forPage: 3)
    }
}
