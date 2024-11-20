//
//  UserViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 05/05/2022.
//

import UIKit

class UserViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: UserVC
    
    //Nếu là Admin: thì kiểm tra đơn hàng đã đặt
    //Nếu là currentUser: thì nhắc đánh giá sản phẩm
    lazy var shoppingStatus: [ShoppingStatus] = []
    
    //Lấy các tin nhắn chưa đọc
    lazy var unreadChats: [Chat] = []
    
    //Lấy các thông báo chưa đọc cho trang Notifications
    lazy var unreadNotifs: [Notifications] = []
    
    //MARK: - Initializes
    init(vc: UserVC) {
        self.vc = vc
    }
}

//MARK: - Order Histories

extension UserViewModel {
    
    //Cho Admin
    func getOrderHistoriesForAdmin() {
        //Nếu tài khoản đăng nhập là Admin
        if User.isAdmin() {
            ShoppingCart.fetchAllShoppingCart { shoppingCarts in
                appDL.allShoppingCarts = shoppingCarts
                
                //Lấy mảng từ ShoppingCart
                let newArray = ShoppingStatus.getNewShoppingStatus(shoppings: shoppingCarts)
                let dict = Dictionary(grouping: newArray) { element in
                    return element.orderID
                }
                
                //Nhóm các đơn hàng giống nhau
                let newShoppingStatus = ShoppingStatus.getNewShoppingStatus(dict: dict)
                self.shoppingStatus = newShoppingStatus.filter({ $0.status == "1" })
                
                //Order History
                if let index = self.vc.models.firstIndex(where: { $0.index == 1 }) {
                    self.vc.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                
                NotificationCenter.default.post(name: .shoppingCartKey, object: nil)
            }
        }
    }
    
    //Cho User. Nhắc nhở đánh giá sản phẩm
    func getOrderHistoriesForCurrentUser() {
        //Nếu tài khoản đăng nhập là Admin
        if !User.isAdmin() {
            ShoppingCart.fetchShoppingCartByCurrentUser(status: "3") { shoppingCarts in
                //Lấy mảng từ ShoppingCart
                let newShoppingCarts = shoppingCarts.filter({ !$0.isReview })
                let newArray = ShoppingStatus.getNewShoppingStatus(shoppings: newShoppingCarts)
                
                let dict = Dictionary(grouping: newArray) { element in
                    return element.orderID
                }
                
                //Nhóm các đơn hàng giống nhau
                self.shoppingStatus = ShoppingStatus.getNewShoppingStatus(dict: dict)
                
                //Order History
                if let index = self.vc.models.firstIndex(where: { $0.index == 1 }) {
                    self.vc.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
}

//MARK: - Chats

extension UserViewModel {
    
    func getUnreadChats() {
        Chat.fetchUnread { chats in
            self.unreadChats = chats
            
            //Chat
            if let index = self.vc.models.firstIndex(where: { $0.index == 3 }) {
                self.vc.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}

//MARK: - Notifications

extension UserViewModel {
    
    func getUnreadNotif() {
        Notifications.fetchUnreadNotifs { notif in
            self.unreadNotifs = notif
            
            //Notifications
            if let index = self.vc.models.firstIndex(where: { $0.index == 5 }) {
                self.vc.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
            
            if self.unreadNotifs.count != 0 {
                NotificationCenter.default.post(name: .notificationsKey, object: nil)
            }
        }
    }
}

//MARK: - SetupCells

extension UserViewModel {
    
    func userTVCell(_ cell: UserTVCell, indexPath: IndexPath) {
        let model = vc.models[indexPath.row]
        cell.model = model
        cell.redView.isHidden = true
        
        if model.index == 1 { //Order History
            cell.redView.isHidden = shoppingStatus.count == 0
        }
        
        if model.index == 3 { //Chat
            cell.redView.isHidden = unreadChats.count == 0
        }
        
        if model.index == 5 { //Notifications
            cell.redView.isHidden = unreadNotifs.count == 0
        }
    }
}
