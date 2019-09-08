//
//  ProBioViewController.swift
//  Uplift
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioViewController: UIViewController {

    // MARK: - Private view vars
    private let backButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())

    // MARK: - Private data vars
    private var pro: ProBio!
    private var sections: [Section] = []

    private enum Constants {
        static let proBioBiographyCellIdentifier = "proBioBiographyCellIdentifier"
        static let proBioExpertiseCellIdentifier = "proBioExpertiseCellIdentifier"
        static let proBioHeaderViewIdentifier = "proBioHeaderViewIdentifier"
        static let proBioLinksCellIdentifier = "proBioLinksCellIdentifier"
        static let proBioRoutinesCellIdentifier = "proBioRoutinesCellIdentifier"
    }

    // MARK: - Private classes/enums
    private struct Section {
        var items: [ItemType]
    }

    private enum ItemType {
        case biography
        case expertise
        case routines
        case links
    }

    // MARK: - Custom Initializer
    init(pro: ProBio) {
        super.init(nibName: nil, bundle: nil)
        self.pro = pro
        self.sections = [
            Section(items: [.biography, .expertise, .routines, .links])
        ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updatesStatusBarAppearanceAutomatically = true
        view.backgroundColor = .white

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)

        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        switch UIApplication.shared.statusBarStyle {
        case .lightContent:
            backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        case .default:
            backButton.setImage(UIImage(named: "darkBackArrow"), for: .normal)
        }
    }

    // MARK: - Targets
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

}
// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension ProBioViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = sections[indexPath.section].items[indexPath.item]

        switch itemType {
        case .biography:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.proBioBiographyCellIdentifier, for: indexPath) as! ProBioBiographyCell
            cell.configure(for: pro)
            return cell
        case .expertise:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.proBioExpertiseCellIdentifier, for: indexPath) as! ProBioExpertiseCell
            cell.configure(for: pro)
            return cell
        case .routines:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.proBioRoutinesCellIdentifier, for: indexPath) as! ProBioRoutinesCell
            cell.configure(for: self, for: pro)
            return cell
        case .links:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.proBioLinksCellIdentifier, for: indexPath) as! ProBioLinksCell
            cell.configure(for: pro)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.proBioHeaderViewIdentifier,
            for: indexPath) as! ProBioHeaderView
        headerView.configure(for: pro)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 435)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bioTextViewHorizontalPadding = 40
        let bioSummaryHorizontalPadding = 40

        let descriptionLabelHorizontalPadding = 48

        let width = collectionView.frame.width
        let itemType = sections[indexPath.section].items[indexPath.item]
        switch itemType {
        case .biography:
            let bioSummaryWidth = width - CGFloat(bioSummaryHorizontalPadding * 2)
            let bioSummaryHeight = pro.summary.height(withConstrainedWidth: bioSummaryWidth, font: UIFont._20MontserratSemiBold!)
            let bioTextViewWidth = width - CGFloat(bioTextViewHorizontalPadding * 2)
            let bioTextViewHeight = pro.bio.height(withConstrainedWidth: bioTextViewWidth, font: UIFont._14MontserratLight!)
            let height = ProBioBiographyCell.baseHeight + bioSummaryHeight + bioTextViewHeight
            return CGSize(width: width, height: height)
        case .expertise:
            let descriptionLabelWidth = width - CGFloat(descriptionLabelHorizontalPadding * 2)
            let descriptionLabelHeight = pro.expertise.joined(separator: " · ").height(withConstrainedWidth: descriptionLabelWidth, font: UIFont._14MontserratLight!)
            let height = ProBioExpertiseCell.baseHeight + descriptionLabelHeight
            return CGSize(width: width, height: height)
        case .routines:
            let height = routinesCollectionViewHeight() + ProBioRoutinesCell.baseHeight
            return CGSize(width: width, height: height)
        case .links:
            return CGSize(width: width, height: ProBioLinksCell.baseHeight)
        }
    }

    private func routinesCollectionViewHeight() -> CGFloat {
        var totalHeight: CGFloat = 0

        let cellPadding = 16
        let width = 327
        let constrainedWidth = width - 2 * cellPadding
        let routineTypeLabelHeight = 15
        let routineTypeTopPadding = 3
        let titleLabelHeight = 20
        let cellHeight = CGFloat(cellPadding + titleLabelHeight + routineTypeTopPadding + routineTypeLabelHeight + cellPadding + cellPadding)

        pro.routines.forEach { routine in
            let descriptionTextViewHeight = routine.text.height(withConstrainedWidth: CGFloat(constrainedWidth), font: UIFont._14MontserratLight!)
            totalHeight += (cellHeight + descriptionTextViewHeight + CGFloat(cellPadding))
        }

        return totalHeight
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Layout
extension ProBioViewController {
    private func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProBioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.proBioHeaderViewIdentifier)
        collectionView.register(ProBioBiographyCell.self, forCellWithReuseIdentifier: Constants.proBioBiographyCellIdentifier)
        collectionView.register(ProBioExpertiseCell.self, forCellWithReuseIdentifier: Constants.proBioExpertiseCellIdentifier)
        collectionView.register(ProBioRoutinesCell.self, forCellWithReuseIdentifier: Constants.proBioRoutinesCellIdentifier)
        collectionView.register(ProBioLinksCell.self, forCellWithReuseIdentifier: Constants.proBioLinksCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
    }

    private func setupConstraints() {
        let backButtonLeftPadding = 16
        let backButtonSize = CGSize(width: 23, height: 19)
        let backButtonTopPadding = 48

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(backButtonLeftPadding)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(backButtonTopPadding)
            make.size.equalTo(backButtonSize)
        }
    }
}

// MARK: - ScrollViewDelegate
extension ProBioViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        statusBarUpdater?.refreshStatusBarStyle()

        switch UIApplication.shared.statusBarStyle {
        case .lightContent:
            backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        case .default:
            backButton.setImage(UIImage(named: "darkBackArrow"), for: .normal)
        }
    }

}

// MARK: - ProBioRoutinesCellDelegate
extension ProBioViewController: ProBioRoutinesCellDelegate {

    func pushHabitAddedAlert(habitTitle: String) {
        let alert = UIAlertController(title: "Habit added", message: "\"\(habitTitle)\" set to favorite", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
