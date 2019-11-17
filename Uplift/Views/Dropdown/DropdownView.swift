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
    private let halfCloseView: UIView?
    private let halfOpenView: UIView?
    private let headerView: UIView!

    private var contentViewHeight: CGFloat = 0
<<<<<<< HEAD:Uplift/Views/DropdownView.swift
=======
    weak var delegate: DropdownViewDelegate?
>>>>>>> 87428c2db55e53f3305a5e05d544901b7e3d7e49:Uplift/Views/Dropdown/DropdownView.swift
    private var halfCloseDropdownGesture: UITapGestureRecognizer!
    private var halfCloseViewHeight: CGFloat = 0
    private var halfDropdownEnabled: Bool = false
    private var halfHeight: CGFloat = 0
    private var halfOpenDropdownGesture: UITapGestureRecognizer!
    private var halfOpenViewHeight: CGFloat = 0
<<<<<<< HEAD:Uplift/Views/DropdownView.swift
=======
    private let headerView: DropdownHeaderView!
>>>>>>> 87428c2db55e53f3305a5e05d544901b7e3d7e49:Uplift/Views/Dropdown/DropdownView.swift
    private var headerViewHeight: CGFloat = 0
    private var openCloseDropdownGesture: UITapGestureRecognizer!
    private weak var delegate: DropdownViewDelegate?

    var contentViewHeightConstraint: Constraint!
    var currentHeight: CGFloat!
    var status: DropdownStatus = .closed

<<<<<<< HEAD:Uplift/Views/DropdownView.swift
    init(delegate: DropdownViewDelegate,
         headerView: UIView,
=======
    init(headerView: DropdownHeaderView,
>>>>>>> 87428c2db55e53f3305a5e05d544901b7e3d7e49:Uplift/Views/Dropdown/DropdownView.swift
         headerViewHeight: CGFloat,
         contentView: UIView,
         contentViewHeight: CGFloat,
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
        
        addSubview(self.headerView)

        self.headerViewHeight = headerViewHeight
        currentHeight = headerViewHeight

        addSubview(self.contentView)

        currentHeight = headerView.bounds.height
        self.contentViewHeight = contentViewHeight
        self.halfDropdownEnabled = halfDropdownEnabled

        if let halfView = halfOpenView {
            halfView.isHidden = true
            halfView.isUserInteractionEnabled = true
            addSubview(halfView)
            halfOpenDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(openFromHalfDropdown(sender:)))
            halfView.addGestureRecognizer(halfOpenDropdownGesture)
        }

        self.halfOpenViewHeight = halfOpenViewHeight

        if let halfView = halfCloseView {
            halfView.isHidden = true
            halfCloseDropdownGesture = UITapGestureRecognizer(target: self, action: #selector(closeHalfDropdown(sender:)))
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
    func openCloseDropdown() {
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

    // MARK: - Open the entire dropdown view from half open state
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

    // MARK: - Close the dropdown view halfway
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

extension DropdownView: DropdownHeaderViewDelegate {
    func didTapHeaderView() {
        openCloseDropdown()
    }
}
