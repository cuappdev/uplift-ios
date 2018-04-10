//
//  ClassTypeFilterViewHeader.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FilterDropdownView: UIView {

    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var dropIcon: UIImageView!
    var dropArea: UIView!
    
    var cells: [FilterDropdownCell]!
    var data: [String]!
    var isDropped: Bool!
    var showAllButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isDropped = false
        
        dropArea = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.drop(sender:) ))
        self.dropArea.addGestureRecognizer(gesture)
        dropArea.frame.size.height = 49.0
        addSubview(dropArea)
        
        titleLabel = UILabel()
        titleLabel.font = ._12LatoBlack
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.sizeToFit()
        dropArea.addSubview(titleLabel)
        
        dropIcon = UIImageView(image: #imageLiteral(resourceName: "grey-star")) //replace with proper image
        dropArea.addSubview(dropIcon)
        
        setupConstraints()
        
        data = ["Zumba", "H.I.I.T.", "Spinning"]
        cells = []
    }
    
    @objc func drop( sender:UITapGestureRecognizer){
        print("drop!")
        if isDropped {
            isDropped = false
            while cells.count > 0{
                let cell = cells.popLast()
                cell!.removeFromSuperview()
            }
        }else{
            isDropped = true
            var count = 0
            for name in data {
                let cell = FilterDropdownCell(frame: .zero)
                cell.titleLabel.text = name
                addSubview(cell)
                cells.append(cell)
                
                cell.snp.updateConstraints{make in
                    if (count == 0){
                        make.top.equalTo(dropArea.snp.bottom)
                        make.bottom.equalTo(dropArea.snp.bottom).offset(32)
                    }else{
                        make.top.equalTo(cells[count - 1].snp.bottom)
                        make.bottom.equalTo(cells[count - 1].snp.bottom).offset(32)
                    }
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
                count += 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        dropArea.snp.updateConstraints{make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        titleLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        dropIcon.snp.updateConstraints{make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.right.equalToSuperview().offset(-38)
        }
    }
}
