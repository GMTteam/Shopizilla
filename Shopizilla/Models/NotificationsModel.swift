//
//  NotificationsModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 14/06/2022.
//

import UIKit
import Firebase

struct NotificationsModel {
    
    var uid: String = "" //AutoID
    var createdTime: String = ""
    
    let title: String
    let body: String
    let notifUID: String //ID của tin nhắn. Hay đơn hàng. Hay của Product
    let imageURL: String //Hình ảnh của thông báo
    var usersRead: [String] = [] //Thêm những người dùng đã xem thông báo vào đây
    let type: String //Loại thông báo gì
}

class Notifications {
    
    var model: NotificationsModel
    
    var uid: String { return model.uid }
    var createdTime: String { return model.createdTime }
    
    var title: String { return model.title }
    var body: String { return model.body }
    var notifUID: String { return model.notifUID }
    var imageURL: String { return model.imageURL }
    var usersRead: [String] { return model.usersRead }
    var type: String { return model.type }
    
    static let db = Firestore.firestore().collection("Notifications")
    static var listener: ListenerRegistration?
    
    init(model: NotificationsModel) {
        self.model = model
    }
}

extension Notifications {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let createdTime = dict["createdTime"] as? String ?? ""
        let title = dict["title"] as? String ?? ""
        let body = dict["body"] as? String ?? ""
        let notifUID = dict["notifUID"] as? String ?? ""
        let imageURL = dict["imageURL"] as? String ?? ""
        let usersRead = dict["usersRead"] as? [String] ?? []
        let type = dict["type"] as? String ?? ""
        
        let model = NotificationsModel(uid: uid,
                                       createdTime: createdTime,
                                       title: title,
                                       body: body,
                                       notifUID: notifUID,
                                       imageURL: imageURL,
                                       usersRead: usersRead,
                                       type: type)
        self.init(model: model)
    }
}

//MARK: - Save

extension Notifications {
    
    func saveNotif(completion: @escaping () -> Void) {
        let db = Notifications.db
        
        model.uid = db.document().documentID
        model.createdTime = longFormatter().string(from: Date())
        
        let ref = db.document(uid)
        
        ref.setData(toDictionary()) { error in
            if let error = error {
                print("saveNotif error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "createdTime": createdTime,
            "title": title,
            "body": body,
            "notifUID": notifUID,
            "imageURL": imageURL,
            "usersRead": usersRead,
            "type": type
        ]
    }
    
    class func removeObserver() {
        listener?.remove()
        listener = nil
    }
}

//MARK: - Update

extension Notifications {
    
    func updateRead(userUID: String, completion: @escaping () -> Void) {
        let ref = Notifications.db.document(uid)
        
        ref.updateData(["usersRead": FieldValue.arrayUnion([userUID])]) { error in
            if let error = error {
                print("updateRead error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}

//MARK: - Fetch

extension Notifications {
    
    ///Lấy các thông báo chưa đọc
    class func fetchUnreadNotifs(completion: @escaping ([Notifications]) -> Void) {
        guard let user = appDL.currentUser else {
            completion([])
            return
        }
        
        let ref = Notifications.db
            .whereField("createdTime", isGreaterThanOrEqualTo: user.createdTime)
            .order(by: "createdTime", descending: true)
            .limit(to: 10)
        
        removeObserver()
        
        listener = ref.addSnapshotListener({ snapshot, error in
            var newArray: [Notifications] = []
            
            if let error = error {
                print("fetchNotifs error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                newArray = snapshot.documents
                    .map({ Notifications(dict: $0.data()) })
                    .filter({ !$0.usersRead.contains(user.uid) })
            }
            
            DispatchQueue.main.async {
                completion(newArray)
            }
        })
    }
    
    ///Lấy 20 thông báo gần nhất cho trang Notifications. Và tải thêm...
    class func fetchNotifs(last: QueryDocumentSnapshot?, completion: @escaping ([Notifications], QueryDocumentSnapshot?) -> Void) {
        guard let user = appDL.currentUser else {
            completion([], nil)
            return
        }
        
        var query = Notifications.db
            .whereField("createdTime", isGreaterThanOrEqualTo: user.createdTime)
            .order(by: "createdTime", descending: true)
            .limit(to: 30)
        
        if let last = last {
            query = query.start(afterDocument: last)
        }
        
        query.getDocuments { snapshot, error in
            var newArray: [Notifications] = []
            var last: QueryDocumentSnapshot?
            
            if let error = error {
                print("fetchNotifs error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                last = snapshot.documents.last
                newArray = snapshot.documents.map({ Notifications(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(newArray, last)
            }
        }
    }
}
