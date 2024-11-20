//
//  Notification+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 18/12/2021.
//

import UIKit

extension Notification.Name {
    
    static let fcmToken = Notification.Name("FCMToken")
    static let signOutKey = Notification.Name("SignOutKey") //Khi đăng xuất
    static let signInKey = Notification.Name("SignInKey") //Khi đăng nhập
    static let verificationKey = Notification.Name("VerificationKey")
    
    static let shortLinkKey = Notification.Name("ShortLinkKey")
    static let firstTimeKey = Notification.Name("FirstTimeKey")
    static let notificationsKey = Notification.Name("NotificationsKey")
    
    //PayPal
    static let payPalKey = Notification.Name("PayPalKey")
    
    //CoreData
    static let searchHistoryKey = Notification.Name("SearchHistoryKey")
    static let recentlyViewedKey = Notification.Name("RecentlyViewedKey")
    
    //Cập nhật số cho giỏ hàng
    static let bagKey = Notification.Name("BagKey")
    
    //Khi đã đặt hàng. Và truy cập trang SuccessVC
    static let orderCompletedKey = Notification.Name("OrderCompletedKey")
    
    //Khi đã đặt hàng. Nếu sử dụng PromoCode. Trả về giá trị NULL cho promoCode
    static let placeOrderKey = Notification.Name("PlaceOrderKey")
    
    //Cho Admin
    static let shoppingCartKey = Notification.Name("ShoppingCartKey")
    
    static let keyboardWillShow = UIResponder.keyboardWillShowNotification
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification
    
    static let didEnterBackground = UIApplication.didEnterBackgroundNotification
    static let didBecomeActive = UIApplication.didBecomeActiveNotification
    static let willTerminate = UIApplication.willTerminateNotification
}
