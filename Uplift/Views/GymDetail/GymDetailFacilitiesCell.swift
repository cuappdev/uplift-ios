//
//  GymDetailFacilitiesCell.swift
//  Fitness
//
//  Created by Yana Sang on 9/5/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailFacilitiesCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let dividerHeight = 1
        static let dividerTopPadding = 24
        static let gymFacilitiesCellHeight: CGFloat = 20
        static let gymFacilitiesTopPadding = 12
        static let facilitiesLabelHeight = 22
        static let facilitiesLabelTopPadding = 23
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return CGFloat(Constants.facilitiesLabelTopPadding + Constants.facilitiesLabelHeight + Constants.gymFacilitiesTopPadding + Constants.dividerTopPadding + Constants.dividerHeight)
    }

    // MARK: - Private view vars
    private let dividerView = UIView()
    private let facilitiesLabel = UILabel()
    private var gymFacilitiesTableView: UITableView!
    static var gymFacilitiesCount: Int = 0

    // MARK: - Private data vars
    private let facilitiesData: [String: [String]] = [
        GymIds.appel: ["Fitness Center"],
        GymIds.helenNewman: ["Fitness Center", "Pool", "16 Lane Bowling Center", "Two-Court Gymnasium", "Dance Studio"],
        GymIds.noyes: ["Fitness Center", "Game Area", "Indoor Basketball Court", "Outdoor Basketball Court", "Bouldering Wall", "Multi-Purpose Room"],
        GymIds.teagleDown: ["Fitness Center", "Pool"],
        GymIds.teagleUp: ["Fitness Center", "Pool"]
    ]

    private var gymFacilities: [String] = []
    private var gymId: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym) {
        gymId = gym.id
        gymFacilities = facilitiesData[gym.id]!
        GymDetailFacilitiesCell.gymFacilitiesCount = gymFacilities.count

        DispatchQueue.main.async {
            self.gymFacilitiesTableView.reloadData()
            self.setupConstraints()
        }
    }

    func setupViews() {
        facilitiesLabel.font = ._16MontserratMedium
        facilitiesLabel.textAlignment = .center
        facilitiesLabel.textColor = .fitnessBlack
        facilitiesLabel.text = ClientStrings.GymDetail.facilitiesSection
        contentView.addSubview(facilitiesLabel)

        gymFacilitiesTableView = UITableView(frame: .zero, style: .plain)
        gymFacilitiesTableView.bounces = false
        gymFacilitiesTableView.showsVerticalScrollIndicator = false
        gymFacilitiesTableView.separatorStyle = .none
        gymFacilitiesTableView.backgroundColor = .clear
        gymFacilitiesTableView.isScrollEnabled = false
        gymFacilitiesTableView.allowsSelection = false
        gymFacilitiesTableView.register(GymFacilitiesCell.self, forCellReuseIdentifier: GymFacilitiesCell.identifier)
        gymFacilitiesTableView.delegate = self
        gymFacilitiesTableView.dataSource = self
        contentView.addSubview(gymFacilitiesTableView)

        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    func setupConstraints() {
        facilitiesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.facilitiesLabelTopPadding)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.facilitiesLabelHeight)
        }

        if let gymFacilitiesTableView = gymFacilitiesTableView {
            gymFacilitiesTableView.snp.remakeConstraints { make in
                make.top.equalTo(facilitiesLabel.snp.bottom).offset(Constants.gymFacilitiesTopPadding)
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Constants.gymFacilitiesCellHeight * CGFloat(gymFacilities.count))
            }

            dividerView.snp.remakeConstraints { make in
                make.top.equalTo(gymFacilitiesTableView.snp.bottom).offset(Constants.dividerTopPadding)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(Constants.dividerHeight)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GymDetailFacilitiesCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymFacilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = gymFacilitiesTableView.dequeueReusableCell(withIdentifier: GymFacilitiesCell.identifier, for: indexPath) as! GymFacilitiesCell
        cell.facilityLabel.text = gymFacilities[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.gymFacilitiesCellHeight
    }
}
