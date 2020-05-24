//
//  SportsFormTimeCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 5/24/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFormTimeCollectionViewCell: UICollectionViewCell {

    private let atLabel = UILabel()
    private let divider = UIView()
    
    private let datePicker = UIDatePicker()
    private let dateTextField = PaddedTextField()
    
    private let timePicker = UIDatePicker()
    private let timeTextField = PaddedTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        atLabel.text = "at"
        atLabel.font = ._16MontserratMedium
        atLabel.textColor = .primaryBlack
        contentView.addSubview(atLabel)
        
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.font = ._16MontserratMedium
        dateTextField.placeholder = "Today, April 10th 2020"
        dateTextField.textColor = .primaryBlack
        dateTextField.layer.borderColor = UIColor.gray01.cgColor
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.cornerRadius = 10
        dateTextField.layer.masksToBounds = true
        dateTextField.inputView = datePicker
        dateTextField.text = Date.getLongDateStringFromDate(date: Date())
        dateTextField.tintColor = .clear
        contentView.addSubview(dateTextField)
        
        timePicker.backgroundColor = .white
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanged(datePicker:)), for: .valueChanged)
        
        timeTextField.font = ._16MontserratMedium
        timeTextField.placeholder = "6:00PM"
        timeTextField.textColor = .primaryBlack
        timeTextField.layer.borderColor = UIColor.gray01.cgColor
        timeTextField.layer.borderWidth = 1
        timeTextField.layer.cornerRadius = 10
        timeTextField.layer.masksToBounds = true
        timeTextField.inputView = timePicker
        timeTextField.text = Date.getTimeStringFromDate(time: Date())
        timeTextField.tintColor = .clear
        timeTextField.textAlignment = .center
        contentView.addSubview(timeTextField)
        
        divider.backgroundColor = .gray01
        contentView.addSubview(divider)
           
        setupConstraints()
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateTextField.text = Date.getLongDateStringFromDate(date: datePicker.date)
    }
    
    @objc func timeChanged(datePicker: UIDatePicker) {
        timeTextField.text = Date.getTimeStringFromDate(time: datePicker.date)
    }
       
    func setupConstraints() {
        let dateTextFieldWidth = 196
        let dividerHeight = 1
        let horizontalPadding = 16
        let textFieldHeight = 36
        let timeTextFieldWidth = 88
        
        dateTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(textFieldHeight)
            make.width.equalTo(dateTextFieldWidth)
        }
        
        atLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dateTextField.snp.trailing).offset(horizontalPadding)
        }
        
        timeTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(atLabel.snp.trailing).offset(horizontalPadding)
            make.height.equalTo(textFieldHeight)
            make.width.equalTo(timeTextFieldWidth)
            
        }
           
        divider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(dividerHeight)
        }
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
