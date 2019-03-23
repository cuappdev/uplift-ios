//
//  LookingForCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import Alamofire
import AlamofireImage
import UIKit

class LookingForCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.lookingForCell
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 15, right: 16 )
        layout.itemSize = CGSize(width: 228.0, height: 100.0)
        layout.minimumInteritemSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white

        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)

        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
