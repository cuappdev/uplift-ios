//
//  SportsFilterGymCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class SportsFilterGymCollectionViewCell: SportsFilterCollectionViewCell {

    static let height: CGFloat = 107

    private var gymCollectionView: UICollectionView
    private var gyms: [GymNameId] = []
    private var selectedGyms: [GymNameId] = []

    let collectionViewTopBottomOffset: CGFloat = 16
    let cellLabelLeadingTrailingPadding: CGFloat = 16

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        gymCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(frame: frame)

        contentView.backgroundColor = .clear

        titleLabel.text = ClientStrings.Filter.selectGymSection

        gymCollectionView.allowsMultipleSelection = true
        gymCollectionView.backgroundColor = .clear
        gymCollectionView.showsHorizontalScrollIndicator = false
        gymCollectionView.bounces = false
        gymCollectionView.delegate = self
        gymCollectionView.dataSource = self
        gymCollectionView.register(GymFilterCell.self, forCellWithReuseIdentifier: Identifiers.gymFilterCell)
        contentView.addSubview(gymCollectionView)

        gymCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(collectionViewTopBottomOffset)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview()
        }
/*
        NetworkManager.shared.getGymNames(completion: { gyms in
            self.gyms = gyms
            self.gymCollectionView.reloadData()
        })
 */
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getSelectedGyms() -> [GymNameId] {
        return selectedGyms
    }

    func setSelectedGyms(to gyms: [GymNameId]) {
        selectedGyms = gyms
    }

}

extension SportsFilterGymCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gymName = gyms[indexPath.row].name!
        let width = gymName.width(withConstrainedHeight: 1000, font: GymFilterCell.labelFont ?? UIFont.systemFont(ofSize: 12.0)) + 2 * cellLabelLeadingTrailingPadding
        return CGSize(width: width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gym = gyms[indexPath.row]
        if let index = selectedGyms.index(of: gym) {
            selectedGyms.remove(at: index)
        } else {
            selectedGyms.append(gym)
        }
    }

}

extension SportsFilterGymCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gyms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymFilterCell, for: indexPath) as! GymFilterCell
        let showRightDivider = indexPath.row != gyms.count - 1
        cell.configure(for: gyms[indexPath.row], showRightDivider: showRightDivider)
        return cell
    }

}
