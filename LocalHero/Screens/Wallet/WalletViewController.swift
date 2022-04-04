//
//  WalletViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 14/03/2022.
//

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
    
    private var viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didLoadLocalWallet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didLoadWallet, object: nil)
        
        collectionView.register(WalletCollectionViewCell.self, asNib: true)
        collectionView.registerHeader(WalletHeaderView.self, asNib: true)
        configureCollectionView()
        backgroundImageView.alpha = 0.3
        
        let threeDotsImage = UIImage(systemName: "paperplane")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: threeDotsImage, style: .done, target: self, action: #selector(navigationBarButtonTapped))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Current.rootStateMachine.logout()
    }
    
    func configureCollectionView() {
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
    
    @objc private func refresh() {
        collectionView.reloadData()
    }
    
    @objc func navigationBarButtonTapped() {
        let alert = ViewControllerFactory.makeHomeScreenMenuActionSheetController {
            let addPaymentCardviewController = AddPaymentAccountViewController(viewModel: AddPaymentAccountViewModel())
            let navigationRequest = ModalNavigationRequest(viewController: addPaymentCardviewController)
            Current.navigate.to(navigationRequest)
        } settingsAction: {
            print("Settings tapped")
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
        CGSize(width: view.frame.width, height: 65)
    }
}


class WalletViewModel {
    var paymentAccounts: [CD_PaymentAccount]? {
        return Current.wallet.paymentAccounts
    }
    
    var loyaltyCards: [CD_LoyaltyCard]? {
        return Current.wallet.loyaltyCards
    }
    
    var numberSections: Int {
        var sections = 0
        
        if let _ = paymentAccounts {
            sections += 1
        }
        
        if let _ = loyaltyCards {
            sections += 1
        }
        return sections
    }
}
