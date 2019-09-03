//
//  GymDetailTodaysClassesCell.swift
//  Fitness
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
        static let classesCollectionViewItemHeight = 112
        static let classesCollectionViewTopPadding = 32
        static let noMoreClassesLabelBottomPadding = 57
        static let noMoreClassesLabelHeight = 66
        static let todaysClassesLabelHeight = 18
        static let todaysClassesLabelTopPadding = 64
    }

    // MARK: - Private view vars
    private var classesCollectionView: UICollectionView!
    private weak var delegate: GymDetailTodaysClassesCellDelegate?
    private let noMoreClassesLabel = UILabel()
    private let todaysClassesLabel = UILabel()

    // MARK: - Private data vars
    private var isFavorite: Bool!
    private var todaysClasses: [GymClassInstance] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        todaysClassesLabel.font = ._14MontserratSemiBold
        todaysClassesLabel.textColor = .fitnessDarkGrey
        todaysClassesLabel.text = "TODAY'S CLASSES"
        todaysClassesLabel.textAlignment = .center
        contentView.addSubview(todaysClassesLabel)

        noMoreClassesLabel.font = UIFont._14MontserratLight
        noMoreClassesLabel.textColor = .fitnessLightBlack
        noMoreClassesLabel.text = "We are done for today. \nCheck again tomorrow!\n🌟"
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
        contentView.addSubview(classesCollectionView)
    }

    private func setupConstraints() {
        todaysClassesLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(Constants.todaysClassesLabelHeight)
        }

        classesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(todaysClassesLabel.snp.bottom).offset(Constants.classesCollectionViewTopPadding)
            make.height.equalTo(classesCollectionView.numberOfItems(inSection: 0) * Constants.classesCollectionViewItemHeight)
        }

        if todaysClasses.isEmpty {
            noMoreClassesLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(Constants.noMoreClassesLabelBottomPadding)
                make.height.equalTo(Constants.noMoreClassesLabelHeight)
            }
        } else {
            noMoreClassesLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(Constants.noMoreClassesLabelBottomPadding)
                make.height.equalTo(0)
            }
        }
    }

    private func remakeConstraints() {
        classesCollectionView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(todaysClassesLabel.snp.bottom).offset(Constants.classesCollectionViewTopPadding)
            make.height.equalTo(classesCollectionView.numberOfItems(inSection: 0) * Constants.classesCollectionViewItemHeight)
        }

        if todaysClasses.isEmpty {
            noMoreClassesLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(Constants.noMoreClassesLabelBottomPadding)
                make.height.equalTo(Constants.noMoreClassesLabelHeight)
            }
        } else {
            noMoreClassesLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(Constants.noMoreClassesLabelBottomPadding)
                make.height.equalTo(0)
            }
        }
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
