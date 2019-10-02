//
//  GymDetailPopularTimesCell.swift
//  Fitness
//
//  Created by Yana Sang on 5/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailPopularTimesCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let dividerViewHeight = 1
        static let dividerViewTopPadding = 24
        static let popularTimesHistogramHeight = 101
        static let popularTimesHistogramTopPadding = 24
        static let popularTimesLabelHeight = 19
        static let popularTimesLabelTopPadding = 24
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        let labelHeight = Constants.popularTimesLabelTopPadding + Constants.popularTimesLabelHeight
        let histogramHeight = Constants.popularTimesHistogramTopPadding + Constants.popularTimesHistogramHeight
        let dividerHeight = Constants.dividerViewTopPadding + Constants.dividerViewHeight
        return CGFloat(labelHeight + histogramHeight + dividerHeight)
    }

    // MARK: - Private view vars
    private var popularTimesHistogram: Histogram!
    private let popularTimesLabel = UILabel()
    private let dividerView = UIView()

    // MARK: - Private data vars
    private var data: [Int] = []
    private var isOpen: Bool = true
    private var todaysHours: DailyGymHours!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym) {
        data = gym.popularTimesList[Date().getIntegerDayOfWeekToday()]
        isOpen = gym.isOpen
        todaysHours = gym.gymHoursToday

        DispatchQueue.main.async {
            self.setupHistogram()
            self.setupConstraints()
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        popularTimesLabel.text = ClientStrings.GymDetail.popularHoursSection
        popularTimesLabel.font = ._16MontserratMedium
        popularTimesLabel.textColor = .fitnessLightBlack
        popularTimesLabel.textAlignment = .center
        contentView.addSubview(popularTimesLabel)

        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    private func setupHistogram() {
        if isOpen && popularTimesHistogram == nil {
            popularTimesHistogram = Histogram(frame: CGRect(x: 0, y: 0, width: contentView.frame.width - 36, height: 0), data: data, todaysHours: todaysHours)
            contentView.addSubview(popularTimesHistogram)
        }
    }

    private func setupConstraints() {
        popularTimesLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.popularTimesLabelTopPadding)
            make.height.equalTo(Constants.popularTimesLabelHeight)
        }

        if let histogram = popularTimesHistogram {
            let popularTimesHistogramHorizontalPadding = 18

            histogram.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(popularTimesHistogramHorizontalPadding)
                make.top.equalTo(popularTimesLabel.snp.bottom).offset(Constants.popularTimesLabelTopPadding)
                make.height.equalTo(Constants.popularTimesHistogramHeight)
            }

            dividerView.snp.remakeConstraints { make in
                make.top.equalTo(histogram.snp.bottom).offset(Constants.dividerViewTopPadding)
                make.height.equalTo(Constants.dividerViewHeight)
                make.leading.trailing.equalToSuperview()
            }
        } else {
            dividerView.snp.makeConstraints { make in
                make.top.equalTo(popularTimesLabel.snp.bottom).offset(Constants.dividerViewTopPadding)
                make.height.equalTo(Constants.dividerViewHeight)
                make.leading.trailing.equalToSuperview()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
