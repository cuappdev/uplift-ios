//
//  GymDetailViewController+Extensions.swift
//  Uplift
//
//  Created by Yana Sang on 5/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

extension GymDetailViewController: GymDetailHoursCellDelegate {

    func didDropHours(isDropped: Bool, completion: @escaping () -> Void) {
        // TODO: - Implemement
//        gymDetail.hoursDataIsDropped.toggle()
        collectionView.performBatchUpdates({}, completion: nil)
        completion()
    }

}

extension GymDetailViewController: GymDetailTodaysClassesCellDelegate {

    func didSelectClassSession(_ session: GymClassInstance) {
        let classDetailViewController = ClassDetailViewController(gymClassInstance: session)
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }

}

extension GymDetailViewController: GymDetailHeaderViewDelegate {

    func gymDetailHeaderViewBackButtonTapped() {
        back()
    }

}
