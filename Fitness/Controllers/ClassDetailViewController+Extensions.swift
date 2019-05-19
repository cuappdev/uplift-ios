//
//  ClassDetailViewController+Extensions.swift
//  Fitness
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import EventKit
import UIKit

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
                let alert = UIAlertController(title: "\(self.gymClassInstance.className) added to calendar", message: "Get ready to get sweaty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss calendar alert"), style: .default))
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
            let alert = UIAlertController(title: "Cannot add to calendar", message: "Uplift does not have permission to acess your calendar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss calendar alert"), style: .default))

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
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
