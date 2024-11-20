//
//  TabBarController.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    let homeVC = HomeVC()
    let shopVC = ShopVC()
    let bagVC = BagVC()
    let searchVC = SearchVC()
    let userVC = UserVC()
    
    private let middleBtn = ButtonAnimation()
    private let myTabBar = CustomizedTabBar()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if !User.logged() && !defaults.bool(forKey: "BrowseAsAGuestKey") {
            let vc = WelcomeVC()
            let navi = NavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            
            tabBar.isHidden = true
            
            DispatchQueue.main.async {
                self.present(navi, animated: false) {
                    self.tabBar.isHidden = false
                    self.setupViews()
                }
            }
            
        } else {
            setupViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return
        }
        
        if index == 2 {
            tabBar.selectionIndicatorImage = UIImage()
        }
    }
}

// MARK: - Setups

extension TabBarController {
    
    private func setupViews() {
        setValue(myTabBar, forKey: "tabBar")
        
        let homeNav = NavigationController(rootViewController: homeVC)
        let shopNav = NavigationController(rootViewController: shopVC)
        let bagNav = NavigationController(rootViewController: bagVC)
        let searchNav = NavigationController(rootViewController: searchVC)
        let userNav = NavigationController(rootViewController: userVC)
        
        let titles = [
            "Home".localized(),
            "Shop".localized(),
            "",//"Bag".localized(),
            "Search".localized(),
            "Profile".localized()
        ]
        let homeImg = UIImage(named: "tabBar-home")
        let shopImg = UIImage(named: "tabBar-shop")
        //let bagImg = UIImage(named: "tabBar-bag")
        let searchImg = UIImage(named: "tabBar-search")
        let userImg = UIImage(named: "tabBar-user")
        
        homeVC.tabBarItem.image = homeImg
        homeVC.tabBarItem.selectedImage = homeImg
        
        shopVC.tabBarItem.image = shopImg
        shopVC.tabBarItem.selectedImage = shopImg
        
        //bagVC.tabBarItem.image = bagImg
        //bagVC.tabBarItem.selectedImage = bagImg
        
        searchVC.tabBarItem.image = searchImg
        searchVC.tabBarItem.selectedImage = searchImg
        
        userVC.tabBarItem.image = userImg
        userVC.tabBarItem.selectedImage = userImg
        
        viewControllers = [homeNav, shopNav, bagNav, searchNav, userNav]
        
        for i in 0..<tabBar.items!.count {
            tabBar.items![i].imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -2.0, right: 0.0)
            tabBar.items![i].title = titles[i]
        }
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 1.0
        tabBar.layer.shadowOpacity = 0.3
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = defaultColor
        tabBar.unselectedItemTintColor = .gray
        
        setupMiddleBtn()
    }
    
    private func setupMiddleBtn() {
        let size: CGFloat = screenWidth * (200/1000)
        let x: CGFloat = (view.bounds.width-size)/2.0
        let y: CGFloat = -size/2
        
        middleBtn.frame = CGRect(x: x, y: y, width: size, height: size)
        middleBtn.setBackgroundImage(UIImage(named: "tabBar-bagMiddle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        middleBtn.tintColor = .white
        middleBtn.backgroundColor = defaultColor
        middleBtn.clipsToBounds = true
        middleBtn.layer.cornerRadius = size/2.0
        middleBtn.layer.masksToBounds = false
        middleBtn.layer.shadowOffset = CGSize.zero
        middleBtn.layer.shadowRadius = 3.0
        middleBtn.layer.shadowColor = UIColor.black.cgColor
        middleBtn.layer.shadowOpacity = 0.3
        middleBtn.layer.shouldRasterize = true
        middleBtn.layer.rasterizationScale = UIScreen.main.scale
        middleBtn.delegate = self
        tabBar.addSubview(middleBtn)
        
        view.layoutIfNeeded()
    }
}

// MARK: - ButtonAnimationDelegate

extension TabBarController: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        selectedIndex = 2
        tabBar.selectionIndicatorImage = UIImage()
    }
}
