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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16 )
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GymFilterCell.self , forCellWithReuseIdentifier: "gymFilterCell")
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .yellow
        
        setupConstraints()
    }
    
    func setupConstraints() {
        collectionViewTitle.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        collectionView.snp.updateConstraints{make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(51)
            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(60)
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
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}
