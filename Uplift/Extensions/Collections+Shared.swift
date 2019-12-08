//
//  Collections+Shared.swift
//  Uplift
//
//  Created by Kevin Chan on 12/8/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

}
