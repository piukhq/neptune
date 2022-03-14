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
//        collectionView.contentInset = LayoutHelper.WalletDimensions.contentInset
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private var viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Current.wallet.launch()
        configureCollectionView()

//        let addPaymentCardviewController = AddPaymentAccountViewController(viewModel: AddPaymentAccountViewModel())
//        let navigationRequest = ModalNavigationRequest(viewController: addPaymentCardviewController)
//        Current.navigate.to(navigationRequest)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.paymentAccounts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WalletCollectionViewCell = collectionView.dequeue(indexPath: indexPath)
        guard let paymentAccount = viewModel.paymentAccounts?[safe: indexPath.item] else { return cell }
        cell.configure(with: paymentAccount)
        return cell
    }
}


class WalletViewModel {
    var paymentAccounts: [PaymentAccountResponseModel]? {
        return Current.wallet.paymentAccounts
    }
}
