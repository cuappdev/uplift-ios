//
//  ProBioPageViewController.swift
//  
//
//  Created by Cameron Hamidi on 2/28/19.
//

import UIKit

class ProBioPageViewController: UIViewController {
    enum ConstraintConstants {
        static let bioTextViewLeadingTrailing = 44
        static let bioTitleLeadingTrailing = 40
        static let dividerHeight = 1
        static let dividerSpacing = 24
        static let expertiseTextViewLeadingTrailing = 44
        static let largeVerticalSpacing = 64
        static let linksCollectionCellHeight = 30
        static let mediumVerticalSpacing = 32
        static let nameLabelLeadingTrailing = 15
        static let routinesTitleLabelLeadingTrailing = 33
        static let routinesViewLeadingTrailing = 24
        static let smallVerticalSpacing = 16
    }
    
    let personalLinksInteritemSpacing = 6
    
    var backButton: UIButton!
    var bioExpertiseDivider: UIView!
    var bioTextView: UITextView!
    var bioTitleLabel: UILabel!
    var expertiseRoutinesDivider: UIView!
    var expertiseTextView: UITextView!
    var expertiseTitleLabel: UILabel!
    var linksCollectionView: UICollectionView!
    var linksTitleLabel: UILabel!
    var nameLabel: UILabel!
    var pro: ProBio!
    var profilePicContainerView: UIView!
    var profilePicView: UIImageView!
    var routinesTitleLabel: UILabel!
    var routinesView: AllProRoutinesView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        profilePicContainerView = UIView()
        profilePicContainerView.backgroundColor = .white
        scrollView.addSubview(profilePicContainerView)
        
        profilePicView = UIImageView()
        profilePicView.contentMode = .scaleAspectFill
        profilePicView.clipsToBounds = true
        profilePicContainerView.addSubview(profilePicView)
        
        nameLabel = UILabel()
        nameLabel.layer.zPosition = 1
        nameLabel.textColor = .white
        nameLabel.font = ._36MontserratBold
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        scrollView.addSubview(nameLabel)
        
        bioTitleLabel = UILabel()
        bioTitleLabel.textColor = .black
        bioTitleLabel.font = ._20MontserratSemiBold
        bioTitleLabel.textAlignment = .center
        bioTitleLabel.sizeToFit()
        bioTitleLabel.numberOfLines = 0
        scrollView.addSubview(bioTitleLabel)
        
        bioTextView = UITextView()
        bioTextView.textColor = UIColor.fitnessBlack
        bioTextView.font = ._14MontserratRegular
        bioTextView.sizeToFit()
        bioTextView.isScrollEnabled = false
        bioTextView.textAlignment = .center
        bioTextView.isSelectable = false
        scrollView.addSubview(bioTextView)

        bioExpertiseDivider = UIView()
        bioExpertiseDivider.backgroundColor = UIColor.fitnessMutedGreen
        scrollView.addSubview(bioExpertiseDivider)
        
        expertiseTitleLabel = UILabel()
        expertiseTitleLabel.textColor = .black
        expertiseTitleLabel.font = ._16MontserratMedium
        expertiseTitleLabel.text = "EXPERTISE"
        expertiseTitleLabel.textAlignment = .center
        expertiseTitleLabel.sizeToFit()
        scrollView.addSubview(expertiseTitleLabel)
        
        expertiseTextView = UITextView()
        expertiseTextView.textColor = UIColor.fitnessBlack
        expertiseTextView.font = ._14MontserratLight
        expertiseTextView.sizeToFit()
        expertiseTextView.isScrollEnabled = false
        expertiseTextView.textAlignment = .center
        expertiseTextView.isSelectable = false
        scrollView.addSubview(expertiseTextView)
        
        expertiseRoutinesDivider = UIView()
        expertiseRoutinesDivider.backgroundColor = UIColor.fitnessMutedGreen
        scrollView.addSubview(expertiseRoutinesDivider)
        
        routinesTitleLabel = UILabel()
        routinesTitleLabel.textColor = .black
        routinesTitleLabel.font = ._16MontserratMedium
        routinesTitleLabel.text = "SUGGESTED ROUTINES"
        routinesTitleLabel.textAlignment = .center
        routinesTitleLabel.sizeToFit()
        scrollView.addSubview(routinesTitleLabel)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = CGFloat(personalLinksInteritemSpacing)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        linksTitleLabel = UILabel()
        linksTitleLabel.text = "FOLLOW ME"
        linksTitleLabel.font = ._12MontserratBold
        linksTitleLabel.textColor = .black
        linksTitleLabel.textAlignment = .center
        linksTitleLabel.sizeToFit()
        scrollView.addSubview(linksTitleLabel)
        
        linksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        linksCollectionView.delegate = self
        linksCollectionView.dataSource = self
        linksCollectionView.backgroundColor = .white
        linksCollectionView.register(PersonalLinkCollectionViewCell.self, forCellWithReuseIdentifier: PersonalLinkCollectionViewCell.identifier)
        scrollView.addSubview(linksCollectionView)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
        
        setPro()
        setupConstraints()
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func setPro() {
        nameLabel.text = pro.name.uppercased()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont._14MontserratLight]
        bioTextView.attributedText = NSAttributedString(string: pro.bio, attributes: attributes)
        bioTextView.textAlignment = .center
        
        bioTitleLabel.text = pro.summary
        
        expertiseTextView.text = pro.expertise.joined(separator: " · ")
        
        linksCollectionView.reloadData()
        
        routinesView = AllProRoutinesView(routines: pro.routines, delegate: self)
        scrollView.addSubview(routinesView)
        
        profilePicView.image = pro.profilePic
    }
    
    func setupConstraints() {
        let backButtonHeight = 19
        let backButtonLeading = 20
        let backButtonTop = 30
        let backButtonWidth = 23
        let linksTitleCollectionViewSpacing = 12
        let profilePicHeightWidthRatio = 1.16
       
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(backButtonLeading)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(backButtonTop)
            make.width.equalTo(backButtonWidth)
            make.height.equalTo(backButtonHeight)
        }
        
        scrollView.snp.makeConstraints{ make in
            make.top.leading.trailing.bottom.width.equalToSuperview()
//            make.width.equalTo(view.snp.width)
        }
        
        profilePicContainerView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Double(view.frame.width) * profilePicHeightWidthRatio)
        }
        
        profilePicView.snp.makeConstraints{ make in
            make.top.equalTo(view)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(profilePicContainerView.snp.bottom)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(ConstraintConstants.nameLabelLeadingTrailing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.nameLabelLeadingTrailing)
            make.bottom.equalTo(profilePicContainerView.snp.bottom).offset(-ConstraintConstants.largeVerticalSpacing)
        }
        
        bioTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profilePicContainerView.snp.bottom).offset(ConstraintConstants.largeVerticalSpacing)
            make.leading.equalToSuperview().offset(ConstraintConstants.bioTitleLeadingTrailing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.bioTitleLeadingTrailing)
        }
        
        bioTextView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bioTitleLabel.snp.bottom).offset(ConstraintConstants.mediumVerticalSpacing)
            make.leading.equalToSuperview().offset(ConstraintConstants.bioTextViewLeadingTrailing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.bioTextViewLeadingTrailing)
        }
        
        bioExpertiseDivider.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(ConstraintConstants.dividerHeight)
            make.top.equalTo(bioTextView.snp.bottom).offset(ConstraintConstants.dividerSpacing)
        }
        
        expertiseTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(bioExpertiseDivider.snp.bottom).offset(ConstraintConstants.dividerSpacing)
            make.centerX.equalToSuperview()
        }
        
        expertiseTextView.snp.makeConstraints{ make in
            make.top.equalTo(expertiseTitleLabel.snp.bottom).offset(ConstraintConstants.smallVerticalSpacing)
            make.leading.equalToSuperview().offset(ConstraintConstants.expertiseTextViewLeadingTrailing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.expertiseTextViewLeadingTrailing)
        }
        
        expertiseRoutinesDivider.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(ConstraintConstants.dividerHeight)
            make.top.equalTo(expertiseTextView.snp.bottom).offset(ConstraintConstants.dividerSpacing)
        }
        
        routinesTitleLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(ConstraintConstants.routinesTitleLabelLeadingTrailing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.routinesTitleLabelLeadingTrailing)
            make.top.equalTo(expertiseRoutinesDivider.snp.bottom).offset(ConstraintConstants.dividerSpacing)
        }
        
        routinesView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(ConstraintConstants.routinesViewLeadingTrailing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.routinesViewLeadingTrailing)
            make.top.equalTo(routinesTitleLabel.snp.bottom).offset(ConstraintConstants.smallVerticalSpacing)
        }
        
        linksTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(routinesView.snp.bottom).offset(ConstraintConstants.largeVerticalSpacing)
        }
        
        linksCollectionView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(linksTitleLabel.snp.bottom).offset(linksTitleCollectionViewSpacing)
            make.height.equalTo(ConstraintConstants.linksCollectionCellHeight)
            make.width.equalTo(ConstraintConstants.linksCollectionCellHeight * pro.links.count + (pro.links.count - 1) * personalLinksInteritemSpacing)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.largeVerticalSpacing)
        }
    }
}


extension ProBioPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pro.links.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalLinkCollectionViewCell.identifier, for: indexPath) as! PersonalLinkCollectionViewCell
        cell.configure(for: pro.links[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ProBioPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = pro.links[indexPath.row].url {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension ProBioPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ProBioPageViewController: HabitAlertDelegate {
    func pushAlert(habitTitle: String) {
        let alert = UIAlertController(title: "Habit added", message: "\"\(habitTitle)\" set to favorite", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
