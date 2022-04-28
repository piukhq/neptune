//
//  WalletCardDetailsViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 04/04/2022.
//

import UIKit

class WalletCardDetailsViewController: LocalHeroViewController {
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right:20)
        textView.text = viewModel.cardDetailsText
        view.addSubview(textView)
        return textView
    }()
    
    var viewModel: WalletCardDetailsViewModel
    
    init(viewModel: WalletCardDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        title = viewModel.title
    }
}
