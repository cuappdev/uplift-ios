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
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let sportsFormBubbleListItemIdentifier = "sportsFormBubbleListItemIdentifier"
    
    private var identifier: String = ""
    private var list: [BubbleItem] = []
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropdownHeader.delegate = self
        contentView.addSubview(dropdownHeader)
           
        divider.backgroundColor = .gray01
        contentView.addSubview(divider)
        
        tableView.register(SportsFormBubbleTableViewCell.self, forCellReuseIdentifier: sportsFormBubbleListItemIdentifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
           
        setupConstraints()
    }
    
    func configure(for title: String, list: [BubbleItem], dropdownStatus: DropdownStatus, identifier: String) {
        dropdownHeader.setTitle(title: title)
        if dropdownStatus == .open {
            dropdownHeader.rotateArrowDown()
        } else {
            dropdownHeader.rotateArrowUp()
        }
        
        self.identifier = identifier
        self.list = list
        
        self.tableView.reloadData()
    }
       
    func setupConstraints() {
        let dividerHeight = 1
        let dropdownHeaderHeight = 55
        
        dropdownHeader.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(dropdownHeaderHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dropdownHeader.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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

extension SportsFormBubbleCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sportsFormBubbleListItemIdentifier, for: indexPath) as! SportsFormBubbleTableViewCell
        let item = list[indexPath.row]
        cell.configure(for: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: backend request - POST.
    }
}

extension SportsFormBubbleCollectionViewCell: DropdownHeaderViewDelegate {
    func didTapHeaderView() {
        delegate?.didTapDropdownHeader(identifier: identifier)
    }
}
