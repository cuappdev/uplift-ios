//
//  SportsDetailViewController.swift
//  Uplift
//
//  Created by Artesia Ko on 3/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailViewController: UIViewController {
    
    private var post: Post!
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
