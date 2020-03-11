//
//  FilterButton.swift
//  Uplift
//
//  Created by Artesia Ko on 3/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class FilterButton: UIButton {
    private var filterActive: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .primaryWhite
        self.setTitle(ClientStrings.Filter.applyFilterLabel, for: .normal)
        self.titleLabel?.font = ._14MontserratBold
        self.layer.cornerRadius = 24.0
        self.setTitleColor(.black, for: .normal)
        self.layer.shadowColor = UIColor.buttonShadow.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        
    }
    
    func toggleButton() {
        filterActive = !filterActive
        self.backgroundColor = filterActive ? .primaryYellow : .white
        self.setTitle(filterActive ? ClientStrings.Filter.appliedFilterLabel : ClientStrings.Filter.applyFilterLabel, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
