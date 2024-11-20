//
//  UserVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit

class UserVC: UIViewController {

    // MARK: - Properties
    private let menuBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    
    private let loginBtn = ButtonAnimation()
    private let separatorView = UIView()
    let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UserHeaderView()
    
    private var menuContainerVC: LeftMenuContainerVC?
    
    lazy var models: [ProfileModel] = {
        return ProfileModel.shared()
    }()
    
    private var viewModel: UserViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
        addObserver()
        
        viewModel.getOrderHistoriesForAdmin()
        viewModel.getOrderHistoriesForCurrentUser()
        viewModel.getUnreadChats()
        viewModel.getUnreadNotif()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        updateBadge(appDL.badge)
        
        loginBtn.isHidden = User.logged()
        tableView.isHidden = !User.logged()
        
        if let currentUser = appDL.currentUser {
            headerView.updateUI(user: currentUser)
        }
    }
}

// MARK: - Setups

extension UserVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Profile".localized()
        
        viewModel = UserViewModel(vc: self)
        
        //TODO: - LoginBtn
        setupTitleForBtn(loginBtn, txt: "Login".localized(), bgColor: defaultColor, fgColor: .white)
        loginBtn.isHidden = true
        loginBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 25.0
        loginBtn.tag = 2
        loginBtn.delegate = self
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            loginBtn.widthAnchor.constraint(equalToConstant: screenWidth-40),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.rowHeight = 70.0
        tableView.isHidden = true
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset.bottom = spBottom
        tableView.register(UserTVCell.self, forCellReuseIdentifier: UserTVCell.id)
        tableView.register(UserLogoutTVCell.self, forCellReuseIdentifier: UserLogoutTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let profW: CGFloat = screenWidth*0.3
        let headerH: CGFloat = 20 + profW + 20 + 40 + 20
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: headerH)
        tableView.tableHeaderView = headerView
        
        tableView.setupConstraint(superView: view, subview: separatorView)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - NavigationBar

extension UserVC {
    
    private func setupNavi() {
        //TODO: - LeftView
        let leftView = createLeftView(menuBtn)
        menuBtn.delegate = self
        
        //TODO: - RightView
        let rightView = createRightView(bagBtn, badgeLbl)
        bagBtn.delegate = self
        
        //TODO: - UINavigationItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    
    func updateBadge(_ badge: Int) {
        let bagImg = UIImage(named: badge == 0 ? "icon-bagRight" : "icon-bagCenter")
        bagBtn.setImage(bagImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        bagBtn.tintColor = defaultColor
        
        badgeLbl.isHidden = badge == 0
        badgeLbl.text = "\(badge)"
    }
}

// MARK: - AddObserver

extension UserVC {
    
    private func addObserver() {
        //Cập nhật Pos cho LeftMenu mỗi khi app hoạt động trong nền
        NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if let vc = self.menuContainerVC {
                vc.centerVC.view.frame.origin.x = vc.xPos
            }
        }
        NotificationCenter.default.addObserver(forName: .signInKey, object: nil, queue: nil) { _ in
            self.loginBtn.isHidden = User.logged()
            self.tableView.isHidden = !User.logged()
            
            self.headerView.updateUI(user: appDL.currentUser)
        }
        NotificationCenter.default.addObserver(forName: .signOutKey, object: nil, queue: nil) { _ in
            appDL.whenSignOut()
            
            self.loginBtn.isHidden = User.logged()
            self.tableView.isHidden = !User.logged()
            
            self.updateBadge(appDL.badge)
            self.headerView.updateUI(user: nil)
            
            self.viewModel.shoppingStatus.removeAll()
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
        NotificationCenter.default.addObserver(forName: .bagKey, object: nil, queue: nil) { _ in
            self.updateBadge(appDL.badge)
        }
        NotificationCenter.default.addObserver(forName: .shoppingCartKey, object: nil, queue: nil) { _ in
            self.viewModel.getOrderHistoriesForCurrentUser()
            
            if User.isAdmin() {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            }
        }
    }
}

// MARK: - ButtonAnimationDelegate

extension UserVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Menu
            removeMenuContainerView(menuContainerVC)
            menuContainerVC = createMenuContainerView(tabBarController, navigationController, self, self)
            
        } else if sender.tag == 1 { //Bag
            tabBarController?.selectedIndex = 2
            
        } else if sender.tag == 2 { //LoginBtn
            goToWelcomeVC(self)
        }
    }
}

//MARK: - MenuContainerVCDelegate

extension UserVC: LeftMenuContainerVCDelegate {
    
    func completionAnim(_ isComplete: Bool) {
        createEffect(isComplete, vc: self, selector: #selector(handlerRemoveMenu))
        
        if !isComplete {
            removeMenuContainerView(menuContainerVC)
        }
    }
    
    @objc private func handlerRemoveMenu() {
        menuContainerVC?.toggleSideMenu()
        removeEffect()
    }
}

//MARK: - SideMenuTVCDelegate

extension UserVC: LeftMenuTVCDelegate {
    
    func categoryDidTap(_ category: String) {
        goToCategoryDetail(viewController: self, category: category)
    }
    
    func aboutUsDidTap() {
        goToAboutUsVC(self)
    }
    
    func informationDidTap() {
        goToInformationVC(self)
    }
    
    func loginDidTap() {
        goToWelcomeVC(self)
    }
}

// MARK: - UITableViewDataSource

extension UserVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? models.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTVCell.id, for: indexPath) as! UserTVCell
            viewModel.userTVCell(cell, indexPath: indexPath)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserLogoutTVCell.id, for: indexPath) as! UserLogoutTVCell
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension UserVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        guard let currentUser = appDL.currentUser else {
            return
        }
        
        if indexPath.section == 0 {
            let model = models[indexPath.row]
            
            switch model.index {
            case 0: //Account Details
                let vc = EditProfileVC()
                vc.currentUser = currentUser
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 1: //Order History
                let vc = OrderHistoryVC()
                vc.currentUser = currentUser
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 2: //Wishlist
                goToWishlist(viewController: self)
                
            case 3: //Chat
                if User.isAdmin() {
                    let vc = ConversationVC()
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc = ChatVC()
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            case 4: //Address
                let vc = AddressVC()
                vc.currentUser = currentUser
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 5: //Notifications
                let vc = NotificationsVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 6: //Settings
                let vc = SettingsVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight + (indexPath.section == 0 ? 0 : 20)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}
