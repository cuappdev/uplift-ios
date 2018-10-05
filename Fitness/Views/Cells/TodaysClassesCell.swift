//
//  TodaysClassesCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class TodaysClassesCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.todaysClassesCell
    var collectionView: UICollectionView!
    var gymClassInstances: [GymClassInstance] = [] {
        didSet {
            gymClassInstances = gymClassInstances.filter {
                Date() < $0.startTime
            }
            gymClassInstances.sort {
                $0.startTime < $1.startTime
            }

            collectionView.reloadData()
        }
    }

    var gymLocations: [Int: String] = [:] {
        didSet {
            collectionView.reloadData()
        }
    }

    var navigationController: UINavigationController?

    override init(frame: CGRect) {
        super.init(frame: frame)

        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16 )
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 228.0, height: 195.0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(ClassesCell.self, forCellWithReuseIdentifier: ClassesCell.identifier)
        collectionView.register(ClassesCell.self, forCellWithReuseIdentifier: ClassesCell.cancelledIdentifier)

        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints {make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
