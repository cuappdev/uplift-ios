//
//  HabitTrackerOnboardingCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 3/11/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
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

private enum FileConstants {
    static let normalDotsLeadingPadding = 35
    static let swipedDotsLeadingPadding = 15

    static let editingTitleLabelTrailingPadding = 50
    static let normalTitleLabelTrailingPadding = 21
    static let swipedTitleLabelTrailingPadding = 145
}

class HabitTrackerOnboardingCell: UITableViewCell {

    // MARK: - INITIALIZATION
    static let height = 54
    static let identifier = Identifiers.habitTrackerOnboardingCell

    weak var delegate: HabitTrackerOnboardingDelegate!

    private var dotsImage: UIImageView!
    var titleLabel: UITextField!
    var separator: UIView!

    private var trashButton: UIButton!
    private var editButton: UIButton!
    private var pinButton: UIButton!
    
    private var clearTextButton: UIButton!
    
    private var isSwiped: Bool!
    private var canEdit: Bool!
    private var editingTitle: Bool!
    
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
        titleLabel.font = ._16MontserratMedium
        titleLabel.textAlignment = .left
        titleLabel.textColor = .primaryBlack
        titleLabel.sizeToFit()
        titleLabel.delegate = self
        titleLabel.textDropDelegate = self
        titleLabel.keyboardType = .alphabet
        contentView.addSubview(titleLabel)
   
        // SEPARATOR
        separator = UIView()
        separator.backgroundColor = .gray01
        contentView.addSubview(separator)
   
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

    override func prepareForReuse() {
        super.prepareForReuse()
        separator.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    private func setupConstraints() {
        let buttonSize = 38
        let buttonSpacing = 6
        let buttonTrailingPadding = 16
        let separatorHeight = 1
        let separatorInset = 24

        dotsImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(FileConstants.normalDotsLeadingPadding)
            make.width.equalTo(8)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotsImage.snp.trailing).offset(10)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(FileConstants.normalTitleLabelTrailingPadding)
        }

        pinButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.trailing.equalToSuperview().inset(buttonTrailingPadding)
            make.centerY.equalToSuperview()
        }

        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.trailing.equalTo(pinButton.snp.leading).offset(-buttonSpacing)
            make.centerY.equalToSuperview()
        }

        trashButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
            make.trailing.equalTo(editButton.snp.leading).offset(-buttonSpacing)
            make.centerY.equalToSuperview()
        }

        clearTextButton.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.trailing.equalToSuperview().inset(buttonTrailingPadding)
            make.centerY.equalToSuperview()
        }

        separator.snp.makeConstraints { make in
            make.height.equalTo(separatorHeight)
            make.leading.trailing.equalToSuperview().inset(separatorInset)
            make.bottom.equalToSuperview()
        }
    }

    private func updateConstraintsLeftSwipe() {
        dotsImage.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset(FileConstants.swipedDotsLeadingPadding)
        }

        titleLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(FileConstants.swipedTitleLabelTrailingPadding)
        }
    }

    private func updateConstraintsRightSwipe() {
        dotsImage.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset(FileConstants.normalDotsLeadingPadding)
        }

        titleLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(FileConstants.normalTitleLabelTrailingPadding)
        }
    }

    private func updateConstraintsEdit() {
        titleLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(FileConstants.editingTitleLabelTrailingPadding)
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

            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                self.dotsImage.frame.origin.x = self.dotsImage.frame.minX - 15
                self.titleLabel.frame.origin.x = self.titleLabel.frame.minX - 15

                self.trashButton.isHidden = false
                self.editButton.isHidden = false
                self.pinButton.isHidden = false

                self.updateConstraintsLeftSwipe()
            }, completion: nil)

            isSwiped = true
        }
    }

    @objc func swipeRight() {
        if isSwiped && !editingTitle {
            delegate?.swipeRight()
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                self.dotsImage.frame.origin.x = self.dotsImage.frame.minX + 15
                self.titleLabel.frame.origin.x = self.titleLabel.frame.minX + 15

                self.trashButton.isHidden = true
                self.editButton.isHidden = true
                self.pinButton.isHidden = true
                self.clearTextButton.isHidden = true

                self.updateConstraintsRightSwipe()
            }, completion: nil)

            isSwiped = false
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

        updateConstraintsEdit()

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
