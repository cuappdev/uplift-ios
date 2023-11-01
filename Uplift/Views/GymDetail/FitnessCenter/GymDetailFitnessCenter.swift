//
//  GymDetailFitnessCenter.swift
//  Uplift
//
//  Created by alden lamp on 10/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

protocol GymDetailFitnessCenterDelegate: AnyObject {
    func didChangeSize(completion: @escaping () -> Void)
}

class GymDetailFitnessCenter: UIViewController {

    private var tableView = {
        let tableView = UITableView()

        // Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension

        // Styling
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        // Cells
        tableView.register(GymDetailFitnessCenterCapacityCell.self, forCellReuseIdentifier: GymDetailFitnessCenterCapacityCell.reuseId)
        tableView.register(GymDetailFitnessCenterHoursCell.self, forCellReuseIdentifier: GymDetailFitnessCenterHoursCell.reuseId)

        return tableView
    }()

    private var fitnessCenter: FitnessCenter!

    private static let sections: [ItemType]! = [.capacity, .hours]

    weak var delegate: GymDetailFitnessCenterDelegate?

    private enum ItemType {
        case capacity
        case hours
    }

    init(fitnessCenter: FitnessCenter) {
        super.init(nibName: nil, bundle: nil)
        self.fitnessCenter = fitnessCenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    func configure(fitnessCenter: FitnessCenter) {
        self.fitnessCenter = fitnessCenter
        tableView.reloadData()
    }

    static func getHeight(fitnessCenter: FitnessCenter, viewWidth: CGFloat) -> CGFloat {
        var height: CGFloat = 0
        for section in sections {
            switch section {
            case .capacity:
                height += GymDetailFitnessCenterCapacityCell.getHeight(capacityHeight: viewWidth / 2)
            case .hours:
                height += GymDetailFitnessCenterHoursCell.getHeight(isDisclosed: fitnessCenter.isHoursDisclosed, numLines: fitnessCenter.hours.getNumHoursLines())
            }
        }
        return height
    }

}

extension GymDetailFitnessCenter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GymDetailFitnessCenter.sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch GymDetailFitnessCenter.sections[indexPath.row] {
        case .capacity:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: GymDetailFitnessCenterCapacityCell.reuseId, for: indexPath) as! GymDetailFitnessCenterCapacityCell
            if let capacityData = self.fitnessCenter?.capacity {
                cell.configure(capacity: capacityData)
            }
            return cell
        case .hours:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: GymDetailFitnessCenterHoursCell.reuseId, for: indexPath) as! GymDetailFitnessCenterHoursCell
            if let fitnessCenter = self.fitnessCenter {
                cell.configure(delegate: self, hours: fitnessCenter.hours, isDisclosed: fitnessCenter.isHoursDisclosed)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch GymDetailFitnessCenter.sections[indexPath.row] {
        case .capacity:
            return GymDetailFitnessCenterCapacityCell.getHeight(capacityHeight: self.view.frame.width / 2)
        case .hours:
            return GymDetailFitnessCenterHoursCell.getHeight(isDisclosed: fitnessCenter.isHoursDisclosed, numLines: fitnessCenter.hours.getNumHoursLines())
        }
    }
}

extension GymDetailFitnessCenter: UITableViewDelegate {

}

extension GymDetailFitnessCenter: GymDetailFitnessCenterHoursCellDelegate {

    func didDropHours(isDropped: Bool, completion: @escaping () -> Void) {
        self.fitnessCenter?.isHoursDisclosed.toggle()
        delegate?.didChangeSize {
            self.tableView.performBatchUpdates({}, completion: nil)
            completion()
        }
    }

}
