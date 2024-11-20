//
//  ConnectModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 05/04/2022.
//

import UIKit
import Firebase

struct ConnectModel {
    
    let deviceUID: String
    let lastTime: String
    let online: String
    
    enum OnlineKey: String {
        /*
         0. Đang Off
         1. Đang bận
         2. Đang On
         */
        
        case offline = "0"
        case busy = "1"
        case online = "2"
    }
}

class Connect {
    
    private let model: ConnectModel
    
    var deviceUID: String { return model.deviceUID }
    var lastTime: String { return model.lastTime }
    var online: String { return model.online }
    
    static var listener: ListenerRegistration? //Người dùng hiện tại
    
    init(model: ConnectModel) {
        self.model = model
    }
}

extension Connect {
    
    convenience init(dict: [String: Any]) {
        let deviceUID = dict["deviceUID"] as? String ?? ""
        let online = dict["online"] as? String ?? ""
        let lastTime = dict["lastTime"] as? String ?? ""
        
        let model = ConnectModel(deviceUID: deviceUID, lastTime: lastTime, online: online)
        self.init(model: model)
    }
}

//MARK: - Connect-Disconnect

extension Connect {
    
    ///Giá trị 'online'
    ///0: Đang Off. 1: Đang bận. 2: Đang On
    class func connected(online: ConnectModel.OnlineKey) {
        if let userUID = defaults.string(forKey: "UserUID") {
            let db = User.db
                .document(userUID)
                .collection("connections")
                .document(deviceUUID)
            let dict: [String: Any] = [
                "online": online.rawValue,
                "lastTime": longFormatter().string(from: Date()),
                "deviceUUID": deviceUUID,
            ]
            db.setData(dict) { error in
                if let error = error {
                    print("*** connected error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    ///Lấy trạng thái Online OR Offline
    class func fetchConnected(userUID: String, completion: @escaping (Connect?) -> Void) {
        let db = User.db
            .document(userUID)
            .collection("connections")
            .order(by: "lastTime", descending: true)
        
        removeObserver()
        
        listener = db.addSnapshotListener { snapshot, error in
            var connect: Connect?
            
            if let error = error {
                print("fetchConnected error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                connect = snapshot.documents.map({ Connect(dict: $0.data()) }).first
            }
            
            DispatchQueue.main.async {
                completion(connect)
            }
        }
    }
    
    class func removeObserver() {
        Connect.listener?.remove()
        Connect.listener = nil
    }
}
