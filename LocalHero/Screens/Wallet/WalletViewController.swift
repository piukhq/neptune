//
//  WalletViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 14/03/2022.
//

import SwiftUI
import UIKit

class WalletViewController: LocalHeroViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let threeDotsImage = UIImage(named: "dots")
        threeDotsImage?.withTintColor(.white)
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(threeDotsImage, for: .normal)
        settingsButton.addTarget(self, action: #selector(navigationBarButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: settingsButton)
        barButton.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return barButton
    }()
    
    private var viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didLoadLocalWallet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didLoadWallet, object: nil)
        
        collectionView.register(WalletCollectionViewCell.self, asNib: true)
        collectionView.registerHeader(WalletHeaderView.self, asNib: true)
        configureCollectionView()
        backgroundImageView.alpha = 0.3
        title = "Neptune"
        navigationItem.rightBarButtonItem = settingsButton
        
        handleLaunch()
    }
    
    private func handleLaunch() {
        Current.wallet.launch() { [weak self] success, error in
            guard success else {
                if case .failedToGetLoyaltyPlans(let networkingError) = error {
                    if case .unauthorized = networkingError {
                        self?.showError(title: L10n.alertInvalidToken)
                    } else {
                        self?.showError(title: networkingError.localizedDescription)
                    }
                }
                return
            }
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func showError(title: String) {
        let ac = ViewControllerFactory.makeAlertController(title: title, message: nil)
        let navigationRequest = AlertNavigationRequest(alertController: ac)
        Current.navigate.to(navigationRequest)
    }
    
    @objc private func refresh() {
        collectionView.reloadData()
    }
    
    @objc func navigationBarButtonTapped() {
        let alert = ViewControllerFactory.makeHomeScreenMenuActionSheetController {
            let addPaymentCardviewController = AddPaymentAccountViewController(viewModel: AddPaymentAccountViewModel())
            let navigationRequest = ModalNavigationRequest(viewController: addPaymentCardviewController)
            Current.navigate.to(navigationRequest)
        } settingsAction: {
            let settingsViewController = SettingsViewController()
            let navigationRequest = ModalNavigationRequest(viewController: settingsViewController)
            Current.navigate.to(navigationRequest)
        } mapAction: {
            let navigationRequest = PushNavigationRequest(viewController: MapViewController())
            Current.navigate.to(navigationRequest)
        }
        
        let navigationRequest = AlertNavigationRequest(alertController: alert)
        Current.navigate.to(navigationRequest)
    }
    
    
    // MARK: - Collection view
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.loyaltyCards?.count ?? 0
        case 1:
            return viewModel.paymentAccounts?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WalletCollectionViewCell = collectionView.dequeue(indexPath: indexPath)
        
        switch indexPath.section {
        case 0:
            guard let loyaltyCard = viewModel.loyaltyCards?[safe: indexPath.item] else { return cell }
            cell.configure(with: loyaltyCard)
        case 1:
            guard let paymentAccount = viewModel.paymentAccounts?[safe: indexPath.item] else { return cell }
            cell.configure(with: paymentAccount)
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: WalletHeaderView = collectionView.dequeueReusableView(indexPath: indexPath, kind: UICollectionView.elementKindSectionHeader)
        headerView.configure(title: indexPath.section == 0 ? "Loyalty Cards" : "Payment Cards")
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var viewController: WalletCardDetailsViewController!
        switch indexPath.section {
        case 0:
            let loyaltyCard = viewModel.loyaltyCards?[safe: indexPath.item]
            viewController = WalletCardDetailsViewController(loyaltyCard: loyaltyCard, paymentAccount: nil)
        case 1:
            let paymentAccount = viewModel.paymentAccounts?[safe: indexPath.item]
            viewController = WalletCardDetailsViewController(loyaltyCard: nil, paymentAccount: paymentAccount)
        default:
            break
        }
        
        let navigationRequest = PushNavigationRequest(viewController: viewController)
        Current.navigate.to(navigationRequest)
    }
}
