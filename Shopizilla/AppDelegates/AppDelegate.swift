//
//  AppDelegate.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import Stripe
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //TODO: - Device
    var isAllIPad = false
    var isIPadPro = false
    var isIPad11 = false
    var isIPad12 = false
    var isIPad = false
    
    var isIPhoneX = false
    var isIPhonePlus = false
    var isIPhone = false
    var isIPhone5 = false
    
    var adsCount = 0
    var isRandomAds = false
    var isNewGameAds = false
    
    //TODO: - Notification
    private let gcmMessageID = "gcm.message_id"
    var tokenKey = ""
    
    //TODO: - CoreData
    lazy var coreData = CoreDataStack(modelName: "Shopizilla")
    var purchase: Purchase? //Xóa cái này cho bản sạch
    
    //TODO: - Lấy thông tin
    var currentUser: User? //User khi đăng nhập
    lazy var allUsers: [User] = [] //Tất cả người dùng
    
    lazy var allCategories: [Category] = [] //Tất cả danh mục
    lazy var allProducts: [Product] = [] //Tất cả sản phẩm
    
    lazy var allShoppingCarts: [ShoppingCart] = [] //Cho Admin
    lazy var shoppings: [ShoppingCart] = [] //Giỏ hàng
    
    var badge = 0 //Cập nhật Badge
    private var promoCodePopupVC: PromoCodePopupVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //TODO: - Device
        setupDevices()
        
        //TODO: - Appearance
        setupAppeatance()
        
        //TODO: - FontName
        //UIFont.familyNames.forEach({ print(UIFont.fontNames(forFamilyName: $0)) })
        
        //TODO: - Firebase
        FirebaseApp.configure()
        
        //TODO: - Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //TODO: - Stripe
        StripeAPI.defaultPublishableKey = WebService.shared.getAPIKey().stripePublicKey
        
        //TODO: - Notification
        PushNotification.shared.configure { status in
            if status == .authorized {
                self.setupNotification(application)
            }
        }
        
        //TODO: - SignOut
        signOut()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Connect.connected(online: .offline)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

//MARK: - Notification

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)

        Messaging.messaging().token { token, error in
            if let error = error {
                let er = error as NSError
                print("Get token error: \(er.localizedDescription)")

            } else {
                self.tokenKey = token ?? ""
                print("tokenKey: \(self.tokenKey)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
        let mesID = userInfo[gcmMessageID] as? String ?? ""
        print("messageID: \(mesID)")
        
        application.applicationIconBadgeNumber = 0
        
        let dict = userInfo as NSDictionary
        
        switch application.applicationState {
        case .active: print("active: \(dict)")
        case .inactive: setupPresentScene(userInfo)
        case .background: print("background")
        default: break
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let er = error as NSError
        print("didFailToRegisterForRemoteNotificationsWithError: \(er.localizedDescription)")
    }
    
    /*
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let fbBool = ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [UIApplication.OpenURLOptionsKey.annotation])
        let ggBool = GIDSignIn.sharedInstance.handle(url)
        let authBool = Auth.auth().canHandle(url)
        let appBool = application(app, open: url, options: options)
        return fbBool || ggBool || authBool || appBool
    }
    */
}

//MARK: - Setups

extension AppDelegate {
    
    private func setupDevices() {
        //TODO: - UIDevice
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            isAllIPad = true
            
            switch UIScreen.main.nativeBounds.height {
            case 2388: isIPad11 = true; break
            case 2732: isIPad12 = true; break
            default: isIPadPro = true; break
            }
            
            if isIPad12 || isIPadPro {
                isIPad = true
            }
            
        case .phone:
            switch UIScreen.main.nativeBounds.height {
            case 2688, 1792, 2436: isIPhoneX = true; break
            case 2208, 1920: isIPhonePlus = true; break
            case 1334: isIPhone = true; break
            case 1136: isIPhone5 = true; break
            default: isIPhoneX = true; break
            }
        case .tv: break
        default: break
        }
        
        //TODO: - Purchase
        let name = WebService.shared.getDictFrom("AES.plist")["name"] as? String ?? ""
        
        if let dict = WebService.shared.getJSONFile(WebService.shared.purchaseName) as? NSDictionary {
            purchase = Purchase(dict: dict)
            
            if purchase?.name != name {
                purchase = nil
            }
        }
        
        purchase = Purchase(model: PurchaseModel(amount: "", soldAt: "", license: "", supportAmount: "", supportedUntil: "", buyer: "", purchaseCount: 0, id: 0, name: name, authorUsername: "", updatedAt: "", site: "", priceCents: 0, publishedAt: ""))
    }
    
    private func setupAppeatance() {
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().isTranslucent = false
        
        let norAtt = createAttributedString(fgColor: .black)
        let disAtt = createAttributedString(fgColor: .gray)
        
        UIBarButtonItem.appearance().tintColor = defaultColor
        UIBarButtonItem.appearance().setTitleTextAttributes(norAtt, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(disAtt, for: .disabled)
    }
    
    func setupNotification(_ app: UIApplication) {
        let current = UNUserNotificationCenter.current()
        let op: UNAuthorizationOptions = [.alert, .sound, .badge]

        current.requestAuthorization(options: op) { granted, error in
            guard granted, error == nil else {
                return
            }

            DispatchQueue.main.async {
                app.registerForRemoteNotifications()
            }

            let act = UNNotificationAction(identifier: "OpenNotif", title: "Act", options: .foreground)
            let cat = UNNotificationCategory(identifier: "categoryNotif", actions: [act], intentIdentifiers: [], options: [])
            current.setNotificationCategories([cat])

            current.delegate = self
            Messaging.messaging().delegate = self
            
            //Đăng ký nhận thông báo đẩy
            if !defaults.bool(forKey: "SubscribeNotfKey") {
                defaults.set(true, forKey: "SubscribeNotfKey")
                
                self.subscribeNotification()
            }
        }
    }
    
    ///Đăng ký nhận thông báo
    private func subscribeNotification() {
        if let userID = Auth.auth().currentUser?.uid {
            PushNotification.shared.subscribeToTopic(toTopic: userID)
            
            let orderUpdates = userID + "-" + PushNotification.NotifKey.OrderUpdates.rawValue
            PushNotification.shared.subscribeToTopic(toTopic: orderUpdates)
        }
        
        let newArrivals = PushNotification.NotifKey.NewArrivals.rawValue
        PushNotification.shared.subscribeToTopic(toTopic: newArrivals)
        
        let promotions = PushNotification.NotifKey.Promotions.rawValue
        PushNotification.shared.subscribeToTopic(toTopic: promotions)
        
        let salesAlerts = PushNotification.NotifKey.SalesAlerts.rawValue
        PushNotification.shared.subscribeToTopic(toTopic: salesAlerts)
    }
    
    private func signOut() {
        if !defaults.bool(forKey: User.signOutKey) {
            LoginManager().logOut()
            
            do {
                try Auth.auth().signOut()
                
            } catch let error as NSError {
                print("signOut error: \(error.localizedDescription)")
            }
            
            defaults.set(true, forKey: User.signOutKey)
            defaults.synchronize()
        }
    }
    
    func whenSignOut() {
        currentUser = nil
        badge = 0
        
        shoppings.removeAll()
        allShoppingCarts.removeAll()
        allUsers.removeAll()
        
        ShoppingCart.removeObserver()
        ShoppingCart.removeObserverAdmin()
        
        Wishlist.removeObserver()
        Connect.removeObserver()
        Notifications.removeObserver()
        
        Chat.removeObserver()
        Chat.removeConversationObserver()
        Chat.removeReadObserver()
    }
}

//MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let mesID = userInfo[gcmMessageID] as? String ?? ""
        print("willPresent messageID: \(mesID)")

        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([.sound, .alert, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let mesID = userInfo[gcmMessageID] as? String ?? ""
        print("didReceive messageID: \(mesID)")

        setupPresentScene(userInfo)

        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
    
    private func setupPresentScene(_ userInfo: [AnyHashable: Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let key = "gcm.notification."
        let type = userInfo[key + "type"] as? String ?? ""
        let notifUID = userInfo[key + "notifUID"] as? String ?? ""
        
        if let viewController = sceneDL.getParentVC() {
            if type == PushNotification.NotifKey.Messages.rawValue {
                createChatVC(viewController, notifUID: notifUID)
                
            } else if type == PushNotification.NotifKey.OrderUpdates.rawValue {
                if let aps = userInfo["aps"] as? NSDictionary,
                    let alert = aps["alert"] as? NSDictionary,
                    let title = alert["title"] as? String
                {
                    self.createOrderHistoryVC(viewController, title: title)
                }
                
            } else if type == PushNotification.NotifKey.NewArrivals.rawValue {
                createProductVC(viewController, notifUID: notifUID)
                
            } else if type == PushNotification.NotifKey.Promotions.rawValue {
                promoCodePopupVC?.removeFromParent()
                promoCodePopupVC = nil

                promoCodePopupVC = PromoCodePopupVC()
                promoCodePopupVC?.view.frame = kWindow.bounds
                promoCodePopupVC?.promoCodeUID = notifUID
                promoCodePopupVC?.delegate = self
                kWindow.addSubview(promoCodePopupVC!.view)
                
            } else if type == PushNotification.NotifKey.SalesAlerts.rawValue {
                createProductVC(viewController, notifUID: notifUID)
            }
        }
    }
    
    func createChatVC(_ viewController: UIViewController, notifUID: String) {
        let vc = ChatVC()
        vc.notifUID = notifUID
        vc.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createProductVC(_ viewController: UIViewController, notifUID: String) {
        if let product = appDL.allProducts.first(where: { $0.uid == notifUID }) {
            goToProductVC(viewController: viewController, product: product)
            
        } else {
            Product.fetchProduct(uid: notifUID) { product in
                if let product = product {
                    goToProductVC(viewController: viewController, product: product)
                }
            }
        }
    }
    
    func createOrderHistoryVC(_ viewController: UIViewController, title: String) {
        func goToOrderHistoryVC(_ currentUser: User) {
            let vc = OrderHistoryVC()
            vc.selectedStatus = StatusModel.shared().first(where: { $0.title == title })
            vc.currentUser = currentUser
            vc.hidesBottomBarWhenPushed = true
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let currentUser = appDL.currentUser {
            goToOrderHistoryVC(currentUser)
            
        } else {
            if let userUID = Auth.auth().currentUser?.uid {
                User.fetchUser(userUID: userUID, isListener: false) { currentUser in
                    if let currentUser = currentUser {
                        goToOrderHistoryVC(currentUser)
                    }
                }
            }
        }
    }
}

//MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        tokenKey = fcmToken ?? ""
        print("messaging tokenKey: \(tokenKey)")

        let userInfo: [String: Any] = ["token": tokenKey]
        NotificationCenter.default.post(name: .fcmToken, object: nil, userInfo: userInfo)
        
        if let userUID = Auth.auth().currentUser?.uid {
            User.updateTokenKey(userUID: userUID) { error in
                if let error = error {
                    print("updateTokenKey error: \(error.localizedDescription)")
                }
            }
        }
    }
}

//MARK: - PromoCodePopupVCDelegate

extension AppDelegate: PromoCodePopupVCDelegate {
    
    func copyPromoCode(_ vc: PromoCodePopupVC, promoCodeUID: String) {
        vc.removeHandler {
            UIPasteboard.general.string = promoCodeUID
        }
    }
}
