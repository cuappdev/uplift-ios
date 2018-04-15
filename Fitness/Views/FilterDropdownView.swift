//
//  ClassTypeFilterViewHeader.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

enum Dropped {
    case up, halfDropped, fullDropped
}

class FilterDropdownView: UIView {

    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var rightArrow: UIImageView!
    var downArrow: UIImageView!
    var dropArea: UIView!
    
    var cells: [FilterDropdownCell]!
    var data: [String]!
    var isDropped: Dropped!
    var showAllLabel: UILabel!
    
    var delegate: FilterViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isDropped = .up
        
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
        
        rightArrow = UIImageView(image: #imageLiteral(resourceName: "right_arrow"))
        dropArea.addSubview(rightArrow)
        
        downArrow = UIImageView(image: .none )
        dropArea.addSubview(downArrow)
        
        setupConstraints()
        
        data = ["Zumba", "H.I.I.T.", "Spinning", "Python", "Massage"]
        cells = []
    }
    
    //either removes dropped cells if they exist, or drops down the first three
    @objc func drop( sender:UITapGestureRecognizer){
        if (isDropped == .halfDropped) || (isDropped == .fullDropped) {
            isDropped = .up
            rightArrow.image = #imageLiteral(resourceName: "right_arrow")
            downArrow.image = .none
            while cells.count > 0{
                let cell = cells.popLast()
                cell!.removeFromSuperview()
            }
            showAllLabel.removeFromSuperview()
            delegate.setupConstraints()
        }else{
            isDropped = .halfDropped
            rightArrow.image = .none
            downArrow.image = #imageLiteral(resourceName: "down_arrow")
            var count = 0
            for name in data[0 ..< 3] {
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
            
            delegate.setupConstraints()
            
            showAllLabel = UILabel()
            showAllLabel.text = "Show All Class Types"
            showAllLabel.font = ._12MontserratMedium
            showAllLabel.sizeToFit()
            showAllLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropAll(sender:) ))
            showAllLabel.addGestureRecognizer(gesture)
            showAllLabel.isUserInteractionEnabled = true
            addSubview(showAllLabel)
            
           
            showAllLabel.snp.updateConstraints{make in
                make.bottom.equalToSuperview().offset(-16)
                make.left.equalToSuperview().offset(16)
            }
            
        }
    }
    
    //displays all cells
    @objc func dropAll( sender:UITapGestureRecognizer){
        
        if (isDropped == .halfDropped){
        
            isDropped = .fullDropped
        
            var count = 3
            for name in data.suffix(from: 3) {
                let cell = FilterDropdownCell(frame: .zero)
                cell.titleLabel.text = name
                addSubview(cell)
                cells.append(cell)
                
                cell.snp.updateConstraints{make in
                    make.top.equalTo(cells[count - 1].snp.bottom)
                    make.bottom.equalTo(cells[count - 1].snp.bottom).offset(32)
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
                
                count += 1
            }
            showAllLabel.text = "Hide"
            delegate.setupConstraints()
            
        }else {
            isDropped = .halfDropped
            while cells.count != 3 {
                let cell = cells.popLast()
                cell!.removeFromSuperview()
            }
            showAllLabel.text = "Show All Class Types"
            delegate.setupConstraints()
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
            make.bottom.equalTo(dropArea.snp.top).offset(55)
        }
        
        titleLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rightArrow.snp.updateConstraints{make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.right.equalToSuperview().offset(-31)
            make.left.equalTo(rightArrow.snp.right).offset(-8)
        }
        
        downArrow.snp.updateConstraints{make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(6)
            make.right.equalToSuperview().offset(-29)
            make.left.equalTo(rightArrow.snp.right).offset(-12)
        }
    }
}
