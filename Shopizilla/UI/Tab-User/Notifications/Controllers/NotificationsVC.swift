//
//  NotificationsVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/06/2022.
//

import UIKit

class NotificationsVC: UIViewController {
    
    //MARK: - Properties
    private let separatorView = UIView()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let readBtn = ButtonAnimation()
    let centerView = NotificationsCenterView()
    let notifView = NotifView()
    
    //Khi click thông báo đẩy, sẽ cuộn đến Item chứa UID này
    var notifUID = ""
    
    var hud: HUD?
    
    private var notificationsObs: Any?
    private var promoCodePopupVC: PromoCodePopupVC?
    
    private var viewModel: NotificationsViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
        
        viewModel.getNotifs()
        
        notificationsObs = NotificationCenter.default.addObserver(forName: .notificationsKey, object: nil, queue: nil) { _ in
            self.viewModel.getNotifs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.notifs.count == 0 {
            hud = HUD.hud(view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            removeObserverBy(observer: notificationsObs)
        }
    }
}

//MARK: - Setups

extension NotificationsVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications".localized()
        
        viewModel = NotificationsViewModel(vc: self)
        
        //TODO: - CenterView
        view.addSubview(centerView)
        
        centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 100.0
        tableView.register(NotificationsTVCell.self, forCellReuseIdentifier: NotificationsTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        //TODO: - NotifView
        notifView.setupViews(view)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - NavigationBar

extension NotificationsVC {
    
    private func setupNavi() {
        //TODO: - LeftView
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        rightView.clipsToBounds = true
        rightView.backgroundColor = .clear
        
        //TODO: - MenuBtn
        readBtn.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        readBtn.isHidden = true
        readBtn.clipsToBounds = true
        readBtn.setImage(UIImage(named: "icon-readAll")?.withRenderingMode(.alwaysTemplate), for: .normal)
        readBtn.tintColor = defaultColor
        readBtn.tag = 0
        readBtn.delegate = self
        rightView.addSubview(readBtn)
        
        //TODO: - UINavigationItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
}

//MARK: - ButtonAnimationDelegate

extension NotificationsVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //ReadAll
            guard let userUID = appDL.currentUser?.uid else { return }
            
            let array = viewModel.notifs.filter({ !$0.usersRead.contains(userUID) })
            
            guard array.count != 0 else { return }
            
            for i in 0..<array.count {
                array[i].updateRead(userUID: userUID) {
                    array[i].model.usersRead.append(userUID)
                    
                    if i == array.count-1 {
                        self.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension NotificationsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTVCell.id, for: indexPath) as! NotificationsTVCell
        viewModel.notificationsTVCell(cell, indexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let userUID = appDL.currentUser?.uid else { return }
        
        let notif = viewModel.notifs[indexPath.row]
        
        if !notif.usersRead.contains(userUID) {
            notif.updateRead(userUID: userUID) {
                self.viewModel.notifs[indexPath.row].model.usersRead.append(userUID)
                self.reloadData()
            }
        }
        
        switch notif.type {
        case PushNotification.NotifKey.Messages.rawValue:
            appDL.createChatVC(self, notifUID: notif.notifUID)
            
        case PushNotification.NotifKey.OrderUpdates.rawValue:
            appDL.createOrderHistoryVC(self, title: notif.title)
            
        case PushNotification.NotifKey.NewArrivals.rawValue:
            appDL.createProductVC(self, notifUID: notif.notifUID)
            
        case PushNotification.NotifKey.Promotions.rawValue:
            promoCodePopupVC?.removeFromParent()
            promoCodePopupVC = nil

            promoCodePopupVC = PromoCodePopupVC()
            promoCodePopupVC?.view.frame = kWindow.bounds
            promoCodePopupVC?.promoCodeUID = notif.notifUID
            promoCodePopupVC?.delegate = self
            kWindow.addSubview(promoCodePopupVC!.view)
            
        case PushNotification.NotifKey.SalesAlerts.rawValue:
            appDL.createProductVC(self, notifUID: notif.notifUID)
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

//MARK: - UIScrollViewDelegate

extension NotificationsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diffH = scrollView.contentSize.height - scrollView.contentOffset.y
        let pull = abs(diffH - scrollView.bounds.height)
        
        if pull <= 0.0 && viewModel.loading {
            viewModel.loading = false
            viewModel.getNotifs()
        }
    }
}

//MARK: - PromoCodePopupVCDelegate

extension NotificationsVC: PromoCodePopupVCDelegate {
    
    func copyPromoCode(_ vc: PromoCodePopupVC, promoCodeUID: String) {
        vc.removeHandler {
            self.notifView.setupNotifView("Copied Promo Code".localized())
            UIPasteboard.general.string = promoCodeUID
        }
    }
}
