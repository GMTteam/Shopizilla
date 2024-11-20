//
//  SettingsVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 29/04/2022.
//

import UIKit
import MessageUI

class SettingsVC: UIViewController {
    
    //MARK: - Properties
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    lazy var models: [SettingModel] = {
        return SettingModel.shared()
    }()
    
    //Đã cho phép nhận thông báo trên thiết bị chưa
    private var isOn = false
    
    //Cho phép nhận các loại thông báo
    lazy var allNotif: [AllNotification] = []
    
    private var didBecomeActiveObs: Any?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        didBecomeActiveObs = NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            PushNotification.shared.configure { status in
                self.isOn = status == .authorized
                self.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        PushNotification.shared.configure { status in
            self.isOn = status == .authorized
            self.reloadData()
        }
        
        getNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: didBecomeActiveObs)
    }
}

//MARK: - Setups

extension SettingsVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Settings".localized()
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = separatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 60.0
        tableView.register(SettingsNotificationTVCell.self, forCellReuseIdentifier: SettingsNotificationTVCell.id)
        tableView.register(LeftMenuTVCell.self, forCellReuseIdentifier: LeftMenuTVCell.id)
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
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - GetData

extension SettingsVC {
    
    private func getNotifications() {
        CoreDataStack.fetchNotifications { array in
            self.allNotif = array
            self.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = models[indexPath.section].items[indexPath.item]
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsNotificationTVCell.id, for: indexPath) as! SettingsNotificationTVCell
            let id = item.symbol + "Key"
            
            cell.titleLbl.text = item.name
            cell.titleLbl.alpha = isOn ? 1.0 : 0.3
            cell.switchUI.alpha = isOn ? 1.0 : 0.3
            cell.switchUI.isUserInteractionEnabled = isOn
            cell.delegate = self
            cell.selectionStyle = .none
            
            //Nếu đã bật/tắt bên trong 'Settings'.
            if let notif = allNotif.first(where: { $0.id == id }) {
                cell.switchUI.isOn = notif.isOn
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTVCell.id, for: indexPath) as! LeftMenuTVCell
            
            cell.titleLbl.text = item.name
            cell.titleLbl.textColor = .black
            cell.iconImageView.isHidden = true
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTVCell.id, for: indexPath) as! LeftMenuTVCell
            
            cell.titleLbl.text = item.name
            cell.titleLbl.textColor = .black
            cell.iconImageView.isHidden = true
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title.uppercased()
    }
}

//MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.section].items[indexPath.item]
        
        switch item.symbol {
        case "instagram-": WebService.shared.goToInstagram()
        case "aboutUs-": goToAboutUsVC(self)
        case "information-": goToInformationVC(self)
            
        case "support-":
            if MFMailComposeViewController.canSendMail() {
                let vc = MFMailComposeViewController()
                vc.mailComposeDelegate = self
                vc.setSubject("Support")
                vc.setToRecipients([WebService.shared.getAPIKey().email])
                self.present(vc, animated: true, completion: nil)
            }
            
        case "review-": ratingAndReview()
        case "share-": self.share(appURL)
            
        default:
            //Nếu chưa bật thông báo trên thiết bị. Đi đến Cài Đặt trên thiết bị.
            if !isOn {
                PushNotification.shared.openSettings()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 60.0 : 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = section == 0 || section == 1 ? 60.0 : 40.0
        let rect = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: height)
        let headerView = UIView(frame: rect)
        headerView.backgroundColor = UIColor(hex: 0xF6F6F6)
        
        let titleLbl = UILabel(frame: CGRect(x: 20.0, y: 15.0, width: screenWidth-40, height: 30.0))
        titleLbl.font = UIFont(name: FontName.ppSemiBold, size: 17.0)
        titleLbl.textColor = .darkGray
        titleLbl.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        headerView.addSubview(titleLbl)
        
        return headerView
    }
}

//MARK: - SettingsNotificationTVCellDelegate

extension SettingsVC: SettingsNotificationTVCellDelegate {
    
    func switchDidTap(_ cell: SettingsNotificationTVCell, isOn: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            guard indexPath.section == 0 else {
                return
            }
            
            let item = models[indexPath.section].items[indexPath.item]
            let id = item.symbol + "Key"
            
            if indexPath.section == 0 {
                switch models[indexPath.section].items[indexPath.item].symbol {
                case "messages-": //Messages
                    guard let userID = appDL.currentUser?.uid else { return }
                    setupSubAndUnsub(isOn: isOn, topic: userID)

                case "orderUpdates-": //Order Updates
                    guard let userID = appDL.currentUser?.uid else { return }
                    let orderUpdates = userID + "-" + PushNotification.NotifKey.OrderUpdates.rawValue
                    setupSubAndUnsub(isOn: isOn, topic: orderUpdates)
                    
                case "newArrivals-": //New Arrivals
                    setupSubAndUnsub(isOn: isOn, topic: PushNotification.NotifKey.NewArrivals.rawValue)
                    
                case "promotions-": //Promotions
                    setupSubAndUnsub(isOn: isOn, topic: PushNotification.NotifKey.Promotions.rawValue)
                    
                case "salesAlerts-": //Sales Alerts
                    setupSubAndUnsub(isOn: isOn, topic: PushNotification.NotifKey.SalesAlerts.rawValue)
                    
                default: break
                }
            }

            CoreDataStack.updateNotificationBy(id: id, isOn: isOn)
            getNotifications()
        }
    }
    
    private func setupSubAndUnsub(isOn: Bool, topic: String) {
        if isOn {
            PushNotification.shared.subscribeToTopic(toTopic: topic)

        } else {
            PushNotification.shared.unsubscribeFromTopic(fromTopic: topic)
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate

extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled: print("Cancelled")
        case .saved: print("Saved")
        case .sent: print("Sent")
        case .failed: print("Failed")
        default: break
        }
        
        controller.dismiss(animated: true)
    }
}
