//
//  File.swift
//  Uplift
//
//  Created by alden lamp on 10/20/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TabbedViewController: UIViewController {

    let tabbedControl: TabbedControl!
    let viewControllers: [UIViewController]!

    private var selectedTab = 0
    private var slideViewLeading: ConstraintMakerEditable?

    init(tabbedControl: TabbedControl, viewControllers: [UIViewController]) {
        self.tabbedControl = tabbedControl
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        for viewController in viewControllers {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(viewController.view)
        }

        tabbedControl.translatesAutoresizingMaskIntoConstraints = false
        tabbedControl.delegate = self
        self.view.addSubview(tabbedControl)
    }

    func setupConstraints() {
        tabbedControl.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(45)
        }

        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.snp.makeConstraints { make in
                make.top.equalTo(tabbedControl.snp.bottom)
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                if index == selectedTab {
                    slideViewLeading = make.leading.equalTo(self.view.snp.leading)
                }
                if index != 0 {
                    make.leading.equalTo(self.viewControllers[index - 1].view.snp.trailing)
                }
            }
        }
    }
}

extension TabbedViewController: TabbedControlDelegate {

    func didMoveTo(index: Int) {
        selectedTab = index
        slideViewLeading?.constraint.deactivate()
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let strongSelf = self {
                strongSelf.viewControllers[strongSelf.selectedTab].view.snp.makeConstraints { make in
                    strongSelf.slideViewLeading = make.leading.equalTo(strongSelf.view.snp.leading)
                }
            }
            self?.view.layoutIfNeeded()
        }
    }

}
