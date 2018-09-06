//
//  LookingForCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage

class LookingForCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - INITIALIZATION
    var collectionView: UICollectionView!
    var tags: [Tag] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 15, right: 16 )
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white

        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")

        contentView.addSubview(collectionView)

        collectionView.snp.updateConstraints {make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell

        Alamofire.request(tags[indexPath.row].imageURL).responseImage { response in
            if let image = response.result.value {
                cell.image.image = image
            }
        }

        cell.title.text = tags[indexPath.row].name.capitalized
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 47)/2, height: 128)
    }
}
