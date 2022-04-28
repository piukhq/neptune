//
//  LoyaltyPlansTableViewController.swift
//  API2
//
//  Created by Sean Williams on 10/12/2021.
//

import UIKit

class LoyaltyPlansViewModel {
    var loyaltyPlans: [CD_LoyaltyPlan] = []
    
    init() {
        loyaltyPlans = Current.wallet.loyaltyPlans?.sorted(by: { firstPlan, secondPlan in
            (firstPlan.planDetails?.companyName?.lowercased() ?? "") < (secondPlan.planDetails?.companyName?.lowercased() ?? "")
        }) ?? []
    }

}

class LoyaltyPlansTableViewController: UITableViewController {
    private let viewModel = LoyaltyPlansViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.loyaltyPlans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let plan = viewModel.loyaltyPlans[indexPath.row]
        cell.textLabel?.text = plan.planDetails?.companyName ?? "Missing"
        cell.detailTextLabel?.text = plan.planDetails?.planName ?? ""
        return cell
    }
}
