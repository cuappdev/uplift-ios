//
//  FacilitiesDropdownCollectionViewCell.swift
//  
//
//  Created by Cameron Hamidi on 11/6/19.
//

import UIKit

class FacilitiesDropdownCollectionViewCell: UICollectionViewCell {
    var collectionView: UICollectionView!
    var collectionViewHeight: CGFloat!
    var dropdownView: DropdownView!
    var facility: Facility!
    var headerImageView: UIImageView!
    var headerNameLabel: UILabel!
    var headerOpenLabel: UILabel!
    var headerView: UIView!
    var headerViewHeight: CGFloat = 52
    var height: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDropdownView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for facility: Facility) {
        self.facility = facility
        setupDropdownView()
        setupConstraints()
    }
    
    func setupDropdownView() {
        headerView = setupHeaderView(headerString: facility.name.uppercased())
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        //TODO: register facility cell classes once they're finished
        
        collectionViewHeight = 0 //TODO: once cell classes are finished, sum up their heights to get the total collection view height
        
        dropdownView = DropdownView(delegate: self,
                                    headerView: headerView,
                                    headerViewHeight: headerViewHeight,
                                    contentView: collectionView,
                                    contentViewHeight: collectionViewHeight)
    }
    
    func setupHeaderView(headerString: String) -> UIView {
        var headerImage: UIImage
        switch headerString {
        case "EQUIPMENT", "FITNESS CENTER":
            headerImage = UIImage(named: ImageNames.equipment)!
        case "GYMNASIUM":
            headerImage = UIImage(named: ImageNames.basketball)!
        case "SWIMMING POOL":
            headerImage = UIImage(named: ImageNames.pool)!
        case "BOWLING LANES":
            headerImage = UIImage(named: ImageNames.bowling)!
        default:
            headerImage = UIImage(named: ImageNames.misc)!
        }
        
        headerView = UIView()
        
        headerImageView = UIImageView(image: headerImage)
        headerView.addSubview(headerImageView)
        
        headerNameLabel = UILabel()
        headerNameLabel.text = headerString
        headerNameLabel.font = ._16MontserratRegular
        headerNameLabel.textColor = .black
        headerNameLabel.textAlignment = .left
        headerView.addSubview(headerImageView)
        
        let facilityOpen = checkFacilityOpen()
        headerOpenLabel = UILabel()
        headerOpenLabel.font = ._16MontserratRegular
        headerOpenLabel.text = facilityOpen ? "Open" : "Closed"
        headerOpenLabel.textColor = facilityOpen ? .accentOpen : .accentClosed
        headerOpenLabel.textAlignment = .center
        headerView.addSubview(headerOpenLabel)
        
        return headerView
    }
    
    func checkFacilityOpen() -> Bool {
        for detail in facility.details {
            if detail.times.count != 0 {
                let today = Date().getIntegerDayOfWeekToday()
                for time in detail.times {
                    if time.dayOfWeek == today {
                        for timeRange in time.timeRanges {
                            let curDate = Date()
                            if curDate > timeRange.openTime && curDate < timeRange.closeTime {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func setupConstraints() {
        let headerImageViewSize: CGFloat = 24
        let headerImageViewLeadingOffset: CGFloat = 25
        let headerImageViewNameLabelSpacing: CGFloat = 9
        let openLabelTrailingOffset: CGFloat = -45
        
        headerImageView.snp.makeConstraints() { make in
            make.height.width.equalTo(headerImageViewSize)
            make.leading.equalToSuperview().offset(headerImageViewLeadingOffset)
            make.centerY.equalToSuperview()
        }
        
        headerNameLabel.snp.makeConstraints() { make in
            make.leading.equalTo(headerImageView.snp.trailing).offset(headerImageViewNameLabelSpacing)
            make.trailing.equalTo(headerOpenLabel.snp.leading).offset(-headerImageViewNameLabelSpacing)
            make.centerY.equalToSuperview()
        }
        
        headerOpenLabel.snp.makeConstraints() { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(openLabelTrailingOffset)
        }
    }
}

extension FacilitiesDropdownCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facility.details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO once facility cells are finished
        return UICollectionViewCell(frame: .zero)
    }
}

extension FacilitiesDropdownCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO once facility cells are finished
        return CGSize(width: 0, height: 0)
    }
}

extension DropdownViewDelegate {
    func dropdownViewClosed(sender dropdownView: DropdownView) {
        return
    }
    
    func dropdownViewOpen(sender dropdownView: DropdownView) {
        return
    }
    
    func dropdownViewHalf(sender dropdownView: DropdownView) {
        return
    }
}
