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

    private let scrollView = UIScrollView()

    // MARK: - Constraint constants
    private let collectionViewTopOffset = 19
    private let headerCollectionViewTopOffset = 22
    private let headerHeight: CGFloat = 12
    private let headerLeadingOffset = 16
    private let headerTopOffset = 36

    private var collectionViews: [LoadingCollectionView] = []

    init(frame: CGRect, collectionViewTypes: [LoadingCollectionViewType] = LoadingScrollView.defaultLoadingArrangement, collectionViewWidth: CGFloat) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(scrollView)
        
        var prevCollectionView: LoadingCollectionView?
        
        collectionViewTypes.forEach { type in
            let currentCV = LoadingCollectionView(frame: frame, collectionViewType: type, collectionViewWidth: collectionViewWidth)

            let header = LoadingCollectionHeaderView(frame: .zero)
            header.layer.cornerRadius = headerHeight / 2.0
            header.isSkeletonable = true
            header.showAnimatedSkeleton()
            header.layer.masksToBounds = true

            scrollView.addSubview(header)
            scrollView.addSubview(currentCV)
            header.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(headerLeadingOffset)
                make.width.equalTo(currentCV.headerWidth)
                make.height.equalTo(headerHeight)
            }
            currentCV.snp.makeConstraints { make in
                make.top.equalTo(header.snp.bottom).offset(collectionViewTopOffset)
                make.leading.trailing.width.equalToSuperview()
                make.height.equalTo(currentCV.height)
            }
            if let prevView = prevCollectionView {
                header.snp.makeConstraints { make in
                    make.top.equalTo(prevView.snp.bottom).offset(headerTopOffset)
                }
            } else {
                header.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(headerCollectionViewTopOffset)
                }
            }
            prevCollectionView = currentCV
            collectionViews.append(currentCV)
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
        }
    }
    
    func reloadCollectionViews() {
        collectionViews.forEach { collectionView in
            collectionView.reloadData()
        }
    }

}
