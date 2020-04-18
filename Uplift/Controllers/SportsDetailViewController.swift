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
    
    private let detailSectionReuseIdentifier = "detailSectionReuseIdentifier"
    private let discussionSectionReuseIdentifier = "discussionSectionReuseIdentifier"
    private let playersSectionReuseIdentifier = "playersSectionReuseIdentifier"
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        collectionView.backgroundColor = .white
        section = Section(items: [.detail, .players(["Zain Khoja", "Will Bai", "Amanda He"]), .discussion(post.comment)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)
        
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SportsDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.items.count
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
}
