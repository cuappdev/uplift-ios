//
//  File.swift
//  Uplift
//
//  Created by alden lamp on 10/20/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class TabbedViewController: UIViewController {

    let tabbedControl: TabbedControl!
    let viewControllers: [UIViewController]!

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
    }

}
