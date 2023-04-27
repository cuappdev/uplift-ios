//
//  Sport.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/9/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

struct Activity {
    
    let name: String
    var image: UIImage
    var isFavorite: Bool

    init(name: String, image: UIImage, isFavorite: Bool) {
        self.name = name
        self.image = image
        self.isFavorite = isFavorite
    }
    
}
