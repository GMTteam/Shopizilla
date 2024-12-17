//
//  NotificationsViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 14/06/2022.
//

import UIKit
import Firebase

class NotificationsViewModel: NSObject {
    
    //MARK: - Properties
    private var vc: NotificationsVC
    
    lazy var notifs: [Notifications] = []
    var last: QueryDocumentSnapshot? //Tải thêm
    var loading = false //Đang tải
    
    //MARK: - Initializes
    init(vc: NotificationsVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension NotificationsViewModel {
    
    func getNotifs() {
        Notifications.fetchNotifs(last: last) { notifs, last in
            for notif in notifs {
                if !self.notifs.contains(where: { $0.uid == notif.uid }) {
                    self.notifs.append(notif)
                }
            }
            
            self.last = last
            self.vc.reloadData()
            self.vc.hud?.removeHUD {}
            
            self.vc.tableView.isHidden = self.notifs.count == 0
            self.vc.centerView.isHidden = self.notifs.count != 0
            
            if let userUID = appDL.currentUser?.uid {
                self.vc.readBtn.isHidden = self.notifs.filter({ $0.usersRead.contains(userUID) }).count == 0
            }
            
            if let index = self.notifs.firstIndex(where: { $0.notifUID == self.vc.notifUID }) {
                let indexPath = IndexPath(item: index, section: 0)
                
                DispatchQueue.main.async {
                    self.vc.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
}

//MARK: - SetupCell

extension NotificationsViewModel {
    
    func notificationsTVCell(_ cell: NotificationsTVCell, indexPath: IndexPath) {
        let notif = notifs[indexPath.row]
        
        cell.iconImageView.image = UIImage(named: "notif-notifPlaceholder")
        cell.titleLbl.text = notif.title
        cell.bodyLbl.text = notif.body
        cell.tag = indexPath.row
        
        if notif.type == PushNotification.NotifKey.Promotions.rawValue && notif.imageURL == "" {
            let isFree = notif.title == PromoCode.PromoType.Freeship.rawValue
            let imgName = isFree ? "bgFreeship" : "bgDiscount"
            cell.iconImageView.image = UIImage(named: "notif-\(imgName)")
        }
        
        if let date = longFormatter().date(from: notif.createdTime) {
            let f = createDateFormatter()
            f.dateFormat = "MMM dd, yyyy"
            
            cell.createdTimeLbl.text = f.string(from: date)
        }
        
        if notif.imageURL != "" {
            DownloadImage.shared.downloadImage(link: notif.imageURL) { image in
                if cell.tag == indexPath.row {
                    let newImage = SquareImage.shared.squareImage(image, targetSize: cell.iconImageView.frame.size)
                    cell.iconImageView.image = newImage
                }
            }
        }
        
        cell.containerView.backgroundColor = .black.withAlphaComponent(0.05)
            
        if let userUID = appDL.currentUser?.uid {
            cell.containerView.backgroundColor = !notif.usersRead.contains(userUID) ? .black.withAlphaComponent(0.05) : .white
        }
    }
}
