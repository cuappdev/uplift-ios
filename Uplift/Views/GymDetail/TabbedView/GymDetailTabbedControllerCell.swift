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

    var fitnessCenters: [FitnessCenter]?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(fitnessCenters: [FitnessCenter]) {
        if self.tabbedViewContoller != nil {
            self.tabbedViewContoller.view.removeFromSuperview()
        }

        self.fitnessCenters = fitnessCenters

        var tabs = [String]()
        self.viewControllers = []

        for fitnessCenter in fitnessCenters {
            tabs.append(fitnessCenters.count == 1 ? "Fitness Center" : fitnessCenter.name)
            viewControllers.append(GymDetailFitnessCenter(fitnessCenter: fitnessCenter))
        }

        control = GymDetailTabbedControl(tabs: tabs)
        tabbedViewContoller = TabbedViewController(tabbedControl: control, viewControllers: viewControllers)

        setupViews()
        setupConstraints()
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
