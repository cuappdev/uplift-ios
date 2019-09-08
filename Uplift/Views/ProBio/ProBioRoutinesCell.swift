//
//  ProBioRoutinesCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ProBioRoutinesCellDelegate: class {
    func pushHabitAddedAlert(habitTitle: String)
}

class ProBioRoutinesCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let collectionViewBottomPadding: CGFloat = 61
        static let routinesLabelHeight: CGFloat = 20
        static let routinesLabelTopPadding: CGFloat = 24
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constants.routinesLabelTopPadding + Constants.routinesLabelHeight + Constants.collectionViewBottomPadding
    }

    // MARK: - Private view vars
    private let routinesLabel = UILabel()
    private var collectionView: UICollectionView!

    // MARK: - Private data vars
    private weak var delegate: ProBioRoutinesCellDelegate?
    private var routines: [ProRoutine] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ProBioRoutinesCellDelegate, for pro: ProBio) {
        self.delegate = delegate
        self.routines = pro.routines
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        routinesLabel.font = ._16MontserratMedium
        routinesLabel.text = "SUGGESTED ROUTINES"
        routinesLabel.textAlignment = .center
        routinesLabel.textColor = .lightBlack
        contentView.addSubview(routinesLabel)

        let routineFlowLayout = UICollectionViewFlowLayout()
        routineFlowLayout.itemSize = CGSize(width: contentView.bounds.width - 38.0, height: 100.0)
        routineFlowLayout.minimumLineSpacing = 16.0
        routineFlowLayout.headerReferenceSize = .zero

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: routineFlowLayout)
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false
        collectionView.delaysContentTouches = false
        collectionView.register(ProRoutineCollectionViewCell.self, forCellWithReuseIdentifier: ProRoutineCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
    }

    private func setupConstraints() {
        let collectionViewTopPadding = 16
        let collectionViewWidth = 327

        routinesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.routinesLabelTopPadding)
            make.height.equalTo(Constants.routinesLabelHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(routinesLabel.snp.bottom).offset(collectionViewTopPadding)
            make.width.equalTo(collectionViewWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.collectionViewBottomPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProBioRoutinesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProRoutineCollectionViewCell.identifier, for: indexPath) as! ProRoutineCollectionViewCell
        cell.configure(for: self, for: routines[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 327
        let cellPadding = 16

        let descriptionTextViewWidth = CGFloat(cellWidth - 2 * cellPadding)
        let descriptionTextViewHeight = routines[indexPath.row].text.height(withConstrainedWidth: descriptionTextViewWidth, font: UIFont._14MontserratLight!)
        let height = ProRoutineCollectionViewCell.baseHeight + descriptionTextViewHeight
        return CGSize(width: CGFloat(cellWidth), height: height)
    }
}

extension ProBioRoutinesCell: ProRoutineCellDelegate {

    func pushHabitAddedAlert(habitTitle: String) {
        if let delegate = delegate {
            delegate.pushHabitAddedAlert(habitTitle: habitTitle)
        }
    }

}
