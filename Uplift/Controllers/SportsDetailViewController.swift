//
//  SportsDetailViewController.swift
//  Uplift
//
//  Created by Artesia Ko on 3/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailViewController: UIViewController {
     
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())
    
    private var post: Post!
    private var section: Section!
    
    private struct Section {
        var items: [ItemType]
    }
    
    private enum ItemType {
        case detail
        case players([String])
        case discussion([Comment])
    }
    
    private let sportsDetailHeaderViewReuseIdentifier = "sportsDetailHeaderViewReuseIdentifier"
    private let detailSectionReuseIdentifier = "detailSectionReuseIdentifier"
    private let discussionSectionReuseIdentifier = "discussionSectionReuseIdentifier"
    private let playersSectionReuseIdentifier = "playersSectionReuseIdentifier"
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
        section = Section(items: [.detail, .players([]), .discussion(post.comment)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatesStatusBarAppearanceAutomatically = true
        view.backgroundColor = .white
        
        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        // TODO: Register cells.
        collectionView.register(SportsDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sportsDetailHeaderViewReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: detailSectionReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: discussionSectionReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: playersSectionReuseIdentifier)
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

extension SportsDetailViewController: SportsDetailHeaderViewDelegate {
    func sportsDetailHeaderViewBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension SportsDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: sportsDetailHeaderViewReuseIdentifier,
            for: indexPath) as! SportsDetailHeaderView
        headerView.configure(for: self, for: post)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = section.items[indexPath.item]
        switch itemType {
        case .detail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailSectionReuseIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .players:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playersSectionReuseIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        case .discussion:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: discussionSectionReuseIdentifier, for: indexPath) as! UICollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 264)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemType = section.items[indexPath.item]
        let width = collectionView.frame.width

        switch itemType {
        case .detail:
            return CGSize(width: width, height: 157)
        case .players:
            return CGSize(width: width, height: 110)
        case .discussion:
            return CGSize(width: width, height: 200)
        }
    }
}
