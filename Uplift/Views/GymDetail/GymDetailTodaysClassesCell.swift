//
//  GymDetailTodaysClassesCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol GymDetailTodaysClassesCellDelegate: class {
    func didSelectClassSession(_ session: GymClassInstance)
}

class GymDetailTodaysClassesCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let classesCollectionViewVerticalPadding: CGFloat = 34
        static let noMoreClassesLabelHeight: CGFloat = 66
        static let noMoreClassesLabelTopPadding: CGFloat = 22
    }

    // MARK: - Private view vars
    private var classesCollectionView: UICollectionView!
    private let noMoreClassesLabel = UILabel()
    private let todaysClassesLabel = UILabel()

    // MARK: - Private data vars
    private weak var delegate: GymDetailTodaysClassesCellDelegate?
    private var isFavorite: Bool!
    private var todaysClasses: [GymClassInstance] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: GymDetailTodaysClassesCellDelegate, classes: [GymClassInstance]) {
        self.delegate = delegate
        self.todaysClasses = classes

        DispatchQueue.main.async {
            self.classesCollectionView.reloadData()
            self.remakeConstraints()
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        todaysClassesLabel.font = ._16MontserratBold
        todaysClassesLabel.textColor = .primaryBlack
        todaysClassesLabel.text = ClientStrings.GymDetail.todaysClassesSection
        todaysClassesLabel.textAlignment = .center
        contentView.addSubview(todaysClassesLabel)

        noMoreClassesLabel.font = UIFont._14MontserratLight
        noMoreClassesLabel.textColor = .primaryBlack
        noMoreClassesLabel.text = ClientStrings.GymDetail.noMoreClasses
        noMoreClassesLabel.numberOfLines = 0
        noMoreClassesLabel.textAlignment = .center

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: contentView.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .zero

        classesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classesCollectionView.isScrollEnabled = false
        classesCollectionView.bounces = false
        classesCollectionView.showsVerticalScrollIndicator = false
        classesCollectionView.showsHorizontalScrollIndicator = false
        classesCollectionView.backgroundColor = .white
        classesCollectionView.clipsToBounds = false
        classesCollectionView.delaysContentTouches = false
        classesCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        classesCollectionView.dataSource = self
        classesCollectionView.delegate = self
    }

    private func setupConstraints() {
        todaysClassesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constraints.verticalPadding)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constraints.titleLabelHeight)
        }
    }

    private func remakeConstraints() {
        if todaysClasses.isEmpty {
            classesCollectionView.removeFromSuperview()
            contentView.addSubview(noMoreClassesLabel)

            noMoreClassesLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(todaysClassesLabel.snp.bottom).offset(Constants.noMoreClassesLabelTopPadding)
                make.height.equalTo(Constants.noMoreClassesLabelHeight)
            }
        } else {
            let classesCollectionViewHorizontalPadding = 16.0

            noMoreClassesLabel.removeFromSuperview()
            contentView.addSubview(classesCollectionView)

            classesCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(todaysClassesLabel.snp.bottom).offset(Constraints.verticalPadding)
                make.bottom.equalToSuperview().inset(Constants.classesCollectionViewVerticalPadding)
                make.left.right.equalToSuperview().inset(classesCollectionViewHorizontalPadding)
                make.centerX.equalToSuperview()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension GymDetailTodaysClassesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todaysClasses.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        cell.configure(gymClassInstance: todaysClasses[indexPath.item], style: .date)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSession = todaysClasses[indexPath.item]
        delegate?.didSelectClassSession(selectedSession)
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
