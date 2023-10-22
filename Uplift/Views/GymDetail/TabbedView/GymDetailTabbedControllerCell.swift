//
//  GymDetailTabbedController.swift
//  Uplift
//
//  Created by alden lamp on 10/20/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class GymDetailTabbedControllerCell: UICollectionViewCell {

    static let reuseId = "gymDetailTabbedControllerCellIdentifier"

    private var viewControllers: [UIViewController] = []
    private var control: GymDetailTabbedControl!
    private var tabbedViewContoller: TabbedViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)

        control = GymDetailTabbedControl(tabs: ["Fitness Center", "Facilities"])
        viewControllers = [GymDetailFitnessCenterViewController(color: UIColor.green),
                           GymDetailFitnessCenterViewController(color: UIColor.blue)]

        tabbedViewContoller = TabbedViewController(tabbedControl: control, viewControllers: viewControllers)

        setupViews()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.tabbedViewContoller.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.tabbedViewContoller.view)
    }

    func setupConstraints() {
        tabbedViewContoller.view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

}
