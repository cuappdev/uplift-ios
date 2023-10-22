//
//  GymDetailTabbedController.swift
//  Uplift
//
//  Created by alden lamp on 10/20/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GymDetailTabbedControllerCell: UICollectionViewCell {

    static let reuseId = "gymDetailTabbedControllerCellIdentifier"

    private var viewControllers: [UIViewController] = []
    private var control: GymDetailTabbedControl!

    var selectedTab = 0
    private var slideViewLeading: ConstraintMakerEditable?

    override init(frame: CGRect) {
        super.init(frame: frame)

        control = GymDetailTabbedControl(tabs: ["Fitness Center", "Facilities"])
        viewControllers = [GymDetailFitnessCenterViewController(color: UIColor.green),
                           GymDetailFitnessCenterViewController(color: UIColor.blue)]

        setupViews()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {

        for viewController in viewControllers {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(viewController.view)
        }
        control.translatesAutoresizingMaskIntoConstraints = false
        control.delegate = self
        self.contentView.addSubview(control)
    }

    func setupConstraints() {
        control.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(45)
        }

        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.snp.makeConstraints { make in
                make.top.equalTo(control.snp.bottom)
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                if index == selectedTab {
                    slideViewLeading = make.leading.equalTo(self.contentView.snp.leading)
                }
                if index != 0 {
                    make.leading.equalTo(self.viewControllers[index - 1].view.snp.trailing)
                }
            }
        }
    }

    // TODO: - Self sizing cells
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        if let width = self.contentView.superview?.superview?.frame.size.width {
//            layoutAttributes.frame.size.width = width
//        }
//        layoutAttributes.bounds.size.height = 700
//        return layoutAttributes
//    }

}

extension GymDetailTabbedControllerCell: TabbedControlDelegate {

    func didMoveTo(index: Int) {
        selectedTab = index
        slideViewLeading?.constraint.deactivate()
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let strongSelf = self {
                strongSelf.viewControllers[strongSelf.selectedTab].view.snp.makeConstraints { make in
                    strongSelf.slideViewLeading = make.leading.equalTo(strongSelf.contentView.snp.leading)
                }
            }
            self?.layoutIfNeeded()
        }
    }

}
