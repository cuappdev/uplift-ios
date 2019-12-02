//
//  OnboardingAnimations.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Presentation
import UIKit

// MARK: - Arrow Button Transition

/// Transition that changes arrow colors when swiping
public class ArrowButtonTransition: NSObject, Animatable {

    private let content: Content
    private let duration: TimeInterval
    private let delay: TimeInterval
    private var played = false
    /// Used for the first arrow: turns yellow always when doing playBack
    private var isFirstArrow = false

    var transitionIsEnabled = false

    public init(content: Content,
                duration: TimeInterval = 1.0,
                delay: TimeInterval = 0.0,
                firstArrow: Bool = false) {
        self.content = content
        self.duration = duration
        self.delay = delay

        /// Animation for first arrow in sequence
        /// When transitioning backwards, should always be enabled
        if firstArrow {
            isFirstArrow = firstArrow
            transitionIsEnabled = true
        }

        super.init()
    }

    private func animate(_ towardsEnabled: Bool) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: ({ [unowned self] in
                self.content.view.backgroundColor = towardsEnabled ? .primaryYellow : .none
            }),
            completion: { [unowned self] completedAnimation in
                if let button = self.content.view as? UIButton, completedAnimation {
                    button.isEnabled = self.transitionIsEnabled
                }
                self.played = false
            }
        )

        played = true
    }

}

extension ArrowButtonTransition {

    public func play() {
        if content.view.superview != nil {
            if !played { animate(transitionIsEnabled) }
        }
    }

    public func playBack() {
        if content.view.superview != nil {
            if !played { animate(transitionIsEnabled) }
        }
    }

    public func moveWith(offsetRatio: CGFloat) {
        let view = content.view
        if view.layer.animationKeys() == nil {
            if view.superview != nil {
                animate(isFirstArrow || transitionIsEnabled)
            }
        }
    }

}

// MARK: - Fade Out + Disable Button
public class FadeOutAnimation: NSObject, Animatable {

    private let content: Content
    private let duration: TimeInterval

    private let fadesIn: Bool
    private var played = false

    public init(content: Content,
                duration: TimeInterval = 1.0,
                willFadeIn: Bool = false) {
        fadesIn = willFadeIn

        self.content = content
        self.duration = duration

        super.init()
    }

    private func animate(fadeIn: Bool) {
        let targetAlpha: CGFloat = fadeIn ? 1.0 : 0.0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: ({ [unowned self] in
                self.content.view.alpha = targetAlpha
            }),
            completion: { _ in
                self.played = false
            }
        )

        played = true
    }

}

extension FadeOutAnimation {

    public func play() {
        if content.view.superview != nil, !played {
            animate(fadeIn: fadesIn)
        }
    }

    public func playBack() {
        if content.view.superview != nil, !played {
            animate(fadeIn: !fadesIn)
        }
    }

    public func moveWith(offsetRatio: CGFloat) {
        let view = content.view
        if view.layer.animationKeys() == nil {
            if view.superview != nil {
                let ratio = offsetRatio > 0.0 ? offsetRatio : (1.0 + offsetRatio)
                let targetAlpha = max(0.0, min(1.0, ratio))
                view.alpha = fadesIn ? targetAlpha : 1 - targetAlpha
            }
        }
    }

}
