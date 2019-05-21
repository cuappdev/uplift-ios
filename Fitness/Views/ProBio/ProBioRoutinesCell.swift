//
//  ProBioRoutinesCell.swift
//  Fitness
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ProBioRoutinesCellDelegate: class {
    func pushHabitAddedAlert(habitTitle: String)
}

class ProBioRoutinesCell: UICollectionViewCell {

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
        collectionView.reloadData()
    }

    // MARK: - Private helpers
    private func setupViews() {

        routinesLabel.font = ._16MontserratMedium
        routinesLabel.text = "SUGGESTED ROUTINES"
        routinesLabel.textAlignment = .center
        routinesLabel.textColor = .lightBlack
        routinesLabel.sizeToFit()
        contentView.addSubview(routinesLabel)

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: contentView.bounds.width - 38.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 16.0
        classFlowLayout.headerReferenceSize = .zero

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        collectionView.isScrollEnabled = false
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
        let collectionViewBottomPadding = 61
        let collectionViewTopPadding = 16
        let collectionViewWidth = 327
        let routinesLabelHeight = 20
        let routinesLabelTopPadding = 24

        routinesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(routinesLabelTopPadding)
            make.height.equalTo(routinesLabelHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(routinesLabel.snp.bottom).offset(collectionViewTopPadding)
            make.width.equalTo(collectionViewWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(collectionViewBottomPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProBioRoutinesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProRoutineCollectionViewCell.identifier, for: indexPath) as! ProRoutineCollectionViewCell
        cell.configure(for: self, for: routines[indexPath.row])
//        cell.configure(for: routines[indexPath.row])
        return cell
    }
}

extension ProBioRoutinesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 327

        let cellPadding = 16
        let routineTypeLabelHeight = 15
        let routineTypeTopPadding = 3
        let titleLabelHeight = 20

        let descriptionTextViewWidth = CGFloat(width - 2 * cellPadding)
        let descriptionTextViewHeight = routines[indexPath.row].text.height(withConstrainedWidth: descriptionTextViewWidth, font: UIFont._14MontserratLight!)
        let height = CGFloat(cellPadding + titleLabelHeight + routineTypeTopPadding + routineTypeLabelHeight + cellPadding + cellPadding) + descriptionTextViewHeight
        return CGSize(width: CGFloat(width), height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ProBioRoutinesCell: ProRoutineCellDelegate {

    func pushHabitAddedAlert(habitTitle: String) {
        if let delegate = delegate {
            delegate.pushHabitAddedAlert(habitTitle: habitTitle)
        }
    }

}
