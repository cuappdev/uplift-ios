//
//  GymDetailFitnessCenter.swift
//  Uplift
//
//  Created by alden lamp on 10/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class GymDetailFitnessCenter: UIViewController {

    private var tableView = {
        let tableView = UITableView()

        // Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false

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

    private var fitnessCenter: FitnessCenter?

    private var sections: [ItemType]!

    private enum ItemType {
        case capacity
        case hours
    }

    init(fitnessCenter: FitnessCenter) {
        super.init(nibName: nil, bundle: nil)
        sections = [.capacity, .hours]
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
}

extension GymDetailFitnessCenter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
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
            return cell
        }
    }

}

extension GymDetailFitnessCenter: UITableViewDelegate {

}
