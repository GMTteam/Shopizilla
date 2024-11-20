//
//  NavigationController.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit

class NavigationController: UINavigationController {

    //MARK: - Properties
    private var duringPushAnim = false
    
    var darkBarStyle = false
    var barHidden = false
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkBarStyle ? .lightContent : .darkContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return barHidden
    }
}

//MARK: - Setups

extension NavigationController {
    
    private func setupViews() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = nil
        
        navigationBar.barTintColor = .white
        navigationBar.tintColor = defaultColor
        navigationBar.isTranslucent = false
        
        let titleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 18.0)!,
            .foregroundColor: UIColor.black
        ]
        let barNorTitleAttr = createAttributedString(fgColor: .black)
        let barDisTitleAttr = createAttributedString(fgColor: .lightGray)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = titleAttr
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray.withAlphaComponent(0.5)

        let barBtn = UIBarButtonItemAppearance(style: .plain)
        barBtn.normal.titleTextAttributes = barNorTitleAttr
        barBtn.disabled.titleTextAttributes = barDisTitleAttr
        appearance.buttonAppearance = barBtn

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

//MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipe = navigationController as? NavigationController else {
            return
        }
        swipe.duringPushAnim = true
    }
}

//MARK: - UIGestureRecognizerDelegate

extension NavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        return viewControllers.count > 1 && !duringPushAnim
    }
}
