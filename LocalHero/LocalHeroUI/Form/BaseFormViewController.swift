//
//  BaseFormViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import UIKit

class BaseFormViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var collectionView: NestedCollectionView = {
        let collectionView = NestedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = dataSource
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(FormCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()

    var dataSource: FormDataSource {
        didSet {
            collectionView.dataSource = dataSource
            collectionView.reloadData()
        }
    }
    
    init(dataSource: FormDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}

extension BaseFormViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FormCollectionViewCell else { return }
        
        cell.setWidth(collectionView.frame.size.width)
    }
}

class NestedCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
