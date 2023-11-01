//
//  GymDetailTabbedControl.swift
//  Uplift
//
//  Created by alden lamp on 10/21/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GymDetailTabbedControl: UIView, TabbedControl {

    // MARK: - Private view vars
    private let dividerView = UIView()
    private let slideView = UIView()
    private var buttons: [UIButton]
    private var slideViewLeading: ConstraintMakerEditable?

    weak var delegate: TabbedControlDelegate?

    // MARK: - Private data vars
    private var currentTab: Int = 0

    init(tabs: [String]) {
        self.buttons = []
        super.init(frame: CGRect.zero)
        self.setupViews(tabs: tabs)
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didClickOnTab(sender: UIButton) {
        let clicked = sender.tag
        if clicked == currentTab {
            return
        }
        self.delegate?.didMoveTo(index: clicked)
        buttons[currentTab].titleLabel?.font = ._12MontserratMedium
        buttons[clicked].titleLabel?.font = ._12MontserratBold
        currentTab = clicked
        slideViewLeading?.constraint.deactivate()
        UIView.animate(withDuration: 0.3) {
            self.slideView.snp.makeConstraints { make in
                self.slideViewLeading = make.leading.equalTo(self.buttons[clicked].snp.leading)
            }
            self.layoutIfNeeded()
        }
    }

    func setupViews(tabs: [String]) {
        for (tab, tabText) in tabs.enumerated() {
            let button = UIButton()
            button.setTitle(tabText, for: .normal)
            button.titleLabel?.font = (tab == 0 ? ._12MontserratBold : ._12MontserratMedium)
            button.setTitleColor(UIColor.primaryBlack, for: .normal)
            button.tag = tab
            button.addTarget(self, action: #selector(didClickOnTab), for: .touchUpInside)
            self.buttons.append(button)

            button.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button)
        }

        dividerView.backgroundColor = .gray01
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dividerView)

        slideView.translatesAutoresizingMaskIntoConstraints = false
        slideView.backgroundColor = UIColor.primaryYellow
        self.addSubview(slideView)
    }

    func setupConstraints() {
        for (index, button) in self.buttons.enumerated() {
            button.snp.updateConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalTo(dividerView.snp.top)
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(self.buttons[index - 1].snp.trailing)
                    make.width.equalTo(self.buttons[index-1].snp.width)
                }
                if index == self.buttons.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
        }

        dividerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(GymDetailConstraints.dividerViewHeight)
        }

        slideView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2 * GymDetailConstraints.dividerViewHeight)
            if currentTab < buttons.count {
                make.width.equalTo(buttons[currentTab].snp.width)
                slideViewLeading = make.leading.equalTo(buttons[currentTab].snp.leading)
            }
        }
    }

}
