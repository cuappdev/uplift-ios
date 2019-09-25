//
//  ProRoutineCollectionViewCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ProRoutineCellDelegate: class {
    func pushHabitAddedAlert(habitTitle: String)
}

class ProRoutineCollectionViewCell: UICollectionViewCell {

    static let identifier = Identifiers.proRoutineCell

    // MARK: - Constraint constants
    enum Constants {
        static let cellPadding: CGFloat = 16
        static let routineTypeLabelHeight: CGFloat = 15
        static let routineTypeTopPadding: CGFloat = 3
        static let titleLabelHeight: CGFloat = 20
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return 3 * Constants.cellPadding + Constants.titleLabelHeight + Constants.routineTypeTopPadding + Constants.routineTypeLabelHeight
    }
    // MARK: - Private view vars
    private let addButton = UIButton()
    private var descriptionTextView = UITextView()
    private var routineTypeImage =  UIImageView()
    private var routineTypeLabel = UILabel()
    private var titleLabel =  UILabel()

    // MARK: - Private data vars
    private weak var delegate: ProRoutineCellDelegate?
    private var routine: ProRoutine!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ProRoutineCellDelegate, for routine: ProRoutine) {
        self.delegate = delegate
        self.routine = routine
        descriptionTextView.text = routine.text
        titleLabel.text = routine.title

        switch routine.routineType {
        case .cardio:
            routineTypeLabel.text = "Cardio"
            routineTypeImage.image = #imageLiteral(resourceName: "small cardio icon")
        case .mindfulness:
            routineTypeLabel.text = "Mindfulness"
            routineTypeImage.image = #imageLiteral(resourceName: "smaller mindfulness icon")
        case .strength:
            routineTypeLabel.text = "Strength"
            routineTypeImage.image = #imageLiteral(resourceName: "small strength icon")
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .white

        addButton.setImage(#imageLiteral(resourceName: "add habit"), for: .normal)
        addButton.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        contentView.addSubview(addButton)

        descriptionTextView.font = ._14MontserratLight
        descriptionTextView.textColor = .fitnessLightBlack
        descriptionTextView.textAlignment = .left
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isSelectable = false
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        contentView.addSubview(descriptionTextView)

        routineTypeImage.contentMode = .scaleAspectFit
        routineTypeImage.clipsToBounds = true
        contentView.addSubview(routineTypeImage)

        routineTypeLabel.font = ._12MontserratRegular
        routineTypeLabel.textColor = .fitnessSecondaryBlack
        routineTypeLabel.textAlignment = .left
        contentView.addSubview(routineTypeLabel)

        titleLabel.font = ._16MontserratMedium
        titleLabel.textColor = .fitnessBlack
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        let addButtonSize = 24
        let cellPadding = 16
        let routineTypeImageSize = 15
        let routineTypeLabelHeight = 15
        let routineTypeLabelLeftPadding = 8
        let routineTypeTopPadding = 3
        let titleLabelHeight = 20

        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(cellPadding)
            make.trailing.equalToSuperview().inset(cellPadding)
            make.height.width.equalTo(addButtonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(cellPadding)
            make.leading.equalToSuperview().inset(cellPadding)
            make.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-cellPadding)
            make.height.equalTo(titleLabelHeight)
        }

        routineTypeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(cellPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(routineTypeTopPadding)
            make.height.width.equalTo(routineTypeImageSize)
        }

        routineTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(routineTypeImage.snp.trailing).offset(routineTypeLabelLeftPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(routineTypeTopPadding)
            make.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-cellPadding)
            make.height.equalTo(routineTypeLabelHeight)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(routineTypeLabel.snp.bottom).offset(cellPadding)
            make.leading.trailing.bottom.equalToSuperview().inset(cellPadding)
        }
    }

    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 4.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.fitnessMutedGreen.cgColor
        layer.borderWidth = 1

        applySketchShadow(color: .fitnessMutedGreen, alpha: 1, x: 0, y: 11, blur: 14, spread: -10)
    }

    // Function to apply a shadow as specified by Sketch parameters, retrieved from: https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur/48489506#48489506
    func applySketchShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -(spread)
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    // MARK: - Targets
    @objc func addHabit() {
        Habit.setActiveHabit(title: routine.title, type: routine.routineType)

        if let delegate = delegate {
            delegate.pushHabitAddedAlert(habitTitle: routine.title)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
