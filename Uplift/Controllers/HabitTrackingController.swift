//
//  HabitTrackingController.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 3/11/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import MobileCoreServices
import SnapKit
import UIKit

enum HabitTrackingType: Int {
    case cardio = 0, strength, mindfulness
}

class HabitTrackingController: UIViewController {

    // MARK: - Public view vars
    /// Has the index of the editing cell iff a cell is editing
    var editingCell: HabitTrackerOnboardingCell?
    var habitTableView: UITableView!
    /// Has the index of the swiped cell iff a cell is swiped
    var swipedCell: HabitTrackerOnboardingCell?

    // MARK: - Private view vars
    private var backButton: UIButton!
    private var cancelButton: UIButton!
    private var contentView: UIView!
    private var createHabitButton: UIButton!
    private var descriptionLabel: UILabel!
    private var nextButton: UIButton!
    private var saveHabitButton: UIButton!
    private var scrollView: UIScrollView!
    private var titleLabel: UILabel!
    private var widgetsView: UIImageView!

    // MARK: - Public data vars
    var canSwipe: Bool!
    var habits: [String]!
    var featuredHabit: String? {
        didSet {
            Habit.setActiveHabit(title: featuredHabit ?? "", type: type)

            let imageNames = ["widgets-empty", "widgets-1", "widgets-2", "widgets-3"]

            if featuredHabit == nil {
                nextButton.isHidden = true
                widgetsView.image = UIImage(named: imageNames[type.rawValue])
            } else {
                nextButton.isHidden = false
                widgetsView.image = UIImage(named: imageNames[type.rawValue + 1])
            }
        }
    }

    // MARK: - Private data vars
    private var type: HabitTrackingType

    // MARK: - Constants
    enum Constants {
        static let featuredHabitSection = 0
        static let featuredSectionHeaderHeight = 50
        static let suggestedHabitSection = 1
        static let suggestedSectionHeaderHeight = 34
    }

    init(type: HabitTrackingType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // swiftlint:disable:next function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryWhite
        tabBarController?.tabBar.isHidden = true
        canSwipe = true
        habits = HabitConstants.suggestedHabits(type: type)

        // Setup Views
        setupScrollView()
        setupContentView()
        setupWidgetsView()
        setupCancelButton()
        setupTitleLabel()
        setupDescriptionLabel()
        setupHabitTableView()
        setupSaveHabitButton()
        setupCreateHabitButton()
        setupNextPageButton()
        if type != .cardio {
            setupBackButton()
        }

        if let activeHabit = Habit.getActiveHabitTitle(type: type) {
            featuredHabit = activeHabit
            if let index = habits.index(of: activeHabit) {
                habits.remove(at: index)
            }
        }

        // KEYBOARD
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // GESTURES
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doneEditingHabit))
        view.addGestureRecognizer(tap)

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        contentView.addGestureRecognizer(edgeSwipe)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

    func updateTableViewConstraints() {
        habitTableView.snp.updateConstraints { make in
            make.height.equalTo(getTableViewHeight())
        }
    }

    func getTableViewHeight() -> Int {
        // 1 cell in section zero + `habits.count` cells in section one
        return Constants.featuredSectionHeaderHeight + Constants.suggestedSectionHeaderHeight + HabitTrackerOnboardingCell.height * ( habits.count + 1 )
    }
}

// BUTTON AND GESTURE METHODS
extension HabitTrackingController {
    @objc func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

    @objc func nextPage() {
        var newType: HabitTrackingType

        switch type {
        case .cardio:
            newType = .strength
        case .strength:
            newType = .mindfulness
        case .mindfulness:
            cancel()
            return
        }

        let nextHabitTrackingViewController = HabitTrackingController(type: newType)
        navigationController?.pushViewController(nextHabitTrackingViewController, animated: true)
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        // Move scrollview up so the cell being edited isn't covered by the keyboard
        if let cell = editingCell {
            if (habitTableView.frame.minY + cell.frame.maxY) > (keyboardSize.cgRectValue.minY - 100) {
                let offset = cell.frame.maxY + habitTableView.frame.minY + 100 - keyboardSize.cgRectValue.minY
                scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            }
        }

        saveHabitButton.snp.updateConstraints { make in
            make.centerY.equalTo(keyboardSize.cgRectValue.minY - 44)
        }

        createHabitButton.isHidden = true
        saveHabitButton.isHidden = false
    }

    @objc func createHabit() {
        habits.append("")
        habitTableView.insertRows(at: [IndexPath(row: habits.count - 1, section: Constants.suggestedHabitSection)], with: .automatic)

        updateTableViewConstraints()
    }

    @objc func doneEditingHabit() {
        if let cell = editingCell {
            canSwipe = true
            swipedCell = nil
            editingCell = nil
            saveHabitButton.isHidden = true
            createHabitButton.isHidden = false

            guard let indexPath = habitTableView.indexPath(for: cell) else { return }

            if cell.titleLabel.text == "" {
                cell.finishEdit()

                if indexPath.section == Constants.featuredHabitSection {
                    featuredHabit = nil
                    habitTableView.reloadRows(at: [indexPath], with: .automatic)
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                } else {
                    habits.remove(at: indexPath.row)
                    habitTableView.deleteRows(at: [indexPath], with: .automatic)

                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)

                        let height = self.getTableViewHeight()
                        self.habitTableView.frame.size.height = CGFloat(height)
                        self.updateTableViewConstraints()

                    }, completion: nil)
                }
            } else {
                if indexPath.section == Constants.featuredHabitSection {
                    featuredHabit = cell.titleLabel.text
                } else {
                    if let habit = cell.titleLabel.text {
                        habits[indexPath.row] = habit
                    }
                }

                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                cell.finishEdit()
            }
        }
    }
}

// MARK: - Layout
extension HabitTrackingController {

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.1)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupContentView() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }
    }

    private func setupWidgetsView() {
        widgetsView = UIImageView()
        switch type {
        case .cardio:
            widgetsView.image = UIImage(named: ImageNames.widgets0)
        case .strength:
            widgetsView.image = UIImage(named: ImageNames.widgets1)
        case .mindfulness:
            widgetsView.image = UIImage(named: ImageNames.widgets2)
        }
        contentView.addSubview(widgetsView)
    }

    private func setupCancelButton() {
        cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: ImageNames.cancel), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        contentView.addSubview(cancelButton)
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = ._36MontserratBold
        titleLabel.textColor = .primaryBlack
        titleLabel.clipsToBounds = false
        switch type {
        case .cardio:
            titleLabel.text = ClientStrings.HabitTracking.vcTitleCardio
        case .strength:
            titleLabel.text = ClientStrings.HabitTracking.vcTitleStrength
        case .mindfulness:
            titleLabel.text = ClientStrings.HabitTracking.vcTitleMindfulness
        }
        contentView.addSubview(titleLabel)
    }

    private func setupDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.text = HabitConstants.habitTypeDescription(type: type)
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = ._16MontserratLight
        descriptionLabel.textColor = .primaryBlack
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
    }

    private func setupHabitTableView() {
        habitTableView = UITableView()
        habitTableView.allowsSelection = false
        habitTableView.isScrollEnabled = false
        habitTableView.delaysContentTouches = false
        habitTableView.showsVerticalScrollIndicator = false
        habitTableView.dataSource = self
        habitTableView.delegate = self
        habitTableView.dragDelegate = self
        habitTableView.dropDelegate = self
        habitTableView.dragInteractionEnabled = true
        habitTableView.separatorStyle = .none
        habitTableView.register(HabitTrackerOnboardingCell.self, forCellReuseIdentifier: HabitTrackerOnboardingCell.identifier)
        contentView.addSubview(habitTableView)
    }

    private func setupSaveHabitButton() {
        saveHabitButton = UIButton()
        saveHabitButton.setTitle(ClientStrings.HabitTracking.saveButton, for: .normal)
        saveHabitButton.titleLabel?.font = ._12MontserratBold
        saveHabitButton.setTitleColor(UIColor.primaryWhite, for: .normal)
        saveHabitButton.backgroundColor = .primaryBlack
        saveHabitButton.layer.cornerRadius = 30
        saveHabitButton.addTarget(self, action: #selector(doneEditingHabit), for: .touchUpInside)
        view.addSubview(saveHabitButton)
        saveHabitButton.isHidden = true
        view.bringSubviewToFront(saveHabitButton)
    }

    private func setupCreateHabitButton() {
        createHabitButton = UIButton()
        createHabitButton.setTitle(ClientStrings.HabitTracking.createHabitButton, for: .normal)
        createHabitButton.titleLabel?.font = ._16MontserratMedium
        createHabitButton.titleLabel?.textAlignment = .left
        createHabitButton.setTitleColor(.upliftMediumGrey, for: .normal)
        createHabitButton.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        contentView.addSubview(createHabitButton)
    }

    private func setupNextPageButton() {
        nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        nextButton.isHidden = true
        switch type {
        case .cardio:
            nextButton.setImage(UIImage(named: ImageNames.yellowNextArrow), for: .normal)
        case .strength:
            nextButton.setImage(UIImage(named: ImageNames.yellowNextArrow), for: .normal)
        case .mindfulness:
            nextButton.setImage(UIImage(named: ImageNames.yellowCheckmark), for: .normal)
        }
        view.addSubview(nextButton)
        view.bringSubviewToFront(nextButton)
    }

    private func setupBackButton() {
        backButton = UIButton()
        backButton.setImage(UIImage(named: ImageNames.yellowNextArrow), for: .normal)
        backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
    }

    // MARK: - CONSTRAINTS
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        let cancelButtonDiameter = 17
        let createHabitButtonHeight = 24
        let createHabitButtonInset = 56
        let createHabitButtonTopPadding = 10
        let createHabitButtonWidth = 145
        let descriptionLabelHeight = 44
        let descriptionLabelTopPadding = 18
        let habitTableViewTopPadding = 8
        let leadingInset = 24
        let navigationButtonBottomInset = 70
        let navigationButtonDiameter = 35
        let navigationButtonHorizontalInset = 40
        let saveButtonHeight = 60
        let saveButtonInsets = 24
        let titleLabelHeight = 40
        let titleLabelTopPadding = 16
        let trailingInset = 24
        let widgetsViewHeight = 29
        let widgetsViewVerticalInset = 48
        let widgetsViewWidth = 107

        widgetsView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.top.equalToSuperview().inset(widgetsViewVerticalInset)
            make.width.equalTo(widgetsViewWidth)
            make.height.equalTo(widgetsViewHeight)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.width.equalTo(cancelButtonDiameter)
            make.centerY.equalTo(widgetsView)
            make.trailing.equalToSuperview().inset(trailingInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.trailing.equalToSuperview().inset(trailingInset)
            make.top.equalTo(widgetsView.snp.bottom).offset(titleLabelTopPadding)
            make.height.equalTo(titleLabelHeight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.trailing.equalToSuperview().inset(trailingInset)
            make.top.equalTo(titleLabel.snp.bottom).offset(descriptionLabelTopPadding)
            make.height.equalTo(descriptionLabelHeight)
        }

        habitTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(habitTableViewTopPadding)
            make.height.equalTo(getTableViewHeight())
        }

        createHabitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(createHabitButtonInset)
            make.width.equalTo(createHabitButtonWidth)
            make.top.equalTo(habitTableView.snp.bottom).offset(createHabitButtonTopPadding)
            make.height.equalTo(createHabitButtonHeight)
            make.bottom.equalToSuperview()
        }

        saveHabitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(saveButtonInsets)
            make.trailing.equalToSuperview().inset(saveButtonInsets)
            make.height.equalTo(saveButtonHeight)
            make.centerY.equalTo(0)
        }

        nextButton.snp.makeConstraints { make in
            make.height.width.equalTo(navigationButtonDiameter)
            make.trailing.equalToSuperview().inset(navigationButtonHorizontalInset)
            make.bottom.equalToSuperview().inset(navigationButtonBottomInset)
        }

        if type != .cardio {
            backButton.snp.makeConstraints { make in
                make.height.width.equalTo(navigationButtonDiameter)
                make.leading.equalToSuperview().inset(navigationButtonHorizontalInset)
                make.bottom.equalToSuperview().offset(navigationButtonBottomInset)
            }
        }
    }

}
