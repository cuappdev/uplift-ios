//
//  SportsFormBubbleCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 5/24/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFormBubbleCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SportsFormBubbleListDelegate?
    
    private let divider = UIView()
    private let dropdownHeader = DropdownHeaderView(title: "")
    
    private var identifier: String = ""
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropdownHeader.delegate = self
        contentView.addSubview(dropdownHeader)
           
        divider.backgroundColor = .gray01
        contentView.addSubview(divider)
           
        setupConstraints()
    }
    
    func configure(for title: String, list: [String], dropdownStatus: DropdownStatus, identifier: String) {
        dropdownHeader.setTitle(title: title)
        if dropdownStatus == .open {
            dropdownHeader.rotateArrowDown()
        } else {
            dropdownHeader.rotateArrowUp()
        }
        
        self.identifier = identifier
    }
       
    func setupConstraints() {
        let dividerHeight = 1
        let dropdownHeaderHeight = 55
        let horizontalPadding = 16
        
        dropdownHeader.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(dropdownHeaderHeight)
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

extension SportsFormBubbleCollectionViewCell: DropdownHeaderViewDelegate {
    func didTapHeaderView() {
        delegate?.didTapDropdownHeader(identifier: identifier)
    }
}
