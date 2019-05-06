//
//  HabitTrackingController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/11/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import MobileCoreServices
import SnapKit
import UIKit

enum HabitTrackingType: Int {
    case cardio = 0, strength, mindfulness
}

private enum FileConstants {
    static let featuredHabitSection = 0
    static let suggestedHabitSection = 1
    
    static let featuredSectionHeaderHeight = 50
    static let suggestedSectionHeaderHeight = 34
}

class HabitTrackingController: UIViewController {
    
    // MARK: - INITIALIZATION
    var type: HabitTrackingType
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var widgetsView: UIImageView!
    var cancelButton: UIButton!
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var saveHabitButton: UIButton!
    /// Has the index of the editing cell iff a cell is editing
    var editingCell: HabitTrackerOnboardingCell?
    var canSwipe: Bool!
    /// Has the index of the swiped cell iff a cell is swiped
    var swipedCell: HabitTrackerOnboardingCell?
    
    var createHabitButton: UIButton!
    
    var nextButton: UIButton!
    var backButton: UIButton?
    
    var habitTableView: UITableView!
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
    
    init(type: HabitTrackingType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fitnessWhite
        
        tabBarController?.tabBar.isHidden = true
        
        // SCROLLVIEW
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
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }
        
        // WIDGETS
        widgetsView = UIImageView()
        contentView.addSubview(widgetsView)
        
        // CANCEL BUTTON
        cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "x"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        
        // TITLE LABEL
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = ._36MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.clipsToBounds = false
        contentView.addSubview(titleLabel)
        
        // DESCRIPTION LABEL
        descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = ._16MontserratLight
        descriptionLabel.textColor = .fitnessBlack
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        // TABLE VIEW
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
        canSwipe = true
        
        // SAVE BUTTON
        saveHabitButton = UIButton()
        saveHabitButton.setTitle("SAVE", for: .normal)
        saveHabitButton.titleLabel?.font = ._12MontserratBold
        saveHabitButton.setTitleColor(UIColor.fitnessWhite, for: .normal)
        saveHabitButton.backgroundColor = .fitnessBlack
        saveHabitButton.layer.cornerRadius = 30
        saveHabitButton.addTarget(self, action: #selector(doneEditingHabit), for: .touchUpInside)
        view.addSubview(saveHabitButton)
        saveHabitButton.isHidden = true
        view.bringSubviewToFront(saveHabitButton)
        
        // CREATE HABIT BUTTON
        createHabitButton = UIButton()
        createHabitButton.setTitle("Create your own", for: .normal)
        createHabitButton.titleLabel?.font = ._16MontserratMedium
        createHabitButton.titleLabel?.textAlignment = .left
        createHabitButton.setTitleColor(.fitnessMediumGrey, for: .normal)
        createHabitButton.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        contentView.addSubview(createHabitButton)
        
        // NEXT PAGE BUTTON
        nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        view.addSubview(nextButton)
        view.bringSubviewToFront(nextButton)
        nextButton.isHidden = true
        
        // BACK BUTTON
        if type != .cardio {
            backButton = UIButton()
            
            if let backButton = backButton {
                backButton.setImage(UIImage(named: "black-yellow-next-arrow"), for: .normal)
                backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
                view.addSubview(backButton)
                view.bringSubviewToFront(backButton)
            }
        }
        
        habits = HabitConstants.suggestedHabits(type: type)
        descriptionLabel.text = HabitConstants.habitTypeDescription(type: type)
        
        switch type {
        case .cardio:
            widgetsView.image = UIImage(named: "widgets-empty")
            nextButton.setImage(UIImage(named: "black-yellow-next-arrow"), for: .normal)
            titleLabel.text = "Cardio"
        case .strength:
            widgetsView.image = UIImage(named: "widgets-1")
            nextButton.setImage(UIImage(named: "black-yellow-next-arrow"), for: .normal)
            titleLabel.text = "Strength"
        case .mindfulness:
            widgetsView.image = UIImage(named: "widgets-2")
            nextButton.setImage(UIImage(named: "checkmark-yellow"), for: .normal)
            titleLabel.text = "Mindfulness"
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
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        let cancelButtonDiameter = 17
        let createHabitButtonHeight = 24
        let createHabitButtonInset = 56
        let createHabitButtonWidth = 145
        let descriptionLabelHeight = 44
        let leadingInset = 24
        let navigationButtonBottomInset = 70
        let navigationButtonDiameter = 35
        let navigationButtonHorizontalInset = 40
        let saveButtonHeight = 60
        let saveButtonInsets = 24
        let titleLabelHeight = 40
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
            make.top.equalTo(widgetsView.snp.bottom).offset(16)
            make.height.equalTo(titleLabelHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.trailing.equalToSuperview().inset(trailingInset)
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.height.equalTo(descriptionLabelHeight)
        }
        
        habitTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.height.equalTo(getTableViewHeight())
        }
        
        createHabitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(createHabitButtonInset)
            make.width.equalTo(createHabitButtonWidth)
            make.top.equalTo(habitTableView.snp.bottom).offset(10)
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
            backButton?.snp.makeConstraints { make in
                make.height.width.equalTo(navigationButtonDiameter)
                make.leading.equalToSuperview().inset(navigationButtonHorizontalInset)
                make.bottom.equalToSuperview().offset(navigationButtonBottomInset)
            }
        }
    }
    
    func updateTableViewConstraints() {
        habitTableView.snp.updateConstraints { make in
            make.height.equalTo(getTableViewHeight())
        }
    }
    
    func getTableViewHeight() -> Int {
        // 1 cell in section zero + `habits.count` cells in section one
        return FileConstants.featuredSectionHeaderHeight + FileConstants.suggestedSectionHeaderHeight + HabitTrackerOnboardingCell.height * ( habits.count + 1 )
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
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
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
        habitTableView.insertRows(at: [IndexPath(row: habits.count - 1, section: FileConstants.suggestedHabitSection)], with: .automatic)
        
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
                
                if indexPath.section == FileConstants.featuredHabitSection {
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
                if indexPath.section == FileConstants.featuredHabitSection {
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

// MARK: - TABLEVIEW DELEGATE AND DATA SOURCE
extension HabitTrackingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let title = UILabel()
        title.font = ._14MontserratBold
        title.textAlignment = .left
        title.textColor = .fitnessDarkGrey
        header.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            if section == FileConstants.featuredHabitSection {
                make.centerY.equalToSuperview()
            } else {
                make.bottom.equalToSuperview()
            }
            make.trailing.equalToSuperview()
            make.height.equalTo(18)
        }
        
        if section == FileConstants.featuredHabitSection {
            title.text = "FEATURED"
        } else {
            title.text = "SUGGESTIONS"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == FileConstants.featuredHabitSection {
            return CGFloat(FileConstants.featuredSectionHeaderHeight)
        } else {
            return CGFloat(FileConstants.suggestedSectionHeaderHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HabitTrackerOnboardingCell.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == FileConstants.featuredHabitSection {
            return 1
        } else {
            return habits.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let habitCell = cell as? HabitTrackerOnboardingCell else { return }
        
        // The only time a cell will be displayed with the empty string is when a new habit is being created
        if habitCell.titleLabel.text == "" {
            habitCell.swipeLeft()
            habitCell.edit()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == FileConstants.featuredHabitSection {
            if let habit = featuredHabit {
                let cell = tableView.dequeueReusableCell(withIdentifier: HabitTrackerOnboardingCell.identifier, for: indexPath) as! HabitTrackerOnboardingCell
                
                cell.setTitle(activity: habit)
                cell.swipeRight()
                cell.delegate = self
                cell.separator.isHidden = true
                
                return cell
            } else {
                // Empty state featured habit
                // TODO - replace this with the NoHabitsCell class once it is converted to a tableview
                let cell = UITableViewCell()
                
                let backgroundImage = UIImageView()
                backgroundImage.image = UIImage(named: "selection-area")
                backgroundImage.clipsToBounds = false
                cell.contentView.addSubview(backgroundImage)
                
                backgroundImage.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(21)
                    make.trailing.equalToSuperview().offset(-21)
                }
                
                let addHabitWidget = UIImageView()
                addHabitWidget.image = UIImage(named: "add-habit")
                cell.contentView.addSubview(addHabitWidget)
                
                addHabitWidget.snp.makeConstraints { make in
                    make.width.height.equalTo(20)
                    make.leading.equalTo(backgroundImage).offset(15)
                    make.centerY.equalToSuperview()
                }
                
                let titleLabel = UILabel()
                titleLabel.text = "The first step is the hardest."
                titleLabel.textAlignment = .left
                titleLabel.clipsToBounds = false
                titleLabel.font = ._16MontserratMedium
                titleLabel.textColor = .fitnessMediumGrey
                cell.contentView.addSubview(titleLabel)
                
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalTo(addHabitWidget.snp.trailing).offset(8)
                    make.trailing.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.height.equalTo(22)
                }
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HabitTrackerOnboardingCell.identifier, for: indexPath) as! HabitTrackerOnboardingCell
            
            cell.setTitle(activity: habits[indexPath.row])
            cell.swipeRight()
            cell.delegate = self
            
            return cell
        }
    }
}

// MARK: - HABIT TRACKER DELEGATE
extension HabitTrackingController: HabitTrackerOnboardingDelegate {
    func prepareForEditing(cell: HabitTrackerOnboardingCell) {
        editingCell = cell
        canSwipe = false
    }
    
    func endEditing() {
        doneEditingHabit()
    }
    
    func deleteCell(cell: HabitTrackerOnboardingCell) {
        guard let indexPath = habitTableView.indexPath(for: cell) else { return }
        
        if indexPath.section == FileConstants.featuredHabitSection {
            featuredHabit = nil
            habitTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            habits.remove(at: indexPath.row)
            habitTableView.deleteRows(at: [indexPath], with: .automatic)
            updateTableViewConstraints()
        }
    }
    
    func swipeLeft(cell: HabitTrackerOnboardingCell) -> Bool {
        if canSwipe {
            if let previousCell = swipedCell {
                previousCell.swipeRight()
            }
            
            habitTableView.indexPathsForVisibleRows?.forEach({ indexPath in
                if let cell = habitTableView.cellForRow(at: indexPath) as? HabitTrackerOnboardingCell {
                    if indexPath.section == FileConstants.suggestedHabitSection {
                        cell.separator.isHidden = true
                    }
                }
            })
            
            swipedCell = cell
            return true
        } else {
            return false
        }
    }
    
    func swipeRight() {
        swipedCell = nil
        
        habitTableView.indexPathsForVisibleRows?.forEach({ indexPath in
            if let cell = habitTableView.cellForRow(at: indexPath) as? HabitTrackerOnboardingCell {
                if indexPath.section == FileConstants.suggestedHabitSection {
                    cell.separator.isHidden = false
                }
            }
        })
    }
    
    func featureHabit(cell: HabitTrackerOnboardingCell) {
        guard let indexPath = habitTableView.indexPath(for: cell) else { return }
        
        if indexPath.section == FileConstants.featuredHabitSection {
            guard let habit = featuredHabit else { return }
            
            habits.append(habit)
            featuredHabit = nil
            updateTableViewConstraints()
            
            habitTableView.beginUpdates()
            habitTableView.insertRows(at: [IndexPath(row: habits.count - 1, section: 1)], with: .automatic)
            habitTableView.reloadRows(at: [indexPath], with: .automatic)
            habitTableView.endUpdates()

            return
        }
        
        if let currentHabit = featuredHabit {
            habits.append(currentHabit)
            featuredHabit = habits[indexPath.row]
            habits.remove(at: indexPath.row)
            habitTableView.reloadData()
        } else {
            featuredHabit = habits[indexPath.row]
            habits.remove(at: indexPath.row)
            habitTableView.reloadData()
            updateTableViewConstraints()
        }
    }
}

// MARK: - TABLEVIEW DRAG AND DROP DELEGATE
extension HabitTrackingController:  UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        var habit: String
        if indexPath.section == FileConstants.featuredHabitSection {
            if let featuredHabit = featuredHabit {
                habit = featuredHabit
            } else { return [] }
        } else {
            habit = habits[indexPath.row]
        }
        
        let data = habit.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [ UIDragItem(itemProvider: itemProvider) ]
    }
    

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            
            guard let stringItems = items as? [String] else { return }
            guard let habit = stringItems.first else { return }
            
            if let index = self.habits.index(of: habit) {
                // Habit is originating from the suggested section
                self.habits.remove(at: index)
                
                if destinationIndexPath.section == FileConstants.featuredHabitSection {
                    // Moving suggested habit to featured
                    tableView.beginUpdates()
                    
                    if let oldHabit = self.featuredHabit {
                        self.habits.append(oldHabit)
                        tableView.insertRows(at: [IndexPath(row: self.habits.count - 1, section: 1)], with: .automatic)
                    }
                    
                    self.featuredHabit = habit
                    
                    tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    tableView.endUpdates()
                    self.updateTableViewConstraints()
                    
                } else {
                    // Moving suggested habit around in section
                    self.habits.insert(habit, at: destinationIndexPath.row)
                    tableView.reloadSections(IndexSet(integersIn: 1..<2), with: .automatic)
                }
                
            } else {
                // Habit is currently featured
                if destinationIndexPath.section == FileConstants.suggestedHabitSection {
                    // Moving featured habit back down
                    tableView.beginUpdates()

                    self.featuredHabit = nil
                    self.habits.insert(habit, at: destinationIndexPath.row)

                    tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    tableView.endUpdates()

                    self.updateTableViewConstraints()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
