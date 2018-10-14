//
//  String+Shared.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 9/5/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

extension String {

    // Returns the string with the leading zero removed if one exists
    func removeLeadingZero() -> String {
        if (self.hasPrefix("0")) {
            return String( self[String.Index(encodedOffset: 1)...] )
        } else {
            return self
        }
    }

}
