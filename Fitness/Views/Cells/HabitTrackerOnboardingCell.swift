//
//  HabitTrackerOnboardingCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/11/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

protocol HabitTrackerOnboardingDelegate: class {
    func deleteCell(indexPath: IndexPath)
    func prepareForEditing(indexPath: IndexPath)
    func swipeLeft(indexPath: IndexPath) -> Bool
    func swipeRight()
}


class HabitTrackerOnboardingCell: UITableViewCell {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.habitTrackerOnboardingCell
    static let height = 40 // TODO: CORRECT THIS VALUE
    
    weak var delegate: HabitTrackerOnboardingDelegate!

    var dotsImage: UIImageView!
    var titleLabel: UITextField!
    var isSwiped: Bool!
    
    var trashButton: UIButton!
    var editButton: UIButton!
    var pinButton: UIButton!
    
    var clearTextButton: UIButton!
    
    var indexPath: IndexPath!
    var canEdit: Bool!
    var editingTitle: Bool!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // TODO - GET IMAGE, UPDATE WIDTH/HEIGHT IN CONSTRAINTS
        dotsImage = UIImageView(image: UIImage(named: "x"))
        contentView.addSubview(dotsImage)
        
        titleLabel = UITextField()
        titleLabel.font = ._14MontserratRegular
        titleLabel.textAlignment = .left
        titleLabel.textColor = .fitnessBlack
        titleLabel.sizeToFit()
        titleLabel.delegate = self
        contentView.addSubview(titleLabel)
        
        isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
        
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
        dotsImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35)
            make.width.equalTo(10)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        
        // TODO - FIX THESE
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotsImage.snp.trailing).offset(10)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-21)
        }
        
        pinButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-21)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalTo(pinButton.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
        }
        
        trashButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
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
    }
    
    func updateConstraintsRightSwipe() {
        dotsImage.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(35)
        }
    }
    
    func setTitle(activity: String) {
        titleLabel.text = activity
    }
    
    // MARK: - BUTTON AND GESTURE METHODS
    @objc func swipeLeft() {
        if !isSwiped && delegate?.swipeLeft(indexPath: indexPath) ?? false {
            updateConstraintsLeftSwipe()
            isSwiped = true
            trashButton.isHidden = false
            editButton.isHidden = false
            pinButton.isHidden = false
        }
    }
    
    // unless editing, swipe will succeed, if something else is swiped, it will be unswiped
    
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
        if let delegate = delegate {
            delegate.deleteCell(indexPath: indexPath)
        }
    }
    
    @objc func edit() {
        trashButton.isHidden = true
        editButton.isHidden = true
        pinButton.isHidden = true
        clearTextButton.isHidden = false
        
        canEdit = true
        editingTitle = true
        delegate?.prepareForEditing(indexPath: indexPath)
        titleLabel.becomeFirstResponder()
    }
    
    func finishEdit(){
        editingTitle = false
        titleLabel.resignFirstResponder()
        swipeRight()
    }
    
    @objc func pin() {
        
    }
    
    @objc func clearText() {
        titleLabel.text = ""
    }
}


extension HabitTrackerOnboardingCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return canEdit
    }
    
}
