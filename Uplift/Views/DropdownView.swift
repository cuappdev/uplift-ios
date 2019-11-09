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
    private let contentView: UIView!
    private var contentViewHeight: CGFloat = 0
    weak var delegate: DropdownViewDelegate?
    private var halfCloseDropdownGesture: UITapGestureRecognizer!
    private let halfCloseView: UIView?
    private var halfCloseViewHeight: CGFloat = 0
    private var halfDropdownEnabled: Bool = false
    private var halfHeight: CGFloat = 0
    private var halfOpenDropdownGesture: UITapGestureRecognizer!
    private let halfOpenView: UIView?
    private var halfOpenViewHeight: CGFloat = 0
    private let headerView: UIView!
    private var headerViewHeight: CGFloat = 0
    private var openCloseDropdownGesture: UITapGestureRecognizer!
    private var arrowImageView: UIImageView?
    private var arrowImageViewNeedsConstraints = true

    var contentViewHeightConstraint: Constraint!
    var currentHeight: CGFloat!
    var status: DropdownStatus = .closed

    init(headerView: UIView,
         headerViewHeight: CGFloat,
         contentView: UIView,
         contentViewHeight: CGFloat,
         arrowImageView: UIImageView? = nil,
         halfDropdownEnabled: Bool = false,
         halfOpenView: UIView? = nil,
         halfOpenViewHeight: CGFloat = 0,
         halfCloseView: UIView? = nil,
         halfCloseViewHeight: CGFloat = 0,
         halfHeight: CGFloat = 0) {
        self.headerView = headerView
        self.contentView = contentView
        self.halfOpenView = halfOpenView
        self.halfCloseView = halfCloseView
        super.init(frame: .zero)

        self.headerView.isUserInteractionEnabled = true
        addSubview(self.headerView)

        self.arrowImageView = arrowImageView
        if let arrowView = self.arrowImageView {
            if self.headerView.subviews.contains(arrowView) {
                arrowImageViewNeedsConstraints = false
            } else {
                self.headerView.addSubview(arrowView)
            }
        }

        self.headerViewHeight = headerViewHeight
        currentHeight = headerViewHeight

        openCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.openCloseDropdown(sender:)))
        self.headerView.addGestureRecognizer(openCloseDropdownGesture)

        addSubview(self.contentView)

        currentHeight = headerView.bounds.height
        self.contentViewHeight = contentViewHeight
        self.halfDropdownEnabled = halfDropdownEnabled

        if let halfView = halfOpenView {
            print("here")
            halfView.isHidden = true
            halfOpenDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.openFromHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfOpenDropdownGesture)
            addSubview(halfView)
            halfView.isUserInteractionEnabled = true
        }

        self.halfOpenViewHeight = halfOpenViewHeight

        if let halfView = halfCloseView {
            print("there")
            halfView.isHidden = true
            halfCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfCloseDropdownGesture)
            addSubview(halfView)
            halfView.isUserInteractionEnabled = true
        }

        self.halfCloseViewHeight = halfCloseViewHeight

        self.halfHeight = halfHeight

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        let arrowImageViewHeight: CGFloat = 9
        let arrowImageViewWidth: CGFloat = 5
        let arrowImageViewTrailingOffset: CGFloat = -24
        if arrowImageViewNeedsConstraints { // If constraints have not yet been set on arrowImageView, set some default constraints
            arrowImageView?.snp.makeConstraints { make in
                make.height.equalTo(arrowImageViewHeight)
                make.width.equalTo(arrowImageViewWidth)
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(arrowImageViewTrailingOffset)
            }
        }

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

    // MARK: - Open or close the entire dropdown view
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
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView?.transform = CGAffineTransform(rotationAngle: .pi/2)
            }
        case .open, .half: // Fully close the dropdown view
            status = .closed
            UIView.animate(withDuration: 0.3) {
                self.contentViewHeightConstraint.update(offset: 0)
                self.arrowImageView?.transform = CGAffineTransform(rotationAngle: 0)
                self.layoutIfNeeded()
            }
            halfOpenView?.isHidden = true
            halfCloseView?.isHidden = true
            currentHeight = headerViewHeight
            delegate?.dropdownViewClosed(sender: self)
        }
    }

    // MARK: - Open the entire dropdown view from half open state
    @objc func openFromHalfDropdown(sender: UITapGestureRecognizer) {
        print("here")
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

    // MARK: - Close the dropdown view halfway
    @objc func closeHalfDropdown(sender: UITapGestureRecognizer) {
        print("here")
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
