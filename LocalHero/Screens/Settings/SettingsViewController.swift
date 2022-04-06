//
//  SettingsViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 05/04/2022.
//

import UIKit

class SettingsViewController: LocalHeroViewController {
    // MARK: - Helpers
    
    private enum Constants {
        static let horizontalInset: CGFloat = 0.0
        static let bottomInset: CGFloat = 150.0
        static let postCollectionViewPadding: CGFloat = 15.0
        static let preCollectionViewPadding: CGFloat = 10.0
        static let rowHeight: CGFloat = 100
    }
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = Constants.rowHeight
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        return tableView
    }()
    
    let reuseIdentifier = "settingsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Logout"
        content.secondaryText = "Remove token from secure storage etc."
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Current.navigate.close(animated: true) {
            Current.navigate.back(toRoot: true, animated: true) {
                Current.rootStateMachine.logout()
            }
        }
    }
}
