//
//  LoyaltyPlansTableViewController.swift
//  API2
//
//  Created by Sean Williams on 10/12/2021.
//

import UIKit

class LoyaltyPlansTableViewController: UITableViewController {
    
    var planID = 0
    var loyaltyPlans: [LoyaltyPlanModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLoyaltyPlans {
            self.loyaltyPlans = $0
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
    }

    private func getLoyaltyPlans(completion: @escaping ([LoyaltyPlanModel]) -> Void) {
        let request = BinkNetworkRequest(endpoint: .getLoyaltyPlans, method: .get, headers: nil, isUserDriven: false)
        Current.apiClient.performRequest(request, expecting: [Safe<LoyaltyPlanModel>].self) { result, _ in
            switch result {
            case .success(let response):
                let safeResponse = response.compactMap( { $0.value })
                completion(safeResponse)
            case .failure(let error):
                print("Failed to get membership plans")
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loyaltyPlans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let plan = loyaltyPlans[indexPath.row]
        cell.textLabel?.text = plan.planDetails?.companyName ?? "Missing"
        cell.detailTextLabel?.text = plan.planDetails?.planName ?? ""
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let loyaltyPlanID = loyaltyPlans[indexPath.row].loyaltyPlanID else { return }
        planID = loyaltyPlanID
    }
}
