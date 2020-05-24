//
//  SportsFormViewController.swift
//  Uplift
//
//  Created by Artesia Ko on 5/23/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

protocol SportsFormBubbleListDelegate: class {
    func didTapDropdownHeader(identifier: String)
}

class SportsFormViewController: UIViewController {
     
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private var headerLabel = UILabel()
    private var headerRect = UIView()
    
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
    private let sportsFormTimeIdentifier = "sportsFormTimeIdentifier"
    private let sportsFormSportIdentifier = "sportsFormSportIdentifier"
    private let sportsFormLocationIdentifier = "sportsFormLocationIdentifier"
    private let sportsFormPlayersIdentifier = "sportsFormPlayersIdentifier"
    
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
    
    @objc func create() {
        // TODO: backend request - POST
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        
        headerRect.backgroundColor = .gray01
        view.addSubview(headerRect)
        
        headerLabel.font = ._14MontserratBold
        headerLabel.textColor = .primaryBlack
        headerLabel.text = "Create a Game"
        view.addSubview(headerLabel)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = ._14MontserratMedium
        cancelButton.setTitleColor(.primaryBlack, for: .normal)
        cancelButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        createButton.setTitle("Create", for: .normal)
        createButton.titleLabel?.font = ._14MontserratMedium
        createButton.setTitleColor(.primaryBlack, for: .normal)
        createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        view.addSubview(createButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SportsFormNameCollectionViewCell.self, forCellWithReuseIdentifier: sportsFormNameIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: sportsFormTimeIdentifier)
        collectionView.register(SportsFormBubbleCollectionViewCell.self, forCellWithReuseIdentifier: sportsFormSportIdentifier)
        collectionView.register(SportsFormBubbleCollectionViewCell.self, forCellWithReuseIdentifier: sportsFormLocationIdentifier)
        collectionView.register(SportsFormPlayersCollectionViewCell.self, forCellWithReuseIdentifier: sportsFormPlayersIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        let headerHeight = 80
        let headerContentVerticalOffset = 46
        let horizontalOffset = 16
        let buttonHeight = 18
        let buttonWidth = 50
        
        headerRect.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerRect).offset(headerContentVerticalOffset)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(headerLabel)
            make.leading.equalToSuperview().inset(horizontalOffset)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(buttonWidth)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(headerLabel)
            make.trailing.equalToSuperview().inset(horizontalOffset)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(buttonWidth)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerRect.snp.bottom)
            make.leading.trailing.equalToSuperview()
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormNameIdentifier, for: indexPath) as! SportsFormNameCollectionViewCell
            return cell
        case .time:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormTimeIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .sport(let s):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormSportIdentifier, for: indexPath) as! SportsFormBubbleCollectionViewCell
            cell.configure(for: "SPORT", list: s, dropdownStatus: sportsDropStatus, identifier: sportsFormSportIdentifier)
            cell.delegate = self
            return cell
        case .location(let l):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormLocationIdentifier, for: indexPath) as! SportsFormBubbleCollectionViewCell
            cell.configure(for: "LOCATION", list: l, dropdownStatus: locationDropStatus, identifier: sportsFormLocationIdentifier)
            cell.delegate = self
            return cell
        case .players:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsFormPlayersIdentifier, for: indexPath) as! SportsFormPlayersCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemType = section.items[indexPath.item]
        let width = collectionView.frame.width
        let dropdownHeaderHeight: CGFloat = 55

        switch itemType {
        case .name:
            return CGSize(width: width, height: 64)
        case .time:
            return CGSize(width: width, height: 72)
        case .sport(let s):
            return sportsDropStatus == .open ? getDropdownListSize(list: s) : CGSize(width: width, height: dropdownHeaderHeight)
        case .location(let l):
            return locationDropStatus == .open ? getDropdownListSize(list: l) : CGSize(width: width, height: dropdownHeaderHeight)
        case .players:
            return CGSize(width: width, height: 156)
        }
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

extension SportsFormViewController: SportsFormBubbleListDelegate {
    
    func didTapDropdownHeader(identifier: String) {
        if identifier == sportsFormSportIdentifier {
            sportsDropStatus = sportsDropStatus == .closed ? .open : .closed
        } else if identifier == sportsFormLocationIdentifier {
            locationDropStatus = locationDropStatus == .closed ? .open : .closed
        }
        collectionView.reloadData()
    }
    
}

