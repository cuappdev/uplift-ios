//
//  ProBioLinksCell.swift
//  Fitness
//
//  Created by Yana Sang on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioLinksCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let collectionViewBottomPadding: CGFloat = 57
        static let collectionViewCellSize: CGFloat = 24
        static let collectionViewTopPadding: CGFloat = 12
        static let linksTitleLabelHeight: CGFloat = 18
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constants.linksTitleLabelHeight + Constants.collectionViewTopPadding + Constants.collectionViewCellSize + Constants.collectionViewBottomPadding
    }

    // MARK: - Private view vars
    private var linksCollectionView: UICollectionView!
    private let linksTitleLabel = UILabel()

    // MARK: - Private data vars
    private var links: [PersonalLink] = []
    private let linksInterItemSpacing = 6

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for pro: ProBio) {
        self.links = pro.links
        DispatchQueue.main.async {
            self.updateCollectionViewConstraints()
            self.linksCollectionView.reloadData()
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        linksTitleLabel.text = "FOLLOW ME"
        linksTitleLabel.font = ._12MontserratBold
        linksTitleLabel.textColor = .fitnessBlack
        linksTitleLabel.textAlignment = .center
        linksTitleLabel.sizeToFit()
        contentView.addSubview(linksTitleLabel)

        let linksFlowLayout = UICollectionViewFlowLayout()
        linksFlowLayout.minimumInteritemSpacing = CGFloat(linksInterItemSpacing)
        linksFlowLayout.minimumLineSpacing = 0
        linksFlowLayout.headerReferenceSize = .zero

        linksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: linksFlowLayout)
        linksCollectionView.isScrollEnabled = false
        linksCollectionView.bounces = false
        linksCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        linksCollectionView.showsVerticalScrollIndicator = false
        linksCollectionView.showsHorizontalScrollIndicator = false
        linksCollectionView.backgroundColor = .white
        linksCollectionView.clipsToBounds = false
        linksCollectionView.delaysContentTouches = false
        linksCollectionView.register(PersonalLinkCollectionViewCell.self, forCellWithReuseIdentifier: PersonalLinkCollectionViewCell.identifier)
        linksCollectionView.dataSource = self
        linksCollectionView.delegate = self
        contentView.addSubview(linksCollectionView)
    }

    private func setupConstraints() {
        linksTitleLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(Constants.linksTitleLabelHeight)
        }

        linksCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(linksTitleLabel.snp.bottom).offset(Constants.collectionViewTopPadding)
            make.height.equalTo(Constants.collectionViewCellSize)
            let linksWidth = Int(Constants.collectionViewCellSize) * links.count + (links.count - 1) * linksInterItemSpacing
            let width = linksWidth < 0 ? 0 : linksWidth
            make.width.equalTo(width)
        }
    }

    private func updateCollectionViewConstraints() {
        linksCollectionView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(linksTitleLabel.snp.bottom).offset(Constants.collectionViewTopPadding)
            make.height.equalTo(Constants.collectionViewCellSize)
            let linksWidth = Int(Constants.collectionViewCellSize) * links.count + (links.count - 1) * linksInterItemSpacing
            let width = linksWidth < 0 ? 0 : linksWidth
            make.width.equalTo(width)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension ProBioLinksCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalLinkCollectionViewCell.identifier, for: indexPath) as! PersonalLinkCollectionViewCell
        cell.configure(for: links[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = links[indexPath.row].url {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension ProBioLinksCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 24, height: 24)
    }
}
