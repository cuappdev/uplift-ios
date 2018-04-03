//
//  FilterViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FilterViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var collectionViewTitle: UILabel!
    var collectionView: UICollectionView!
    
    var separatorOne: UIView!
    var startTimeLabel: UILabel!
    var startTime: UILabel!
    var startTimeSlider: UISlider!  //placeholder: to be replaced with a slider with range functionality
    var separatorTwo: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //NAVIGATION BAR
        let titleView = UILabel()
        titleView.text = "Refine Search"
        titleView.font = ._14LatoBlack
        self.navigationItem.titleView = titleView
        
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        let resetBarButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        self.navigationItem.leftBarButtonItem = resetBarButton
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(view)
        }
        
        //COLLECTION VIEW
        collectionViewTitle = UILabel()
        collectionViewTitle.font = ._12LatoBlack
        collectionViewTitle.textColor = .fitnessDarkGrey
        collectionViewTitle.text = "FITNESS CENTER"
        contentView.addSubview(collectionViewTitle)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .fitnessLightGrey
        
        collectionView.isScrollEnabled = true
        collectionView.dragInteractionEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        
        collectionView.register(GymFilterCell.self , forCellWithReuseIdentifier: "gymFilterCell")
        contentView.addSubview(collectionView)
        
        //START TIME SLIDER SECTION
        separatorOne = UIView()
        separatorOne.backgroundColor = .fitnessLightGrey
        contentView.addSubview(separatorOne)
        
        startTimeLabel = UILabel()
        startTimeLabel.sizeToFit()
        startTimeLabel.font = ._12LatoBlack
        startTimeLabel.textColor = .fitnessDarkGrey
        startTimeLabel.text = "START TIME"
        contentView.addSubview(startTimeLabel)
        
        startTime = UILabel()
        startTime.sizeToFit()
        startTime.font = ._12LatoBlack
        startTime.textColor = .fitnessDarkGrey
        startTime.text = "6:00 AM - 10:00 PM"
        contentView.addSubview(startTime)
        
        startTimeSlider = UISlider()
        startTimeSlider.maximumTrackTintColor = .fitnessDarkGrey
        startTimeSlider.minimumTrackTintColor = .fitnessYellow
        contentView.addSubview(startTimeSlider)
        
        separatorTwo = UIView()
        separatorTwo.backgroundColor = .fitnessLightGrey
        contentView.addSubview(separatorTwo)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        //COLLECTION VIEW SECTION
        collectionViewTitle.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(collectionViewTitle.snp.top).offset(15)
        }
        
        collectionView.snp.updateConstraints{make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(51)
            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(44)
        }
        
        //SLIDER SECTION
        separatorOne.snp.updateConstraints{make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.bottom.equalTo(collectionView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        startTimeLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(separatorOne.snp.bottom).offset(20)
            make.bottom.equalTo(separatorOne.snp.bottom).offset(35)
        }
        
        startTime.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(separatorOne.snp.bottom).offset(20)
            make.bottom.equalTo(separatorOne.snp.bottom).offset(36)
        }
        
        startTimeSlider.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(separatorOne.snp.bottom).offset(47)
            make.bottom.equalTo(separatorOne.snp.bottom).offset(71)
        }
        
        separatorTwo.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(separatorOne.snp.bottom).offset(90)
            make.bottom.equalTo(separatorOne.snp.bottom).offset(91)
        }
    }
    
    @objc func done(){
        print("done!")
    }

    @objc func reset(){
        print("reset!")
    }
    
    // MARK: - COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gymFilterCell", for: indexPath) as! GymFilterCell
        
        switch indexPath.row {
        case 0:
            cell.gymName.text = "Teagle"
        case 1:
            cell.gymName.text = "Appel"
        case 2:
            cell.gymName.text = "Helen Newman"
        case 3:
            cell.gymName.text = "Noyes"
        default:
            cell.gymName.text = "Gates"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var offset = CGFloat(0)
        if (view.frame.width > 360){
            offset = (view.frame.width - 360)/4
        }
        
        switch indexPath.row {
        case 0:
            return CGSize(width: 74 + offset, height: 28)
        case 1:
            return CGSize(width: 70 + offset, height: 28)
        case 2:
            return CGSize(width: 138 + offset, height: 28)
        case 3:
            return CGSize(width: 72 + offset, height: 28)
        default:
            return CGSize(width: 150 + offset, height: 28)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}
