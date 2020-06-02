//
//  SportsFilterGymCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFilterGymCollectionViewCell: SportsFilterCollectionViewCell {

    static let height: CGFloat = 107

    private var gymCollectionView: UICollectionView
    private var gyms: [GymNameId] = []

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        gymCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(frame: frame)

        gymCollectionView.allowsMultipleSelection = true
        gymCollectionView.backgroundColor = .gray01
        gymCollectionView.isScrollEnabled = true
        gymCollectionView.showsHorizontalScrollIndicator = false
        gymCollectionView.bounces = false
        gymCollectionView.delegate = self
        gymCollectionView.dataSource = self
        gymCollectionView.register(GymFilterCell.self, forCellWithReuseIdentifier: Identifiers.gymFilterCell)
        contentView.addSubview(gymCollectionView)

        NetworkManager.shared.getGymNames(completion: { gyms in
            self.gyms = gyms
            self.gymCollectionView.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SportsFilterGymCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gymName = gyms[indexPath.row].name!
        let width = gymName.width(withConstrainedHeight: 100, font: GymFilterCell.labelFont ?? UIFont.systemFont(ofSize: 12.0))
        return CGSize(width: width, height: 28)
    }

}

extension SportsFilterGymCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gyms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymFilterCell, for: indexPath) as! GymFilterCell
        cell.configure(for: gyms[indexPath.row])
        return cell
    }

}
