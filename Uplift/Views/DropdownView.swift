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

protocol DropdownViewDelegate: class {
    func dropdownViewClosed(sender dropdownView: DropdownView)
    func dropdownViewOpen(sender dropdownView: DropdownView)
    func dropdownViewHalf(sender dropdownView: DropdownView)
}

class DropdownView: UIView {

    // MARK: - INITIALIZATION
    private var contentView: UIView!
    private var contentViewHeight: CGFloat = 0
    private weak var delegate: DropdownViewDelegate?
    private var halfCloseDropdownGesture: UITapGestureRecognizer!
    private var halfCloseView: UIView?
    private var halfCloseViewHeight: CGFloat = 0
    private var halfDropdownEnabled: Bool = false
    private var halfHeight: CGFloat = 0
    private var halfOpenDropdownGesture: UITapGestureRecognizer!
    private var halfOpenView: UIView?
    private var halfOpenViewHeight: CGFloat = 0
    private var headerView: UIView!
    private var headerViewHeight: CGFloat = 0
    private var openCloseDropdownGesture: UITapGestureRecognizer!

    var contentViewHeightConstraint: Constraint!
    var currentHeight: CGFloat!
    var status: DropdownStatus = .closed

    init(headerView: UIView,
         headerViewHeight: CGFloat,
         contentView: UIView,
         contentViewHeight: CGFloat,
         halfDropdownEnabled: Bool = false,
         halfOpenView: UIView? = nil,
         halfOpenViewHeight: CGFloat = 0,
         halfCloseView: UIView? = nil,
         halfCloseViewHeight: CGFloat = 0,
         halfHeight: CGFloat = 0) {
        super.init(frame: .zero)
        
        self.headerView = headerView
        self.headerView.isUserInteractionEnabled = true
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.headerView)
        
        self.headerViewHeight = headerViewHeight
        currentHeight = headerViewHeight
        
        openCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.openCloseDropdown(sender:)))
        self.headerView.addGestureRecognizer(openCloseDropdownGesture)
        
        self.contentView = contentView
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.contentView)
        
        currentHeight = headerView.bounds.height
        self.contentViewHeight = contentViewHeight
        self.halfDropdownEnabled = halfDropdownEnabled

        if let halfView = halfOpenView {
            self.halfOpenView = halfView
            halfView.translatesAutoresizingMaskIntoConstraints = false
            halfView.isHidden = true
            halfView.isUserInteractionEnabled = true
            halfOpenDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.openFromHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfOpenDropdownGesture)
            addSubview(halfView)
        }

        self.halfOpenViewHeight = halfOpenViewHeight
        
        if let halfView = halfCloseView {
            self.halfCloseView = halfView
            halfView.translatesAutoresizingMaskIntoConstraints = false
            halfView.isHidden = true
            halfView.isUserInteractionEnabled = true
            halfCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfCloseDropdownGesture)
            addSubview(halfView)
        }
        
        self.halfCloseViewHeight = halfCloseViewHeight

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
            let halfOpen = halfOpenView,
            let halfClose = halfCloseView {
                halfOpen.snp.makeConstraints { make in
                    make.top.equalTo(contentView.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(halfOpenViewHeight)
            }

            halfClose.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(halfCloseViewHeight)
            }
        }
    }
    
    // MARK - Open or close the entire dropdown view
    @objc func openCloseDropdown(sender: UITapGestureRecognizer) {
        switch status {
        case .closed: // If the dropdown view is currently closed, open it to some degree
            if halfDropdownEnabled { // If the user has enabled the half dropdown state, open to the half state
                status = .half
                halfOpenView?.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.update(offset: self.halfHeight)
                    self.layoutIfNeeded()
                }
                currentHeight = headerViewHeight + halfOpenViewHeight + halfHeight
                delegate?.dropdownViewHalf(sender: self)
            } else { // Since the user has not enabled the half dropdown state, fully open the dropdown
                status = .open
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.update(offset: self.contentViewHeight)
                    self.layoutIfNeeded()
                }
                currentHeight = headerViewHeight + contentViewHeight
                delegate?.dropdownViewOpen(sender: self)
            }
        case .open, .half: // Fully close the dropdown view
            status = .closed
            UIView.animate(withDuration: 0.3) {
                self.contentViewHeightConstraint.update(offset: 0)
                self.layoutIfNeeded()
            }
            halfOpenView?.isHidden = true
            halfCloseView?.isHidden = true
            currentHeight = headerViewHeight
            delegate?.dropdownViewClosed(sender: self)
        }
    }

    // MARK - Open the entire dropdown view from
    @objc func openFromHalfDropdown(sender: UITapGestureRecognizer) {
        status = .open
        halfOpenView?.isHidden = true
        halfCloseView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeightConstraint.update(offset: self.contentViewHeight)
            self.layoutIfNeeded()
        }
        currentHeight = headerViewHeight + contentViewHeight + halfCloseViewHeight
        delegate?.dropdownViewOpen(sender: self)
    }

    @objc func closeHalfDropdown(sender: UITapGestureRecognizer) {
        status = .half
        halfOpenView?.isHidden = false
        halfCloseView?.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeightConstraint.update(offset: self.halfHeight)
            self.layoutIfNeeded()
        }
        currentHeight = headerViewHeight + halfOpenViewHeight + halfHeight
        delegate?.dropdownViewHalf(sender: self)
    }

}
