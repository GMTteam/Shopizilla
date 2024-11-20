//
//  PushNotification.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 10/12/2021.
//

import UIKit
import Firebase
import UserNotificationsUI

class PushNotification: NSObject {
    
    static let shared = PushNotification()
    
    enum Operation: String {
        case create = "create"
        case add = "add"
        case remove = "remove"
    }
    
    enum NotifKey: String {
        case Messages
        case OrderUpdates
        case NewArrivals
        case Promotions
        case SalesAlerts
    }
    
    private var senderID: String {
        return WebService.shared.getAPIKey("GoogleService-Info.plist").senderID
    }
    private var serverKey: String {
        return WebService.shared.getAPIKey().serverKey
    }
    
    private let fcmLink = "https://fcm.googleapis.com/fcm"
    
    private override init() {
        super.init()
    }
}

//MARK: - Subscribe / unsubscribe

extension PushNotification {
    
    ///Đăng ký nhận thông báo cho một User
    func subscribeToTopic(toTopic: String) {
        Messaging.messaging().subscribe(toTopic: toTopic)
    }
    
    ///Hủy nhận thông báo
    func unsubscribeFromTopic(fromTopic: String) {
        Messaging.messaging().unsubscribe(fromTopic: fromTopic)
    }
}

//MARK: - Configure

extension PushNotification {
    
    func configure(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined: completion(.notDetermined)
            case .denied: completion(.denied)
            case .authorized: completion(.authorized)
            default: break
            }
        }
    }
}

//MARK: - Open Settings

extension PushNotification {
    
    ///Mở màn hình Settings cài đặt Notifications
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - Send Push Notification To

extension PushNotification {
    
    private func makeURLRequest() -> URLRequest? {
        let str = fcmLink + "/send"
        guard let url = URL(string: str) else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        return request
    }
    
    ///Gửi thông báo đẩy đến 1 người dùng cụ thể
    func sendPushNotifToChat(toUID: String, title: String, body: String, imageLink: String, notifUID: String, type: String) {
        guard var request = makeURLRequest() else {
            return
        }
        
        let dict: [String: Any] = [
            "to": "/topics/\(toUID)",
            "notification": [
                "title": title,
                "body": body,
                "sound": "default",
                "badge": 1,
                "mutable-content": 1,
                "image": imageLink,
                "notifUID": notifUID,
                "type": type,
            ]
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
            return
        }
        request.httpBody = data
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("sendToUser: \(json)")
                    
                } catch let error as NSError {
                    print("dataTask error: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    ///Gửi thông báo đẩy đến tokenKey
    func sendPushNotifToTokenKey(tokenKey: String, title: String, body: String, imageLink: String, notifUID: String, type: String) {
        guard var request = makeURLRequest() else {
            return
        }
        
        let dict: [String: Any] = [
            "to": tokenKey,
            "notification": [
                "title": title,
                "body": body,
                "sound": "default",
                "badge": 1,
                "mutable-content": 1,
                "image": imageLink,
                "notifUID": notifUID,
                "type": type,
            ]
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
            return
        }
        request.httpBody = data
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("sendToUser: \(json)")
                    
                } catch let error as NSError {
                    print("dataTask error: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}

//MARK: - Create Notifications To The Group

extension PushNotification {
    
    ///Tạo một khoá mới để gửi thông báo cho nhóm. Hoặc thêm, xoá thông báo từ thành viên trong nhóm
    func createKeyForGroup(operation: Operation = .create, keyName: String, key: String = "", tokenKeys: [String], completion: @escaping (String) -> Void) {
        let link = "\(fcmLink)/notification"
        guard let url = URL(string: link) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue(senderID, forHTTPHeaderField: "project_id")
        request.httpMethod = "POST"
        
        let par: [String: Any]
        if operation == .create {
            //Tạo mới một key
            par = [
                //Create
                "operation": operation.rawValue,
                
                //Đặt tên cho key. Dùng keyName và keyGroup để thêm thành viên hoặc xoá
                "notification_key_name": keyName,
                
                //Danh sách các tokenKeys để đăng ký nhận thông báo cho Group
                "registration_ids": tokenKeys
            ]
            
        } else {
            //Thêm or xoá key
            par = [
                //Remove or Add
                "operation": operation.rawValue,
                
                //Key cho group đã tạo. keyGroup
                "notification_key": key,
                
                //Tên của key
                "notification_key_name": keyName,
                
                //Các tokenKeys đã đăng ký cho nhóm
                "registration_ids": tokenKeys
            ]
        }
        
        //Lưu notification_key_name && notification_key
        //Để lấy lại key và gửi thông báo cho nhóm
        
        guard let data = try? JSONSerialization.data(withJSONObject: par, options: [.prettyPrinted]) else {
            return
        }
        request.httpBody = data
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var notifKey = ""
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                        notifKey = json["notification_key"] as? String ?? ""
                        print("POST: \(notifKey)")
                    }
                    
                } catch let error as NSError {
                    print("createKeyForGroup error: \(error.localizedDescription)")
                }
            }
            
            completion(notifKey)
        }
        
        task.resume()
    }
    
    ///Lấy 'notification_key' đã tạo. Dùng để gửi thông báo cho nhóm
    func retrievingNotificationKey(keyName: String, completion: @escaping (String) -> Void) {
        let link = "\(fcmLink)/notification?notification_key_name=\(keyName)"
        guard let url = URL(string: link) else { completion(""); return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue(senderID, forHTTPHeaderField: "project_id")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var key = ""
            
            guard error == nil, let data = data else { return }
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    key = json["notification_key"] as? String ?? ""
                    print("GET: \(key)")
                }
                
            } catch let error as NSError {
                print("retrievingNotificationKey error: \(error.localizedDescription)")
            }
            
            completion(key)
        }
        
        task.resume()
    }
}
