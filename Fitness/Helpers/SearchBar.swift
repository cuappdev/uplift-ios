//
//  SearchBar.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
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
        textfield?.textColor = UIColor.white
        textfield?.font = ._12MontserratRegular
        return searchBar
    }
}

extension UISearchBar {
    // Change color of textfield by iterating through subviews
    func changeSearchBarColor(color : UIColor) {
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
