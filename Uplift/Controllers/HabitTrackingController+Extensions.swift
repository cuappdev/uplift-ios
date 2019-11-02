//
//  HabitTrackingController+Extensions.swift
//  Uplift
//
//  Created by Kevin Chan on 5/14/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

// MARK: - TABLEVIEW DELEGATE AND DATA SOURCE
extension HabitTrackingController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let title = UILabel()
        title.font = ._14MontserratBold
        title.textAlignment = .left
        title.textColor = .gray04
        header.addSubview(title)

        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            if section == Constants.featuredHabitSection {
                make.centerY.equalToSuperview()
            } else {
                make.bottom.equalToSuperview()
            }
            make.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        if section == Constants.featuredHabitSection {
            title.text = ClientStrings.HabitTracking.featuredHabitsSection
        } else {
            title.text = ClientStrings.HabitTracking.suggestedHabitsSection
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Constants.featuredHabitSection {
            return CGFloat(Constants.featuredSectionHeaderHeight)
        } else {
            return CGFloat(Constants.suggestedSectionHeaderHeight)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HabitTrackerOnboardingCell.height)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Constants.featuredHabitSection {
            return 1
        } else {
            return habits.count
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let habitCell = cell as? HabitTrackerOnboardingCell else { return }

        // The only time a cell will be displayed with the empty string is when a new habit is being created
        if habitCell.titleLabel.text == "" {
            habitCell.swipeLeft()
            habitCell.edit()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Constants.featuredHabitSection {
            if let habit = featuredHabit {
                let cell = tableView.dequeueReusableCell(withIdentifier: HabitTrackerOnboardingCell.identifier, for: indexPath) as! HabitTrackerOnboardingCell

                cell.setTitle(activity: habit)
                cell.swipeRight()
                cell.delegate = self
                cell.separator.isHidden = true

                return cell
            } else {
                // Empty state featured habit
                // TODO - replace this with the NoHabitsCell class once it is converted to a tableview
                let cell = UITableViewCell()

                let backgroundImage = UIImageView()
                backgroundImage.image = UIImage(named: "selection-area")
                backgroundImage.clipsToBounds = false
                cell.contentView.addSubview(backgroundImage)

                backgroundImage.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(21)
                    make.trailing.equalToSuperview().offset(-21)
                }

                let addHabitWidget = UIImageView()
                addHabitWidget.image = UIImage(named: ImageNames.addLight)
                cell.contentView.addSubview(addHabitWidget)

                addHabitWidget.snp.makeConstraints { make in
                    make.width.height.equalTo(20)
                    make.leading.equalTo(backgroundImage).offset(15)
                    make.centerY.equalToSuperview()
                }

                let titleLabel = UILabel()
                titleLabel.text = ClientStrings.HabitTracking.newHabitPlaceholder
                titleLabel.textAlignment = .left
                titleLabel.clipsToBounds = false
                titleLabel.font = ._16MontserratMedium
                titleLabel.textColor = .upliftMediumGrey
                cell.contentView.addSubview(titleLabel)

                titleLabel.snp.makeConstraints { make in
                    make.leading.equalTo(addHabitWidget.snp.trailing).offset(8)
                    make.trailing.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.height.equalTo(22)
                }

                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HabitTrackerOnboardingCell.identifier, for: indexPath) as! HabitTrackerOnboardingCell

            cell.setTitle(activity: habits[indexPath.row])
            cell.swipeRight()
            cell.delegate = self

            return cell
        }
    }
}

// MARK: - HABIT TRACKER DELEGATE
extension HabitTrackingController: HabitTrackerOnboardingDelegate {
    func prepareForEditing(cell: HabitTrackerOnboardingCell) {
        editingCell = cell
        canSwipe = false
    }

    func endEditing() {
        doneEditingHabit()
    }

    func deleteCell(cell: HabitTrackerOnboardingCell) {
        guard let indexPath = habitTableView.indexPath(for: cell) else { return }

        if indexPath.section == Constants.featuredHabitSection {
            featuredHabit = nil
            habitTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            habits.remove(at: indexPath.row)
            habitTableView.deleteRows(at: [indexPath], with: .automatic)
            updateTableViewConstraints()
        }
    }

    func swipeLeft(cell: HabitTrackerOnboardingCell) -> Bool {
        if canSwipe {
            if let previousCell = swipedCell {
                previousCell.swipeRight()
            }

            habitTableView.indexPathsForVisibleRows?.forEach({ indexPath in
                if let cell = habitTableView.cellForRow(at: indexPath) as? HabitTrackerOnboardingCell {
                    if indexPath.section == Constants.suggestedHabitSection {
                        cell.separator.isHidden = true
                    }
                }
            })

            swipedCell = cell
            return true
        } else {
            return false
        }
    }

    func swipeRight() {
        swipedCell = nil

        habitTableView.indexPathsForVisibleRows?.forEach({ indexPath in
            if let cell = habitTableView.cellForRow(at: indexPath) as? HabitTrackerOnboardingCell {
                if indexPath.section == Constants.suggestedHabitSection {
                    cell.separator.isHidden = false
                }
            }
        })
    }

    func featureHabit(cell: HabitTrackerOnboardingCell) {
        guard let indexPath = habitTableView.indexPath(for: cell) else { return }

        if indexPath.section == Constants.featuredHabitSection {
            guard let habit = featuredHabit else { return }

            habits.append(habit)
            featuredHabit = nil
            updateTableViewConstraints()

            habitTableView.beginUpdates()
            habitTableView.insertRows(at: [IndexPath(row: habits.count - 1, section: 1)], with: .automatic)
            habitTableView.reloadRows(at: [indexPath], with: .automatic)
            habitTableView.endUpdates()

            return
        }

        if let currentHabit = featuredHabit {
            habits.append(currentHabit)
            featuredHabit = habits[indexPath.row]
            habits.remove(at: indexPath.row)
            habitTableView.reloadData()
        } else {
            featuredHabit = habits[indexPath.row]
            habits.remove(at: indexPath.row)
            habitTableView.reloadData()
            updateTableViewConstraints()
        }
    }
}

// MARK: - TABLEVIEW DRAG AND DROP DELEGATE
extension HabitTrackingController:  UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        var habit: String
        if indexPath.section == Constants.featuredHabitSection {
            if let featuredHabit = featuredHabit {
                habit = featuredHabit
            } else { return [] }
        } else {
            habit = habits[indexPath.row]
        }

        let data = habit.data(using: .utf8)
        let itemProvider = NSItemProvider()

        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }

        return [ UIDragItem(itemProvider: itemProvider) ]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        coordinator.session.loadObjects(ofClass: NSString.self) { items in

            guard let stringItems = items as? [String] else { return }
            guard let habit = stringItems.first else { return }

            if let index = self.habits.index(of: habit) {
                // Habit is originating from the suggested section
                self.habits.remove(at: index)

                if destinationIndexPath.section == Constants.featuredHabitSection {
                    // Moving suggested habit to featured
                    tableView.beginUpdates()

                    if let oldHabit = self.featuredHabit {
                        self.habits.append(oldHabit)
                        tableView.insertRows(at: [IndexPath(row: self.habits.count - 1, section: 1)], with: .automatic)
                    }

                    self.featuredHabit = habit

                    tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    tableView.endUpdates()
                    self.updateTableViewConstraints()

                } else {
                    // Moving suggested habit around in section
                    self.habits.insert(habit, at: destinationIndexPath.row)
                    tableView.reloadSections(IndexSet(integersIn: 1..<2), with: .automatic)
                }

            } else {
                // Habit is currently featured
                if destinationIndexPath.section == Constants.suggestedHabitSection {
                    // Moving featured habit back down
                    tableView.beginUpdates()

                    self.featuredHabit = nil
                    self.habits.insert(habit, at: destinationIndexPath.row)

                    tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    tableView.endUpdates()

                    self.updateTableViewConstraints()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
