//
//  LeftMenuTVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 20/04/2022.
//

import UIKit
import MessageUI

protocol LeftMenuTVCDelegate: AnyObject {
    func categoryDidTap(_ category: String)
    func aboutUsDidTap()
    func informationDidTap()
    func loginDidTap()
}

class LeftMenuTVC: UITableViewController {

    //MARK: - Properties
    weak var delegate: LeftMenuTVCDelegate?
    
    var headerHeight: CGFloat = 0
    var selectedIndex = 0
    
    var tabbarC: TabBarController?
    
    lazy var models: [MenuModel] = {
        return MenuModel.shared()
    }()
    var selected = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Thêm Wishlist khi đăng nhập
        if User.logged(),
           let index = models.firstIndex(where: { $0.symbol == "category-" })
        {
            models[index].items.append(MenuItem(item: "Wishlist".localized(), image: UIImage(named: "leftMenu-wishlist"), symbol: "wishlist-"))
        }
        
        //Login: Nếu chưa đăng nhập
        //Logout: Nếu đã đăng nhập
        if let index = models.firstIndex(where: { $0.symbol == "feature-" }) {
            let item = User.logged() ? "Logout".localized() : "Login".localized()
            let imgName = User.logged() ? "leftMenu-signOut" : "leftMenu-signIn"
            let symbol = User.logged() ? "signOut-" : "signIn-"
            let image = UIImage(named: imgName)
            
            models[index].items[0] = MenuItem(item: item, image: image, symbol: symbol)
        }
        
        reloadData()
    }
}

//MARK: - Configures

extension LeftMenuTVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 60.0
        tableView.contentInset.bottom = appDL.isIPhoneX ? 0 : (44*2)+52
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(LeftMenuTVCell.self, forCellReuseIdentifier: LeftMenuTVCell.id)
        
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: menuWidth, height: 1.0))
        headerView.clipsToBounds = true
        headerView.backgroundColor = separatorColor
        
        tableView.tableHeaderView = headerView
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension LeftMenuTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTVCell.id, for: indexPath) as! LeftMenuTVCell
        let model = models[indexPath.section].items[indexPath.row]
        
        cell.titleLbl.text = model.item
        cell.iconImageView.image = model.image?.withRenderingMode(.alwaysTemplate)
        cell.arrowImageView.isHidden = models[indexPath.section].symbol == "feature-"
        cell.isSelect = selected == model.item
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension LeftMenuTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex = indexPath.row
        selected = models[indexPath.section].items[indexPath.row].item
        
        guard let vc = parent as? LeftMenuContainerVC else { return }

        vc.toggleSideMenu()
        removeEffect()

        delay(duration: 0.33) {
            switch self.models[indexPath.section].items[indexPath.row].symbol {
            case "instagram-":
                WebService.shared.goToInstagram()

            case "aboutU-s":
                DispatchQueue.main.async {
                    self.delegate?.aboutUsDidTap()
                }
            case "information-":
                DispatchQueue.main.async {
                    self.delegate?.informationDidTap()
                }
            case "support-":
                if MFMailComposeViewController.canSendMail() {
                    let vc = MFMailComposeViewController()
                    vc.mailComposeDelegate = self
                    vc.setSubject("Support".localized())
                    vc.setToRecipients([WebService.shared.getAPIKey().email])
                    self.present(vc, animated: true, completion: nil)
                }
                
            case "signOut-":
                User.signOut {}
            case "signIn-":
                DispatchQueue.main.async {
                    self.delegate?.loginDidTap()
                }
            default:
                DispatchQueue.main.async {
                    self.delegate?.categoryDidTap(self.selected)
                }
            }
        }
        
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 1 || section == 2) ? 1.0 : .zero
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: menuWidth, height: 1.0))
        kView.clipsToBounds = true
        kView.backgroundColor = UIColor(hex: 0xF6F6F6)
        return kView
    }
}

//MARK: - MFMailComposeViewControllerDelegate

extension LeftMenuTVC: MFMailComposeViewControllerDelegate {
    
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
