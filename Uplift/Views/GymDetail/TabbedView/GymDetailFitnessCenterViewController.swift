//
//  GymDetailFitnessCenterTabController.swift
//  Uplift
//
//  Created by alden lamp on 10/21/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class GymDetailFitnessCenterViewController: UIViewController {

    let color: UIColor!

    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.color

    }

}
