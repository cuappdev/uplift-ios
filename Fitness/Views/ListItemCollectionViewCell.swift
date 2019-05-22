//
//  ListItemCollectionViewCell.swift
//  Fitness
//
//  Created by Kevin Chan on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol Configurable: class {

    associatedtype ItemType

    func configure(for item: ItemType)

}

class ListItemCollectionViewCell<T>: UICollectionViewCell, Configurable {

    typealias ItemType = T

    func configure(for item: ItemType) {}

}
