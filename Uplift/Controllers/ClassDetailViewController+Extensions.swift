//
//  ClassDetailViewController+Extensions.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import EventKit
import UIKit

extension ClassDetailViewController: ClassDetailHeaderViewDelegate {

    func classDetailHeaderViewFavoriteButtonTapped() {
        favoriteButtonTapped()
    }
    
    func classDetailHeaderViewShareButtonTapped() {
        share()
    }
    
    
    func classDetailHeaderViewBackButtonTapped() {
        back()
    }

    func classDetailHeaderViewLocationSelected() {
        NetworkManager.shared.getGym(id: gymClassInstance.gymId) { gym in
            let gymDetailViewController = GymDetailViewController(gym: gym)
            self.navigationController?.pushViewController(gymDetailViewController, animated: true)
        }
    }

    func classDetailHeaderViewInstructorSelected() {
        // leaving as a stub, future designs will make use of this
        print("Instructor selected")
    }

}

extension ClassDetailViewController: ClassDetailTimeCellDelegate {

    func classDetailTimeCellShouldAddToCalendar() {
        // Add to calendar
        let store = EKEventStore()
        store.requestAccess(to: .event) { (granted, error) in
            guard error == nil,
                granted,
                let gymClassInstance = self.gymClassInstance else { self.noAccess(); return }
            let event = EKEvent(eventStore: store)
            event.title = gymClassInstance.className
            event.startDate = gymClassInstance.startTime
            event.endDate = gymClassInstance.endTime
            event.structuredLocation = EKStructuredLocation(title: gymClassInstance.location)
            event.calendar = store.defaultCalendarForNewEvents

            DispatchQueue.main.async {
                let alert = UIAlertController(title: gymClassInstance.className + ClientStrings.Alerts.addedToCalendarTitle, message: ClientStrings.Alerts.addedToCalendarMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(ClientStrings.Alerts.dismissAlert, comment: "Dismiss calendar alert"), style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            do {
                try store.save(event, span: .thisEvent, commit: true)
            } catch {
                // should not happen
            }
        }
    }

    private func noAccess() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: ClientStrings.Alerts.cannotAddToCalendarTitle, message: ClientStrings.Alerts.cannotAddToCalendarMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString(ClientStrings.Alerts.dismissAlert, comment: "Dismiss calendar alert"), style: .default))

            let settingsAction = UIAlertAction(title: ClientStrings.Alerts.displaySettingsTitle, style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil )
                }
            }

            alert.addAction(settingsAction)

            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension ClassDetailViewController: ClassDetailNextSessionsCellDelegate {

    func didSelectNextSession(_ nextSession: GymClassInstance) {
        let classDetailViewController = ClassDetailViewController(gymClassInstance: nextSession)
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

}
