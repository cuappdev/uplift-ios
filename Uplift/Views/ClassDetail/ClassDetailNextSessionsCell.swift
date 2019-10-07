//
//  ClassDetailNextSessionsCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ClassDetailNextSessionsCellDelegate: class {
    func didSelectNextSession(_ nextSession: GymClassInstance)
    func toggleFavorite()
}

class ClassDetailNextSessionsCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let collectionViewBottomPadding: CGFloat = 12
        static let collectionViewTopPadding: CGFloat = 32
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constraints.verticalPadding + Constraints.titleLabelHeight + Constants.collectionViewTopPadding + Constants.collectionViewBottomPadding
    }

    // MARK: - Private view vars
    private let nextSessionsLabel = UILabel()
    private var collectionView: UICollectionView!

    // MARK: - Private data vars
    private var isFavorite: Bool!
    private var nextSessions: [GymClassInstance] = []
    private weak var delegate: ClassDetailNextSessionsCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ClassDetailNextSessionsCellDelegate, nextSessions: [GymClassInstance]) {
        self.delegate = delegate
        self.nextSessions = nextSessions
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        collectionView.reloadData()
    }

    // MARK: - Private helpers
    private func setupViews() {
        nextSessionsLabel.font = ._16MontserratBold
        nextSessionsLabel.textColor = .fitnessLightBlack
        nextSessionsLabel.text = ClientStrings.ClassDetail.nextSessionsLabel
        nextSessionsLabel.textAlignment = .center
        nextSessionsLabel.sizeToFit()
        contentView.addSubview(nextSessionsLabel)

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: contentView.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .zero

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false
        collectionView.delaysContentTouches = false
        collectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
    }

    private func setupConstraints() {
        nextSessionsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constraints.verticalPadding)
            make.height.equalTo(Constraints.titleLabelHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nextSessionsLabel.snp.bottom).offset(Constants.collectionViewTopPadding)
            make.bottom.equalToSuperview().offset(-Constants.collectionViewBottomPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension ClassDetailNextSessionsCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nextSessions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        cell.configure(gymClassInstance: nextSessions[indexPath.item], style: .date)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSession = nextSessions[indexPath.item]
        delegate?.didSelectNextSession(selectedSession)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.transform = .identity
        }, completion: nil)
    }

}

extension ClassDetailNextSessionsCell: ClassListCellDelegate {

    func toggleFavorite(classDetailId: String) {
        delegate?.toggleFavorite()
    }

}
