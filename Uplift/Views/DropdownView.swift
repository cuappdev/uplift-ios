//
//  DropdownView.swift
//  
//
//  Created by Cameron Hamidi on 10/7/19.
//

import Foundation
import UIKit
import SnapKit

enum DropdownStatus {
    case closed, half, open
}

enum DropdownDirection {
    case horizontal, vertical
}

protocol DropdownViewDelegate {
    func dropdownViewClosed(sender dropdownView: DropdownView)
    func dropdownViewOpen(sender dropdownView: DropdownView)
    func dropdownViewHalf(sender dropdownView: DropdownView)
}

class DropdownView: UIView {
    
    private var contentView: UIView!
    private var contentViewHeight: CGFloat!
    var contentViewHeightConstraint: Constraint!
    var currentHeight: CGFloat!
    private var delegate: DropdownViewDelegate!
    private var expandCollapseDropdownGesture: UITapGestureRecognizer!
    private var halfCollapseDropdownGesture: UITapGestureRecognizer!
    private var halfCollapseView: UIView?
    private var halfCollapseViewHeight: CGFloat!
    private var halfDropdownEnabled: Bool!
    private var halfExpandDropdownGesture: UITapGestureRecognizer!
    private var halfExpandView: UIView?
    private var halfExpandViewHeight: CGFloat!
    private var halfHeight: CGFloat!
    private var headerView: UIView!
    private var headerViewHeight: CGFloat!
    var status: DropdownStatus = .closed
    
    init(headerView: UIView,
         headerViewHeight: CGFloat,
         contentView: UIView,
         contentViewHeight: CGFloat,
         halfDropdownEnabled: Bool = false,
         halfExpandView: UIView? = nil,
         halfExpandViewHeight: CGFloat = 0,
         halfCollapseView: UIView? = nil,
         halfCollapseViewHeight: CGFloat = 0,
         halfHeight: CGFloat = 0) {
        super.init(frame: .zero)
        
        self.headerView = headerView
        self.headerView.isUserInteractionEnabled = true
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.headerView)
        
        self.headerViewHeight = headerViewHeight
        currentHeight = headerViewHeight
        
        expandCollapseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.expandCollapseDropdown(sender:)))
        self.headerView.addGestureRecognizer(expandCollapseDropdownGesture)
        
        self.contentView = contentView
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.contentView)
        
        currentHeight = headerView.bounds.height
        
        self.contentViewHeight = contentViewHeight
        
        self.halfDropdownEnabled = halfDropdownEnabled
        
        if let halfView = halfExpandView {
            self.halfExpandView = halfView
            halfView.translatesAutoresizingMaskIntoConstraints = false
            halfView.isHidden = true
            halfView.isUserInteractionEnabled = true
            addSubview(halfView)
            halfExpandDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.expandFromHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfExpandDropdownGesture)
        }
        
        self.halfExpandViewHeight = halfExpandViewHeight
        
        if let halfView = halfCollapseView {
            self.halfCollapseView = halfView
            halfView.translatesAutoresizingMaskIntoConstraints = false
            halfView.isHidden = true
            halfView.isUserInteractionEnabled = true
            addSubview(halfView)
            halfCollapseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.collapseHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfCollapseDropdownGesture)
        }
        
        self.halfCollapseViewHeight = halfCollapseViewHeight
        
        self.halfHeight = halfHeight
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            self.contentViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        if halfDropdownEnabled,
            let halfExpand = halfExpandView,
            let halfCollapse = halfCollapseView {
                halfExpand.snp.makeConstraints { make in
                    make.top.equalTo(contentView.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(halfExpandViewHeight)
            }
            
            halfCollapse.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(halfCollapseViewHeight)
            }
        }
    }
    
    @objc func expandCollapseDropdown(sender: UITapGestureRecognizer) {
        switch status {
        case .closed: // If the dropdown view is currently closed, open it to some degree
            if halfDropdownEnabled { // If the user has enabled the half dropdown state, open to the half state
                status = .half
                halfExpandView?.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.update(offset: self.halfHeight)
                    self.layoutIfNeeded()
                }
                currentHeight = headerViewHeight + halfExpandViewHeight + halfHeight
                delegate.dropdownViewHalf(sender: self)
            } else { // Since the user has not enabled the half dropdown state, fully open the dropdown
                status = .open
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.update(offset: self.contentViewHeight)
                    self.layoutIfNeeded()
                }
                currentHeight = headerViewHeight + contentViewHeight
                delegate.dropdownViewOpen(sender: self)
            }
        case .open, .half: // Fully close the dropdown view
            status = .closed
            UIView.animate(withDuration: 0.3) {
                self.contentViewHeightConstraint.update(offset: 0)
                self.layoutIfNeeded()
            }
            halfExpandView?.isHidden = true
            halfCollapseView?.isHidden = true
            currentHeight = headerViewHeight
            delegate.dropdownViewClosed(sender: self)
        }
    }
    
    @objc func expandFromHalfDropdown(sender: UITapGestureRecognizer) {
        status = .open
        halfExpandView?.isHidden = true
        halfCollapseView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeightConstraint.update(offset: self.contentViewHeight)
            self.layoutIfNeeded()
        }
        currentHeight = headerViewHeight + contentViewHeight + halfCollapseViewHeight
        delegate.dropdownViewOpen(sender: self)
    }
    
    @objc func collapseHalfDropdown(sender:UITapGestureRecognizer) {
        status = .half
        halfExpandView?.isHidden = false
        halfCollapseView?.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeightConstraint.update(offset: self.halfHeight)
            self.layoutIfNeeded()
        }
        currentHeight = headerViewHeight + halfExpandViewHeight + halfHeight
        delegate.dropdownViewHalf(sender: self)
    }
    
}
