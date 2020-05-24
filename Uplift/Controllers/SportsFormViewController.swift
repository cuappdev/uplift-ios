//
//  SportsFormViewController.swift
//  Uplift
//
//  Created by Artesia Ko on 5/23/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFormViewController: UIViewController {
     
    private var collectionView: UICollectionView!
    
    private struct Section {
        var items: [ItemType]
    }
    
    private enum ItemType {
        case name
        case time
        case sport([String])
        case location([String])
        case players
    }
    
    private var sportsDropStatus: DropdownStatus = .closed
    private var locationDropStatus: DropdownStatus = .closed
    private var section: Section!
    
    private var locations: [String]!
    private var sports: [String]!
    
    private let sportsFormNameIdentifier = "sportsFormNameIdentifier"
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // TODO: Load in sports and locations from backend.
        sports = ["Badminton", "Baseball", "Flag Football", "Squash", "Tennis", "Other"]
        locations = ["Helen Newman", "Libe Slope", "Noyes"]
        section = Section(items: [.name, .time, .sport(sports), .location(locations), .players])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatesStatusBarAppearanceAutomatically = true
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        title = "Create a Game"
//        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: sportsFormNameIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SportsFormViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = section.items[indexPath.item]
        switch itemType {
        case .name:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormNameIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .time:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormNameIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .sport(let s):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormNameIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .location(let l):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormNameIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .players:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormNameIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemType = section.items[indexPath.item]
        let width = collectionView.frame.width

        switch itemType {
        case .name:
            return CGSize(width: width, height: 64)
        case .time:
            return CGSize(width: width, height: 72)
        case .sport(let s):
            return getDropdownListSize(list: s)
        case .location(let l):
            return getDropdownListSize(list: l)
        case .players:
            return CGSize(width: width, height: 156)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemType = section.items[indexPath.item]
        switch itemType {
            case .sport:
                sportsDropStatus = sportsDropStatus == .closed ? .open : .closed
            case .location:
                sportsDropStatus = sportsDropStatus == .closed ? .open : .closed
            default:
                return
        }
        collectionView.reloadData()
    }
}

extension SportsFormViewController {
    
    // Functions to calculate cell size.
    func getDropdownListSize(list: [String]) -> CGSize {
        let width = collectionView.frame.width
        let cellHeight = 30
        let headerHeight = 45
        let footerPadding = 18
        
        let height: CGFloat = CGFloat(headerHeight + footerPadding + cellHeight * list.count)
        return CGSize(width: width, height: height)
    }
    
}

