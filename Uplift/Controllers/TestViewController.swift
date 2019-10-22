//
//  TestViewController.swift
//  
//
//  Created by Cameron Hamidi on 10/10/19.
//

import UIKit

class TestViewController: UIViewController {

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    var headerView: UILabel!
    var textView: UITextView!
    var dropdownView: DropdownView!
    var textViewHeightAnchor: NSLayoutConstraint!
    var scrollView: UIScrollView!
    var dropdownViewHeightAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        headerView = UILabel()
        headerView.text = "Expand dropdown"
        headerView.textColor = .black
        headerView.backgroundColor = .purple
        headerView.isUserInteractionEnabled = true
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        textView = UITextView()
        textView.text = "Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text Placeholder text "
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 20)
        textView.backgroundColor = .red
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        
        var dropdownOpenView = UILabel()
        dropdownOpenView.text = "Show more"
        dropdownOpenView.textColor = .black
        dropdownOpenView.backgroundColor = .green
        
        var dropdownClosedView = UILabel()
        dropdownClosedView.text = "Show less"
        dropdownClosedView.textColor = .black
        dropdownClosedView.backgroundColor = .red
        
        dropdownView = DropdownView(headerView: headerView, headerViewHeight: 30.0, contentView: textView, contentViewHeight: 150.0, halfDropdownEnabled: true, halfExpandView: dropdownOpenView, halfExpandViewHeight: 30.0, halfCollapseView: dropdownClosedView, halfCollapseViewHeight: 30.0, halfHeight: 5.0)
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.isUserInteractionEnabled = true
        dropdownView.halfDropdownEnabled = true
        dropdownView.halfExpandView = dropdownOpenView
        dropdownView.halfCollapseView = dropdownClosedView
        dropdownView.delegate = self
        dropdownView.backgroundColor = .blue
        view.addSubview(dropdownView)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dropdownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dropdownView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dropdownView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        dropdownViewHeightAnchor = dropdownView.heightAnchor.constraint(equalToConstant: 30.0)
        dropdownViewHeightAnchor.isActive = true
    }
}

extension TestViewController: DropdownViewDelegate {
    func expandDropdownViewFull(sender dropdownView: DropdownView) {
        dropdownViewHeightAnchor.constant = dropdownView.currentHeight
    }
    
    func collapseDropdownView(sender dropdownView: DropdownView) {
        dropdownViewHeightAnchor.constant = dropdownView.currentHeight
    }
    
    func expandDropdownViewHalf(sender dropdownView: DropdownView) {
        dropdownViewHeightAnchor.constant = dropdownView.currentHeight
    }
    
    func collapseDropdownViewHalf(sender dropdownView: DropdownView) {
        dropdownViewHeightAnchor.constant = dropdownView.currentHeight
    }
}
