//
//  ProBioPageViewController.swift
//  
//
//  Created by Cameron Hamidi on 2/28/19.
//

import UIKit

class ProBioPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

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
        flowLayout.minimumInteritemSpacing = 6.0
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
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
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
        
        routinesView = AllProRoutinesView(routines: pro.routines)
        scrollView.addSubview(routinesView)
        
        profilePicView.image = pro.profilePic
    }
    
    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }
        
        scrollView.snp.makeConstraints{ make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        profilePicContainerView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.width * 1.16)
        }
        
        profilePicView.snp.makeConstraints{ make in
            make.top.equalTo(view)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(profilePicContainerView.snp.bottom)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(profilePicContainerView.snp.bottom).offset(-64)
        }
        
        bioTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profilePicContainerView.snp.bottom).offset(64)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        bioTextView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bioTitleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-44)
        }
        
        bioExpertiseDivider.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(bioTextView.snp.bottom).offset(24)
        }
        
        expertiseTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(bioExpertiseDivider.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        expertiseTextView.snp.makeConstraints{ make in
            make.top.equalTo(expertiseTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(48)
            make.trailing.equalToSuperview().offset(-48)
        }
        
        expertiseRoutinesDivider.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(expertiseTextView.snp.bottom).offset(24)
        }
        
        routinesTitleLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(33)
            make.trailing.equalToSuperview().offset(-33)
            make.top.equalTo(expertiseRoutinesDivider.snp.bottom).offset(24)
        }
        
        routinesView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(routinesTitleLabel.snp.bottom).offset(16)
        }
        
        linksTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(routinesView.snp.bottom).offset(64)
        }
        
        linksCollectionView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(linksTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(30 * pro.links.count + (pro.links.count - 1) * 6)
            make.bottom.equalToSuperview().offset(-64)
        }
    }
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == linksCollectionView {
            return pro.links.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.linksCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalLinkCollectionViewCell.identifier, for: indexPath) as! PersonalLinkCollectionViewCell
            cell.configure(for: pro.links[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
