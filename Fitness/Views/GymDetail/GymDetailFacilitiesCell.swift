//
//  GymDetailFacilitiesCell.swift
//  Fitness
//
//  Created by Yana Sang on 9/5/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailFacilitiesCell: UICollectionViewCell {
    
    // MARK: - Private view vars
    private let dividerView = UIView()
    private let facilitiesLabel = UILabel()
    private var gymFacilitiesView: GymFacilitiesTableView!

    // MARK: - Private data vars
    private var gymId: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym) {
        gymId = gym.id
        DispatchQueue.main.async {
            self.setupFacilities()
            self.remakeConstraints()
        }
    }

    func setupViews() {
        facilitiesLabel.font = ._16MontserratMedium
        facilitiesLabel.textAlignment = .center
        facilitiesLabel.textColor = .fitnessBlack
        facilitiesLabel.text = "FACILITIES"
        contentView.addSubview(facilitiesLabel)

        setupFacilities()
        
        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    // MARK: - SETUP FACILITIES TABLE
    func setupFacilities() {
        let appelGymID = "7c53229a64f4794f57a715a9ec0c7f806db23514"
        let helenNewmanGymID = "7045d11329b3645c93556c5aaf44bb21d56934f5"
        let teagleGymID = "939c7a2c16d2299cc8558475a8007defc414069c"
        let teagleGymID2 = "043c57f3b63411c7a3500c0986fa4b1c8712798c"

        if gymId == "" {
            return
        }

        if gymId == helenNewmanGymID {
            gymFacilitiesView = GymFacilitiesTableView(facilityName: .helenNewman)
        } else if gymId == teagleGymID || gymId == teagleGymID2 {
            gymFacilitiesView = GymFacilitiesTableView(facilityName: .teagle)
        } else if gymId == appelGymID {
            gymFacilitiesView = GymFacilitiesTableView(facilityName: .appel)
        } else {
            gymFacilitiesView = GymFacilitiesTableView(facilityName: .noyes)
        }
        contentView.addSubview(gymFacilitiesView)
    }

    func setupConstraints() {
        facilitiesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
    }

    func remakeConstraints() {
        if let gymFacilitiesView = gymFacilitiesView {
            gymFacilitiesView.snp.makeConstraints { make in
                make.top.equalTo(facilitiesLabel.snp.bottom).offset(20)
                make.width.centerX.equalToSuperview()
                make.height.equalTo(420)
            }

            dividerView.snp.makeConstraints { make in
                make.top.equalTo(gymFacilitiesView.snp.bottom).offset(32)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
