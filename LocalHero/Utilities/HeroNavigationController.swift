//
//  HeroNavigationController.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import Foundation
import UIKit

class HeroNavigationController: UINavigationController {
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(image: Asset.close.image, style: .plain, target: self, action: #selector(close))
        return closeButton
    }()
    
    private var isModallyPresented: Bool = false
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureUI()
    }
    
    convenience init(rootViewController: UIViewController, isModallyPresented: Bool = false, shouldShowCloseButton: Bool = true) {
        self.init(rootViewController: rootViewController)
        self.isModallyPresented = isModallyPresented
        if isModallyPresented && shouldShowCloseButton {
            rootViewController.navigationItem.rightBarButtonItem = closeButton
        }
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if isModallyPresented {
            viewController.navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = false, hidesBackButton: Bool = false, completion: EmptyCompletionBlock? = nil) {
        viewController.navigationItem.setHidesBackButton(hidesBackButton, animated: true)
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion?() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
    func popViewController(animated: Bool = false, completion: EmptyCompletionBlock? = nil) {
        popViewController(animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion?() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
    func popToRootViewController(animated: Bool = false, completion: EmptyCompletionBlock? = nil) {
        popToRootViewController(animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion?() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
//    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        viewControllerToPresent.title = "ASS"
//    }
//
    func configureUI() {
        navigationBar.standardAppearance = navBarAppearance()
        navigationBar.scrollEdgeAppearance = navBarAppearance()
        navigationBar.tintColor = .white
    }
    
    func navBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = UIColor(hexString: "#3b48ea", alpha: 0.94)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return appearance
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
