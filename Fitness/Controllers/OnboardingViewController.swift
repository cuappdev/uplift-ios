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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        configureSlides()
        configureBackground()
    }

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        // self.showBottomLine = true
        self.showPageControl = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissOnboarding() {
        print("superbad, call me mclovin")
        let tabBarController = TabBarController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let snapshot: UIView! = appDelegate.window?.snapshotView(afterScreenUpdates: true)!
        tabBarController.view.addSubview(snapshot)
        
        appDelegate.window?.rootViewController = tabBarController
        
        UIView.animate(withDuration: 0.5, animations: {
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }) { _ in
            snapshot.removeFromSuperview()
        }
    }

    private func configureSlides() {
        // Images
        var images = [#imageLiteral(resourceName: "onboarding_1"), #imageLiteral(resourceName: "onboarding_2"), #imageLiteral(resourceName: "onboarding_3"), #imageLiteral(resourceName: "onboarding_4")].map { (image) -> Content in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints({ make in
                make.height.width.equalTo(214)
            })
            let position = Position(left: 0.5, top: 0.47)
            return Content(view: imageView, position: position)
        }
        
        // Button
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 235, height: 64)
        button.setTitle("BEGIN", for: .normal)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        button.titleLabel?.font = UIFont._14MontserratBold
        button.backgroundColor = .fitnessYellow
        button.layer.cornerRadius = 32
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        button.layer.shadowOpacity = 0.5
        let buttonPosition = Position(left: 0.5, top: 0.71)
        let startButton = Content(view: button, position: buttonPosition, centered: true)
        

        // Add content to slides
        var slides = [SlideController]()

        for index in 0..<images.count {
            var contents = [images[index]]
            if index == images.count - 1 {
                contents.append(startButton)
            }
            
            let controller = SlideController(contents: contents)

            slides.append(controller)
        }

        add(slides)
    }

    private func configureBackground() {
        // DIVIDER
        let dividerImageView = UIImageView(image: #imageLiteral(resourceName: "divider"))
        dividerImageView.contentMode = .scaleAspectFill
        dividerImageView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(2)
        }
        let divider = Content(view: dividerImageView, position: Position(left: 0.5, bottom: 0.196))

        // RUNNING MAN
        let runningManImageView = UIImageView(image: #imageLiteral(resourceName: "running-man"))
        runningManImageView.contentMode = .scaleAspectFill
        runningManImageView.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(47)
        }
        let runningMan = Content(view: runningManImageView, position: Position(left: -0.3, bottom: 0.23))

        // SET UP BG CONTENT
        let contents = [
            runningMan,
            divider
        ]
        addToBackground(contents)

        // SET UP ANIMATIONS
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
