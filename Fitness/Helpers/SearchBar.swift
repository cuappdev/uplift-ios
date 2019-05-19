//
//  SearchBar.swift
//  Fitness
//
//  Created by Cornell AppDev on 3/21/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation
import UIKit

struct SearchBar {
    static func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "find a way to sweat"

        searchBar.changeSearchBarColor(color: .white)

        let textfield = searchBar.value(forKey: "searchField") as? UITextField
        textfield?.textColor = UIColor.fitnessBlack
        textfield?.font = ._12MontserratRegular
        return searchBar
    }
}

extension UISearchBar {
    // Change color of textfield by iterating through subviews
    func changeSearchBarColor(color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
            }
        }
    }
}
