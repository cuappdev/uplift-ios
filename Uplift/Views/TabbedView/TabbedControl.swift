//
//  TabbedControl.swift
//  Uplift
//
//  Created by alden lamp on 10/20/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

protocol TabbedControlDelegate: AnyObject {
    func didMoveTo(index: Int)
}

// TODO: - Implement communication for swipe gesture
protocol TabbedControl: UIView {
    var delegate: TabbedControlDelegate? { get set }
}
