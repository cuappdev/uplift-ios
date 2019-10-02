//
//  ClassDetailHeaderView.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ClassDetailHeaderViewDelegate: class {
    func classDetailHeaderViewLocationSelected()
    func classDetailHeaderViewInstructorSelected()
}

class ClassDetailHeaderView: UICollectionReusableView {

    // MARK: - Private view vars
    private let imageView = UIImageView()
    private let imageFilterView = UIView()
    private let semicircleImageView = UIImageView(image: #imageLiteral(resourceName: "semicircle"))
    private let titleLabel = UILabel()
    private let locationButton = UIButton()
    private let instructorButton = UIButton()
    private let durationLabel = UILabel()

    // MARK: - Private data vars
    private weak var delegate: ClassDetailHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ClassDetailHeaderViewDelegate, gymClassInstance: GymClassInstance) {
        self.delegate = delegate
        imageView.kf.setImage(with: gymClassInstance.imageURL)
        titleLabel.text = gymClassInstance.className.uppercased()
        locationButton.setTitle(gymClassInstance.location, for: .normal)
        instructorButton.setTitle(gymClassInstance.instructor.uppercased(), for: .normal)
        durationLabel.text = String(Int(gymClassInstance.duration) / 60) + ClientStrings.ClassDetail.durationMin
    }

    // MARK: - Targets
    @objc func locationSelected() {
        delegate?.classDetailHeaderViewLocationSelected()
    }

    @objc func instructorSelected() {
        delegate?.classDetailHeaderViewInstructorSelected()
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        addSubview(imageFilterView)

        semicircleImageView.contentMode = UIView.ContentMode.scaleAspectFit
        semicircleImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(semicircleImageView)

        titleLabel.font = ._36MontserratBold
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        locationButton.setTitleColor(.white, for: .normal)
        locationButton.titleLabel?.font = ._14MontserratLight
        locationButton.titleLabel?.textAlignment = .center
        locationButton.addTarget(self, action: #selector(locationSelected), for: .touchUpInside)
        addSubview(locationButton)

        instructorButton.titleLabel?.font = ._16MontserratBold
        instructorButton.titleLabel?.textAlignment = .center
        instructorButton.setTitleColor(.white, for: .normal)
        instructorButton.addTarget(self, action: #selector(instructorSelected), for: .touchUpInside)
        addSubview(instructorButton)

        durationLabel.font = ._18Bebas
        durationLabel.textAlignment = .center
        durationLabel.textColor = .fitnessBlack
        addSubview(durationLabel)
    }

    private func setupConstraints() {
        let durationLabelBottomPadding = 5
        let durationLabelSize = CGSize(width: 50, height: 21)
        let instructorButtonHeight = 21
        let instructorButtonTopPadding = 20
        let locationButtonHeight = 16
        let semicircleImageViewSize = CGSize(width: 100, height: 50)
        let titleLabelHorizontalPadding = 40

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageFilterView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        semicircleImageView.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(semicircleImageViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(titleLabelHorizontalPadding)
            make.center.equalToSuperview()
        }

        locationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(locationButtonHeight)
        }

        instructorButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(locationButton.snp.bottom).offset(instructorButtonTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(instructorButtonHeight)
        }

        durationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-durationLabelBottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(durationLabelSize)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
