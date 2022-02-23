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
        
        private func getLoyaltyPlans(completion: @escaping ([LoyaltyPlanModel]) -> Void) {
            Current.apiClient.performRequest(method: .GET, endpoint: .getLoyaltyPlans, responseType: [LoyaltyPlanModel].self) { plans in
                completion(plans)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
        let plan = loyaltyPlans[indexPath.row]
        cell.textLabel?.text = plan.planDetails?.companyName ?? "Missing"
        cell.detailTextLabel?.text = plan.planDetails?.planName ?? ""
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let loyaltyPlanID = loyaltyPlans[indexPath.row].loyaltyPlanID else { return }
        planID = loyaltyPlanID
        performSegue(withIdentifier: "AddLoyaltyCard", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddLoyaltyCardViewController
        vc?.planID = planID
    }

}
