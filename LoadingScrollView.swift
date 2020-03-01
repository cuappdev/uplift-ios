//
//  LoadingScrollView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class LoadingScrollView: UIView {
    
    static let defaultLoadingArrangement: [LoadingCollectionViewType] = [.smallGrid, .horizontallyScrolling, .largeGrid]

    let scrollView = UIScrollView()

    var collectionViews: [LoadingCollectionView] = []

    init(frame: CGRect, collectionViewTypes: [LoadingCollectionViewType] = LoadingScrollView.defaultLoadingArrangement, collectionViewWidth: CGFloat) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(scrollView)
        
        var prevCollectionView: LoadingCollectionView?
        
        collectionViewTypes.forEach { type in
            let newCV = LoadingCollectionView(frame: frame, collectionViewType: type, collectionViewWidth: collectionViewWidth)

            let header = LoadingCollectionHeaderView(frame: .zero)
            header.layer.cornerRadius = 12 / 2.0
            header.isSkeletonable = true
            header.showAnimatedSkeleton()
            header.layer.masksToBounds = true

            scrollView.addSubview(header)
            scrollView.addSubview(newCV)
            header.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.width.equalTo(newCV.headerWidth)
                make.height.equalTo(12)
            }
            newCV.snp.makeConstraints { make in
                make.top.equalTo(header.snp.bottom).offset(19)
                make.leading.trailing.width.equalToSuperview()
                make.height.equalTo(newCV.height)
            }
            if let prevView = prevCollectionView {
                header.snp.makeConstraints { make in
                    make.top.equalTo(prevView.snp.bottom).offset(36)
                }
            } else {
                header.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(22)
                }
            }
            prevCollectionView = newCV
            collectionViews.append(newCV)
        }
        
        if let prevView = prevCollectionView {
            prevView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func reloadCollectionViews() {
        collectionViews.forEach { collectionView in
            collectionView.reloadData()
        }
    }

}
