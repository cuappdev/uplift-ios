//
//  HabitTrackingController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/11/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

enum HabitTrackingType {
    case cardio, strength, mindfulness
}

class HabitTrackingController: UIViewController {
    
    // MARK: - INITIALIZATION
    weak var delegate: UIViewController?
    var type: HabitTrackingType
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var widgetsView: UIImageView!
    var cancelButton: UIButton!
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var habitTableView: UITableView!
    var habits: [String]!
    
    var saveButton: UIButton!
    var editingIndex: IndexPath?
    var canSwipe: Bool!
    /// Has the index of the swiped cell iff a cell is swiped
    var swipedIndex: IndexPath?
    
    var nextButton: UIButton!
    var backButton: UIButton?
    
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
        titleLabel.font = ._35MontserratRegular
        titleLabel.textColor = .fitnessBlack
        contentView.addSubview(titleLabel)
        
        // DESCRIPTION LABEL
        descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = ._13MontserratRegular
        descriptionLabel.textColor = .fitnessBlack
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        // TABLE VIEW
        habitTableView = UITableView()
        habitTableView.dataSource = self
        habitTableView.delegate = self
        habitTableView.allowsSelection = false
        habitTableView.isScrollEnabled = false
        habitTableView.delaysContentTouches = false
        habitTableView.showsVerticalScrollIndicator = false
        
        habitTableView.register(HabitTrackerOnboardingCell.self, forCellReuseIdentifier: HabitTrackerOnboardingCell.identifier)
        contentView.addSubview(habitTableView)
        canSwipe = true
        
        // SAVE BUTTON
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = ._18MontserratRegular
        saveButton.setTitleColor(UIColor.fitnessBlack, for: .normal)
        saveButton.backgroundColor = .fitnessYellow
        saveButton.layer.cornerRadius = 30
        saveButton.addTarget(self, action: #selector(doneEditingHabit), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.isHidden = true
        view.bringSubviewToFront(saveButton)
        
        switch type {
        case .cardio:
            widgetsView.image = UIImage(named: "widgets-empty")
            titleLabel.text = "Cardio"
            descriptionLabel.text = "Daily heart pump so you can jog to your 10AM with ease"
            habits = ["Run for 15 mins", "Play a sport for 30 mins", "Go for a walk after dinner"]
        case .strength:
            widgetsView.image = UIImage(named: "widgets-1")
            titleLabel.text = "Strength"
            descriptionLabel.text = "Mann Library, WSH or Gates. No building’s door can slow you down now"
            habits = ["Curls for 20 mins", "30 Pushups", "Plank for 5 mins"]
        case .mindfulness:
            widgetsView.image = UIImage(named: "widgets-2")
            titleLabel.text = "Mindfulness"
            descriptionLabel.text = "Take care of your mind, As much as your grades."
            habits = ["Read favorite book for 10 mins", "Meditate for 5 mins", "Reflect on today"]
        }
        
        // KEYBOARD
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doneEditingHabit))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        widgetsView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(107)
            make.height.equalTo(29)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.width.equalTo(17)
            make.centerY.equalTo(widgetsView)
            make.trailing.equalToSuperview().offset(-22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-21)
            make.top.equalTo(widgetsView.snp.bottom).offset(16)
            make.height.equalTo(32)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-54)
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.height.equalTo(44)
        }
        
        habitTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20) // TODO : get proper offset
            let height = 80 + HabitTrackerOnboardingCell.height * ( habits.count + 1 )  // TODO: FIX HEADER HEIGHT
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(60)
            make.centerY.equalTo(0)
        }
    }
    
    @objc func cancel() {
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        if let index = editingIndex {
            let cell = habitTableView.cellForRow(at: index) as! HabitTrackerOnboardingCell
            
            if (habitTableView.frame.minY + cell.frame.maxY) > (keyboardSize.cgRectValue.minY - 100) {
                let offset = cell.frame.maxY + habitTableView.frame.minY + 100 - keyboardSize.cgRectValue.minY
                scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            }
        }
        
        saveButton.snp.updateConstraints { make in
            make.centerY.equalTo(keyboardSize.cgRectValue.minY - 44)
        }
        saveButton.isHidden = false
    }
    
    @objc func doneEditingHabit() {
        if let index = editingIndex {
            canSwipe = true
            swipedIndex = nil
            editingIndex = nil
            saveButton.isHidden = true
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            let cell = habitTableView.cellForRow(at: index) as! HabitTrackerOnboardingCell
            cell.finishEdit()
        }
    }
}

// MARK: - TABLEVIEW
extension HabitTrackingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let title = UILabel()
        title.font = ._14MontserratBold
        title.textAlignment = .left
        title.textColor = .fitnessBlack
        header.addSubview(title)
        
        // TODO : get proper constraints
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        if section == 0 {
            title.text = "Featured"
        } else {
            title.text = "Suggestions"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0 // TODO : figure out how to get this from figma
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HabitTrackerOnboardingCell.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return habits.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitTrackerOnboardingCell.identifier, for: indexPath) as! HabitTrackerOnboardingCell
        
        cell.setTitle(activity: habits[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
}


extension HabitTrackingController: HabitTrackerOnboardingDelegate {
    func prepareForEditing(indexPath: IndexPath) {
        editingIndex = indexPath
        canSwipe = false
    }
    
    func deleteCell(indexPath: IndexPath) {
        habits.remove(at: indexPath.row)
        habitTableView.deleteRows(at: [indexPath], with: .fade)
        
        habitTableView.snp.updateConstraints { make in
            let height = 80 + HabitTrackerOnboardingCell.height * ( habits.count + 1 )  // TODO: FIX HEADER HEIGHT
            make.height.equalTo(height)
        }
    }
    
    func swipeLeft(indexPath: IndexPath) -> Bool {
        if canSwipe {
            if let index = swipedIndex {
                let cell = habitTableView.cellForRow(at: index) as! HabitTrackerOnboardingCell
                cell.swipeRight()
            }
            
            swipedIndex = indexPath
            return true
        } else {
            return false
        }
    }
    
    func swipeRight() {
        swipedIndex = nil
    }
}
