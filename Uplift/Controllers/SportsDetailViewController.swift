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
    
    private struct Section {
        var items: [ItemType]
    }
    
    private enum ItemType {
        case info
        case players([String])
        case discussion
        case comment(Comment)
        case input
    }
    
    private var dropStatus: DropdownStatus = .closed
    private var post: Post = Post(comment: [], createdAt: Date(), id: -1, userId: -1, title: "", time: Date(), type: "", location: "", players: [], gameStatus: GameStatus.open.rawValue)
    private var section: Section = Section(items: [.info, .players([]), .discussion])

    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
        let playerNames = post.players.map { user -> String in
            if let familyName = user.familyName, let givenName = user.givenName {
                return "\(givenName) \(familyName.prefix(1))."
            } else {
                return user.name
            }
        }
        var items: [ItemType] = [.info, .players(playerNames), .discussion]
        items.append(contentsOf: post.comment.map { c -> ItemType in
            return .comment(c)
        })
        items.append(.input)
        section = Section(items: items)
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
        collectionView.register(SportsDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.sportsDetailHeaderView)
        collectionView.register(SportsDetailInfoCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsDetailInfoCell)
        collectionView.register(SportsDetailPlayersCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsDetailPlayersCell)
        collectionView.register(SportsDetailDiscussionCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsDetailDiscussionCell)
        collectionView.register(SportsDetailCommentCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsDetailCommentCell)
        collectionView.register(SportsDetailInputCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsDetailInputCell)
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
            withReuseIdentifier: Identifiers.sportsDetailHeaderView,
            for: indexPath) as! SportsDetailHeaderView
        headerView.configure(delegate: self, post: post)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = section.items[indexPath.item]
        switch itemType {
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsDetailInfoCell, for: indexPath) as! SportsDetailInfoCollectionViewCell
            cell.configure(for: post)
            return cell
        case .players:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsDetailPlayersCell, for: indexPath) as! SportsDetailPlayersCollectionViewCell
            cell.configure(for: post, dropStatus: dropStatus)
            return cell
        case .discussion:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsDetailDiscussionCell, for: indexPath) as! SportsDetailDiscussionCollectionViewCell
            cell.configure(for: post)
            return cell
        case .comment(let c):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsDetailCommentCell, for: indexPath) as! SportsDetailCommentCollectionViewCell
            cell.configure(for: c)
            return cell
        case .input:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsDetailInputCell, for: indexPath) as! SportsDetailInputCollectionViewCell
            // TODO: Get current user.
            cell.configure(for: User(id: -1, name: "", netId: ""))
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
        case .info:
            return CGSize(width: width, height: 157)
        case .players:
            return getPlayersCellSize()
        case .discussion:
            return CGSize(width: width, height: 64)
        case .comment(let comment):
            return getCommentCellSize(comment: comment)
        case .input:
            return CGSize(width: width, height: 48)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemType = section.items[indexPath.item]
        switch itemType {
            case .players:
                dropStatus = dropStatus == .closed ? .open : .closed
            default:
                return
        }
        collectionView.reloadData()
    }
}

extension SportsDetailViewController {
    
    // Functions to calculate cell size.
    func getCommentCellSize(comment: Comment) -> CGSize {
        let width = collectionView.frame.width
        let constraints = SportsDetailCommentCollectionViewCell.Constraints.self
        
        let baseHeight = CGFloat(constraints.nameLabelHeight + constraints.textVerticalPadding + constraints.bubbleViewVerticalPadding) * 2.0
        let contentPadding = constraints.imageSize + constraints.imagebubbleViewHorizontalPadding + constraints.textHorizontalPadding * 2
        let constrainedWidth = width - CGFloat(constraints.leadingPadding + contentPadding + constraints.trailingPadding)
        let height = baseHeight + comment.text.height(withConstrainedWidth: constrainedWidth, font: UIFont._12MontserratLight ?? UIFont.systemFont(ofSize: 12))
        
        return CGSize(width: width, height: height)
    }
    
    func getPlayersCellSize() -> CGSize {
        let constraints = SportsDetailPlayersCollectionViewCell.Constraints.self
        let width = collectionView.frame.width
        
        let baseHeight = CGFloat(constraints.verticalPadding) * 2.0 + CGFloat(constraints.headerLabelHeight + constraints.headerPlayersVerticalPadding)
        let constrainedWidth = width - CGFloat(constraints.horizontalPadding) * 2.0
        let listHeight = baseHeight + post.getPlayersListString().height(withConstrainedWidth: constrainedWidth, font: UIFont._14MontserratLight ?? UIFont.systemFont(ofSize: 14))
        let previewHeight = baseHeight + 14
        let height = dropStatus == .closed ? previewHeight : listHeight
        
        return CGSize(width: width, height: height)
        
    }
    
}
