//
//  PresntationExampleViewController.swift
//  Fitness
//
//  Created by Yassin Mziya on 10/6/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import Presentation
import SnapKit

class OnboardingViewController: PresentationController {
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        // self.showBottomLine = true
        self.showPageControl = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureSlides()
        configureBackground()
    }
    
    private func configureSlides() {
        let images = [#imageLiteral(resourceName: "onboarding_1"), #imageLiteral(resourceName: "onboarding_2"), #imageLiteral(resourceName: "onboarding_3"), #imageLiteral(resourceName: "onboarding_4")].map { (image) -> Content in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints({ make in
                make.height.width.equalTo(214)
            })
            let position = Position(left: 0.5, top: 0.47)
            return Content(view: imageView, position: position)
        }
        
        var slides = [SlideController]()

        for index in 0..<images.count {
            let contents = [images[index]]
            let controller = SlideController(contents: contents)
            
            slides.append(controller)
        }
        
        add(slides)
    }
    
    private func configureBackground() {
        let dividerImageView = UIImageView(image: #imageLiteral(resourceName: "divider"))
        dividerImageView.contentMode = .scaleAspectFill
        dividerImageView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(2)
        }
        let divider = Content(view: dividerImageView, position: Position(left: 0.5, bottom: 0.196))
        
        let runningManImageView = UIImageView(image: #imageLiteral(resourceName: "running-man"))
        runningManImageView.contentMode = .scaleAspectFill
        runningManImageView.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalTo(47)
        }
        let runningMan = Content(view: runningManImageView, position: Position(left: -0.3, bottom: 0.23))
        
        let contents = [
            runningMan,
            divider
        ]
        addToBackground(contents)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.1, bottom: 0.23))
            ], forPage: 0)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.3, bottom: 0.23))
            ], forPage: 1)

        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.6, bottom: 0.23))
            ], forPage: 2)
        
        addAnimations([
            TransitionAnimation(content: runningMan, destination: Position(left: 0.8, bottom: 0.23))
            ], forPage: 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        view.backgroundColor = .white
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
