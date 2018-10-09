//
//  PresentationExampleViewController.swift
//  Fitness
//
//  Created by Yassin Mziya on 10/6/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import Presentation

class PresentationExampleViewController: UIViewController {
    
    var myPresentationController: PresentationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myPresentationController = PresentationController(pages: [])
        view.addSubview(myPresentationController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
