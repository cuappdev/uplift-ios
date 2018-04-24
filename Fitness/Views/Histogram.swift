//
//  Histogram.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/23/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
//  Creates a histogram styled after the gym-detail-view histogram
//  on zeplin. Has data.count bars with ticks in bewteen
//  Must be initialized with the suspected frame width to correctly
//  function.

import UIKit
import SnapKit

class Histogram: UIView {

    //MARK: - INITIALIZATION
    var data: [Int]!
    var bars: [UIView]!
    
    var selectedIndex: Int!     //index of bars representing the bar that is currently selected. Must be in range 0..bars.count-1
    var selectedLine: UIView!
    var selectedTime: UILabel!
    var timeDescriptorLabel: UILabel!
    
    var bottomAxis: UIView!
    var bottomAxisTicks: [UIView]!
    
    init(frame: CGRect, data: [Int]) {
        super.init(frame: frame)
        self.data = data
        
        //AXIS
        bottomAxis = UIView()
        bottomAxis.backgroundColor = .fitnessLightGrey
        addSubview(bottomAxis)
        
        bottomAxisTicks = []
        for _ in 0..<(data.count - 1){
            let tick = UIView()
            tick.backgroundColor = .fitnessLightGrey
            addSubview(tick)
            bottomAxisTicks.append(tick)
        }
        
        //BARS
        bars = []
        for _ in data{
            let bar = UIView()
            bar.backgroundColor = .fitnessYellow
            addSubview(bar)
            bars.append(bar)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.selectBar(sender:)))
            bar.addGestureRecognizer(gesture)
        }
        selectedIndex = Int(data.count/2)
        bars[selectedIndex].backgroundColor = UIColor(red: 216/255, green: 200/255, blue: 0, alpha: 1.0)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONSTRAINTS
    func setupConstraints() {
        //AXIS
        bottomAxis.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(2)
        }
    
        let tickSpacing = (Int(frame.width) - bottomAxisTicks.count*2 + 4)/(bottomAxisTicks.count + 1)
        for i in 0..<bottomAxisTicks.count{
            
            let tick = bottomAxisTicks[i]
            
            tick.snp.updateConstraints{make in
                if (i == 0){
                    make.left.equalToSuperview().offset(tickSpacing)
                }else{
                    make.left.equalTo(bottomAxisTicks[i - 1].snp.right).offset(tickSpacing)
                }
                make.top.equalTo(bottomAxis.snp.top)
                make.width.equalTo(2)
                make.height.equalTo(3)
            }
        }
        
        //BARS
        for i in 0..<bars.count {
            
            let bar = bars[i]
            
            bar.snp.updateConstraints{make in
                make.bottom.equalTo(bottomAxis.snp.top)
                if(i == 0){
                    make.left.equalToSuperview().offset(2)
                    make.right.equalTo(bottomAxisTicks[i].snp.left)
                }else if (i == bars.count - 1){
                    make.right.equalToSuperview().offset(-2)
                    make.left.equalTo(bottomAxisTicks[i - 1].snp.right)
                }else{
                    make.left.equalTo(bottomAxisTicks[i - 1].snp.right)
                    make.right.equalTo(bottomAxisTicks[i].snp.left)
                }
                let height = 72*(data[i])/100
                make.height.equalTo(height)
            }
        }
        
        
    }
    
    
    
    @objc func selectBar( sender:UITapGestureRecognizer){
        bars[selectedIndex].backgroundColor = .fitnessYellow
        let selectedBar = sender.view!
        selectedBar.backgroundColor = UIColor(red: 216/255, green: 200/255, blue: 0, alpha: 1.0)
        
        for i in 0..<bars.count{
            if selectedBar == bars[i]{
                selectedIndex = i
                break
            }
        }
        
    }
}
