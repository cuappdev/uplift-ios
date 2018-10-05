//
//  OnboardingViewController.swift
//  Fitness
//
//  Created by Yassin Mziya on 10/3/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit
import Presentation

class OnboardingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!
    
    var panelImages = [#imageLiteral(resourceName: "onboarding_1"), #imageLiteral(resourceName: "onboarding_2"), #imageLiteral(resourceName: "onboarding_3"), #imageLiteral(resourceName: "onboarding_4")]
    let onboardingCell = "onboardingCellReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: onboardingCell)
        view.addSubview(collectionView)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = panelImages.count
        pageControl.pageIndicatorTintColor = UIColor(red: 216/255, green: 216/255, blue: 216/266, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 112/255, green: 112/255, blue: 112/266, alpha: 1)
        view.addSubview(pageControl)
        
        setupConstraints()
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(180)
            make.bottom.equalToSuperview().offset(-273)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-44)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = targetContentOffset.pointee.x/view.frame.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return panelImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: onboardingCell, for: indexPath) as! OnboardingCell
        cell.imageView.image = panelImages[indexPath.row]
        cell.setNeedsUpdateConstraints()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
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
