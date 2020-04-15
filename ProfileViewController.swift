//
//  ProfileViewController.swift
//  Uplift
//
//  Created by Cameron Hamidi on 4/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class ProfileViewController: UIViewController {
    
    private var profileView: ProfileView!
    
    init(from profileView: ProfileView) {
        super.init(nibName: nil, bundle: nil)

        self.profileView = profileView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true

        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
