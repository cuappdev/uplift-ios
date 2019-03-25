//
//  HabitTrackerOnboardingCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/11/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import SnapKit
import UIKit

protocol HabitTrackerOnboardingDelegate: class {
    func deleteCell(cell: HabitTrackerOnboardingCell)
    func endEditing()
    func featureHabit(cell: HabitTrackerOnboardingCell)
    func prepareForEditing(cell: HabitTrackerOnboardingCell)
    func swipeLeft(cell: HabitTrackerOnboardingCell) -> Bool
    func swipeRight()
}

class HabitTrackerOnboardingCell: UITableViewCell {
    
    // MARK: - INITIALIZATION
    static let height = 54
    static let identifier = Identifiers.habitTrackerOnboardingCell
    
    weak var delegate: HabitTrackerOnboardingDelegate!

    var dotsImage: UIImageView!
    var titleLabel: UITextField!
    var isSwiped: Bool!
    
    var trashButton: UIButton!
    var editButton: UIButton!
    var pinButton: UIButton!
    
    var clearTextButton: UIButton!
    
    var canEdit: Bool!
    var editingTitle: Bool!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // SWIPE INTERACTIONS
        isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
        
        // DRAG ICON
        dotsImage = UIImageView(image: UIImage(named: "drag-icon"))
        contentView.addSubview(dotsImage)
        
        // TITLE LABEL
        titleLabel = UITextField()
        titleLabel.font = ._14MontserratRegular
        titleLabel.textAlignment = .left
        titleLabel.textColor = .fitnessBlack
        titleLabel.sizeToFit()
        titleLabel.delegate = self
        titleLabel.textDropDelegate = self
        titleLabel.keyboardType = .alphabet
        contentView.addSubview(titleLabel)
        
        // BUTTONS
        trashButton = UIButton()
        trashButton.setImage(UIImage(named: "trash-icon"), for: .normal)
        trashButton.addTarget(self, action: #selector(deleteCell), for: .touchUpInside)
        contentView.addSubview(trashButton)
        
        editButton = UIButton()
        editButton.setImage(UIImage(named: "edit-icon"), for: .normal)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        contentView.addSubview(editButton)
        
        pinButton = UIButton()
        pinButton.setImage(UIImage(named: "pin-icon"), for: .normal)
        pinButton.addTarget(self, action: #selector(pin), for: .touchUpInside)
        contentView.addSubview(pinButton)
        
        clearTextButton = UIButton()
        clearTextButton.setImage(UIImage(named: "keyboard-cancel"), for: .normal)
        clearTextButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        contentView.addSubview(clearTextButton)
        
        isSwiped = false
        canEdit = false
        editingTitle = false
        trashButton.isHidden = true
        editButton.isHidden = true
        pinButton.isHidden = true
        clearTextButton.isHidden = true
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        let buttonSize = 30
        
        dotsImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35)
            make.width.equalTo(8)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotsImage.snp.trailing).offset(10)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-21)
        }
        
        pinButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.trailing.equalToSuperview().offset(-21)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.trailing.equalTo(pinButton.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
        }
        
        trashButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.trailing.equalTo(editButton.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
        }
        
        clearTextButton.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateConstraintsLeftSwipe() {
        dotsImage.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-132)
        }
    }
    
    func updateConstraintsRightSwipe() {
        dotsImage.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(35)
        }
        
        titleLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-21)
        }
    }
    
    func setTitle(activity: String) {
        titleLabel.text = activity
    }
    
    // MARK: - BUTTON AND GESTURE METHODS
    @objc func swipeLeft() {
        // Unless a cell is editing, the swipe will succeed
        // If something else is swiped, they will be unswiped by the delegate
        if !isSwiped && delegate?.swipeLeft(cell: self) ?? false {
            updateConstraintsLeftSwipe()
            isSwiped = true
            trashButton.isHidden = false
            editButton.isHidden = false
            pinButton.isHidden = false
        }
    }
    
    @objc func swipeRight() {
        if isSwiped && !editingTitle {
            delegate?.swipeRight()
            updateConstraintsRightSwipe()
            isSwiped = false
            trashButton.isHidden = true
            editButton.isHidden = true
            pinButton.isHidden = true
            clearTextButton.isHidden = true
        }
    }
    
    @objc func deleteCell() {
        delegate?.deleteCell(cell: self)
    }
    
    @objc func edit() {
        trashButton.isHidden = true
        editButton.isHidden = true
        pinButton.isHidden = true
        clearTextButton.isHidden = false
        
        canEdit = true
        editingTitle = true
        delegate?.prepareForEditing(cell: self)
        titleLabel.becomeFirstResponder()
    }
    
    func finishEdit(){
        editingTitle = false
        canEdit = false
        titleLabel.resignFirstResponder()
        swipeRight()
    }
    
    @objc func pin() {
        delegate?.featureHabit(cell: self)
    }
    
    @objc func clearText() {
        titleLabel.text = ""
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension HabitTrackerOnboardingCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return canEdit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.endEditing()
        return true
    }
}

extension HabitTrackerOnboardingCell: UITextDropDelegate {
    func textDroppableView(_ textDroppableView: UIView & UITextDroppable, proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
        return UITextDropProposal(operation: .cancel)
    }
}
