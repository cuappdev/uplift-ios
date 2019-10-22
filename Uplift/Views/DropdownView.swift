//
//  DropdownView.swift
//  
//
//  Created by Cameron Hamidi on 10/7/19.
//

import Foundation
import UIKit

enum DropdownStatus {
    case up, half, down
}

enum DropdownDirection {
    case horizontal, vertical
}

protocol DropdownViewDelegate {
    func collapseDropdownView(sender dropdownView: DropdownView)
    func collapseDropdownViewHalf(sender dropdownView: DropdownView)
    func expandDropdownViewFull(sender dropdownView: DropdownView)
    func expandDropdownViewHalf(sender dropdownView: DropdownView)
}

class DropdownView: UIView {
    var collapseHalfDropdownGesture: UITapGestureRecognizer!
    var contentView: UIView!
    var contentViewBottomConstraint: NSLayoutConstraint!
    var contentViewHeight: CGFloat!
    var contentViewHeightConstraint: NSLayoutConstraint!
    var currentHeight: CGFloat!
    var delegate: DropdownViewDelegate!
    var expandCollapseDropdownGesture: UITapGestureRecognizer!
    var expandFromHalfDropdownGesture: UITapGestureRecognizer!
    var halfCollapseView: UIView?
    var halfCollapseViewHeight: CGFloat!
    var halfDropdownEnabled: Bool!
    var halfExpandView: UIView?
    var halfExpandViewHeight: CGFloat!
    var halfHeight: CGFloat!
    var headerView: UIView!
    var headerViewHeight: CGFloat!
    var status: DropdownStatus = .up
    
    init(headerView: UIView, headerViewHeight: CGFloat, contentView: UIView, contentViewHeight: CGFloat, halfDropdownEnabled: Bool = false, halfExpandView: UIView? = nil, halfExpandViewHeight: CGFloat = 0, halfCollapseView: UIView? = nil, halfCollapseViewHeight: CGFloat = 0, halfHeight: CGFloat = 0) {
        super.init(frame: .zero)
        
        self.headerView = headerView
        self.headerView.isUserInteractionEnabled = true
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.headerView)
        
        self.headerViewHeight = headerViewHeight
        currentHeight = headerViewHeight
        
        expandCollapseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.expandCollapseDropdown(sender:) ))
        self.headerView.addGestureRecognizer(expandCollapseDropdownGesture)
        
        self.contentView = contentView
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.contentView)
        
        currentHeight = headerView.bounds.height
        
        self.contentViewHeight = contentViewHeight
        
        self.halfDropdownEnabled = halfDropdownEnabled
        
        if let halfView = halfExpandView {
            self.halfExpandView = halfView
            self.halfExpandView!.translatesAutoresizingMaskIntoConstraints = false
            self.halfExpandView!.isHidden = true
            self.halfExpandView?.isUserInteractionEnabled = true
            addSubview(self.halfExpandView!)
            expandFromHalfDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.expandFromHalfDropdown(sender:) ))
            halfView.addGestureRecognizer(expandFromHalfDropdownGesture)
        }
        
        self.halfExpandViewHeight = halfExpandViewHeight
        
        if let halfView = halfCollapseView {
            self.halfCollapseView = halfView
            self.halfCollapseView!.isHidden = true
            self.halfCollapseView!.isUserInteractionEnabled = true
            self.halfCollapseView!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(self.halfCollapseView!)
            collapseHalfDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.collapseHalfDropdown(sender:) ))
            halfView.addGestureRecognizer(collapseHalfDropdownGesture)
        }
        
        self.halfCollapseViewHeight = halfCollapseViewHeight
        
        self.halfHeight = halfHeight
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        if halfDropdownEnabled {
            NSLayoutConstraint.activate([
                halfExpandView!.topAnchor.constraint(equalTo: contentView.bottomAnchor),
                halfExpandView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                halfExpandView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                halfExpandView!.heightAnchor.constraint(equalToConstant: halfExpandViewHeight),
                halfCollapseView!.topAnchor.constraint(equalTo: contentView.bottomAnchor),
                halfCollapseView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                halfCollapseView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                halfCollapseView!.heightAnchor.constraint(equalToConstant: halfCollapseViewHeight)
            ])
        }
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeightConstraint.isActive = true
    }
    
    @objc func expandCollapseDropdown(sender: UITapGestureRecognizer) {
        switch status{
        case .up:
            if halfDropdownEnabled {
                status = .half
                halfExpandView?.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.constant = CGFloat(self.halfHeight)
                    self.layoutIfNeeded()
                }
                currentHeight = headerViewHeight + halfExpandViewHeight + halfHeight
                delegate.expandDropdownViewHalf(sender: self)
            } else {
                status = .down
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.constant = CGFloat(self.contentViewHeight)
                    self.layoutIfNeeded()
                }
                currentHeight = headerViewHeight + contentViewHeight
                delegate.expandDropdownViewFull(sender: self)
            }
        case .down, .half:
            status = .up
            UIView.animate(withDuration: 0.3) {
                self.contentViewHeightConstraint.constant = CGFloat(0.0)
                self.layoutIfNeeded()
            }
            halfExpandView?.isHidden = true
            halfCollapseView?.isHidden = true
            currentHeight = headerViewHeight
            delegate.collapseDropdownView(sender: self)
        }
    }
    
    @objc func expandFromHalfDropdown(sender: UITapGestureRecognizer) {
        status = .down
        halfExpandView?.isHidden = true
        halfCollapseView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeightConstraint.constant = CGFloat(self.contentViewHeight)
            self.layoutIfNeeded()
        }
        currentHeight = headerViewHeight + contentViewHeight + halfCollapseViewHeight
        delegate.expandDropdownViewFull(sender: self)
    }
    
    @objc func collapseHalfDropdown(sender:UITapGestureRecognizer) {
        status = .half
        halfExpandView?.isHidden = false
        halfCollapseView?.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeightConstraint.constant = CGFloat(self.halfHeight)
            self.layoutIfNeeded()
        }
        currentHeight = headerViewHeight + halfExpandViewHeight + halfHeight
        delegate.collapseDropdownViewHalf(sender: self)
    }
    
    
}
