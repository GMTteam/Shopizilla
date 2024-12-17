//
//  ChatModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 27/05/2022.
//

import UIKit
import Firebase

enum ChatType: String {
    case text, image
}

struct ChatModel {
    
    var uid: String = "" //Auto ID
    var createdTime: String = ""
    
    var type: String //Văn bản hay hình ảnh (text || image)
    let fromUID: String
    let toUID: String
    
    //Khi gửi tin nhắn với văn bản
    var text: String = ""
    
    //Khi gửi tin nhắn với hình ảnh
    var imageLink: String = ""
    var imageWidth: Double = 0.0
    var imageHeight: Double = 0.0
    
    var prID: String = "" //ID của sản phẩm. VD: AT565
    var prCategory: String = ""
    var prSubcategory: String = ""
    var prSize: String
    var prColor: String
    
    /*
     Người nhận tin nhắn đã đọc hay chưa
     0: Đã gửi
     1: Đã đọc
     */
    var read: String = "0"
    
    var userUIDs: [String] //Người đang Chat cùng. Bao gồm user hiện tại
}

class Chat {
    
    var model: ChatModel
    
    var uid: String { return model.uid }
    var createdTime: String { return model.createdTime }
    
    var type: String { return model.type }
    var fromUID: String { return model.fromUID }
    var toUID: String { return model.toUID }
    
    var text: String { return model.text }
    
    var imageLink: String { return model.imageLink }
    var imageWidth: Double { return model.imageWidth }
    var imageHeight: Double { return model.imageHeight }
    
    var prID: String { return model.prID }
    var prCategory: String { return model.prCategory }
    var prSubcategory: String { return model.prSubcategory }
    var prSize: String { return model.prSize }
    var prColor: String { return model.prColor }
    
    var read: String { return model.read }
    
    var userUIDs: [String] { return model.userUIDs }
    
    static let db = Firestore.firestore().collection("Chats")
    static var listener: ListenerRegistration? //Cập nhật Chat
    static var conversationListener: ListenerRegistration? //Cập nhật Conversations
    static var readListener: ListenerRegistration? //Cập nhật Read
    
    init(model: ChatModel) {
        self.model = model
    }
}

extension Chat {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let createdTime = dict["createdTime"] as? String ?? ""
        
        let type = dict["type"] as? String ?? ""
        let fromUID = dict["fromUID"] as? String ?? ""
        let toUID = dict["toUID"] as? String ?? ""
        
        let text = dict["text"] as? String ?? ""
        
        let imageLink = dict["imageLink"] as? String ?? ""
        let imageWidth = dict["imageWidth"] as? Double ?? 0.0
        let imageHeight = dict["imageHeight"] as? Double ?? 0.0
        
        let prID = dict["prID"] as? String ?? ""
        let prCategory = dict["prCategory"] as? String ?? ""
        let prSubcategory = dict["prSubcategory"] as? String ?? ""
        let prSize = dict["prSize"] as? String ?? ""
        let prColor = dict["prColor"] as? String ?? ""
        
        let read = dict["read"] as? String ?? ""
        
        let userUIDs = dict["userUIDs"] as? [String] ?? []
        
        let model = ChatModel(uid: uid,
                              createdTime: createdTime,
                              type: type,
                              fromUID: fromUID,
                              toUID: toUID,
                              text: text,
                              imageLink: imageLink,
                              imageWidth: imageWidth,
                              imageHeight: imageHeight,
                              prID: prID,
                              prCategory: prCategory,
                              prSubcategory: prSubcategory,
                              prSize: prSize,
                              prColor: prColor,
                              read: read,
                              userUIDs: userUIDs)
        self.init(model: model)
    }
}

//MARK: - Save

extension Chat {
    
    func saveChat(completion: @escaping () -> Void) {
        model.uid = Chat.db.document().documentID
        
        let doc = Chat.db.document(uid)
        doc.setData(toDictionary()) { error in
            if let error = error {
                print("saveChat error: \(error.localizedDescription)")   
            }
            
            completion()
        }
    }
    
    func updateImageLink(imageLink: String, completion: @escaping () -> Void) {
        let doc = Chat.db.document(uid)
        
        doc.updateData(["imageLink": imageLink]) { error in
            if let error = error {
                print("updateChat error: \(error.localizedDescription)")
            }
        }
    }
    
    private func toDictionary() -> [String: Any] {
        model.createdTime = longFormatter().string(from: Date())
        
        return [
            "uid": uid,
            "createdTime": createdTime,
            "type": type,
            "fromUID": fromUID,
            "toUID": toUID,
            "text": text,
            "imageLink": imageLink,
            "imageWidth": imageWidth,
            "imageHeight": imageHeight,
            "prID": prID,
            "prCategory": prCategory,
            "prSubcategory": prSubcategory,
            "prSize": prSize,
            "prColor": prColor,
            "read": read,
            "userUIDs": userUIDs
        ]
    }
    
    class func removeObserver() {
        Chat.listener?.remove()
        Chat.listener = nil
    }
    
    class func removeConversationObserver() {
        Chat.conversationListener?.remove()
        Chat.conversationListener = nil
    }
    
    class func removeReadObserver() {
        Chat.readListener?.remove()
        Chat.readListener = nil
    }
}

//MARK: - Fetch

extension Chat {
    
    ///Truy cập vào RoomChat
    class func fetchChats(toUID: String, completion: @escaping ([Chat]) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let ref = Chat.db.whereField("userUIDs", arrayContains: userUID)
        removeObserver()
        
        listener = ref.addSnapshotListener({ snapshot, error in
            let messages = self.getChats(snapshot: snapshot, error: error)
                .filter({ return $0.fromUID == toUID || $0.toUID == toUID })
            
            //Cập nhật đã đọc cho người nhận tin nhắn
            let mess = messages.filter({ $0.toUID == userUID }).filter({ $0.read == "0" })
            if mess.count != 0 {
                mess.forEach({
                    let doc = Chat.db.document($0.uid)
                    doc.updateData(["read": "1"]) { error in
                        if let error = error {
                            print("updateRead error: \(error.localizedDescription)")
                        }
                    }
                })
            }
            
            DispatchQueue.main.async {
                completion(messages)
            }
        })
    }
    
    ///Lấy cuộc trò chuyện cho Admin
    class func fetchConversations(completion: @escaping ([Chat]) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let ref = Chat.db.whereField("userUIDs", arrayContains: userUID)
        removeConversationObserver()
        
        conversationListener = ref.addSnapshotListener({ snapshot, error in
            let messages = self.getChats(snapshot: snapshot, error: error)
            
            DispatchQueue.main.async {
                completion(messages)
            }
        })
    }
    
    ///Lấy tin nhắn chưa đọc
    class func fetchUnread(completion: @escaping ([Chat]) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let ref = Chat.db
            .whereField("toUID", isEqualTo: userUID)
            .whereField("read", isEqualTo: "0")
        
        removeReadObserver()
        
        readListener = ref.addSnapshotListener({ snapshot, error in
            let messages = self.getChats(snapshot: snapshot, error: error)
            
            DispatchQueue.main.async {
                completion(messages)
            }
        })
    }
    
    private class func getChats(snapshot: QuerySnapshot?, error: Error?) -> [Chat] {
        var messages: [Chat] = []
        
        if let error = error {
            print("fetchChats error: \(error.localizedDescription)")
            
        } else if let snapshot = snapshot {
            messages = snapshot.documents
                .map({ Chat(dict: $0.data()) })
                .sorted(by: { $0.createdTime < $1.createdTime })
        }
        
        return messages
    }
}

//MARK: - Remove userUIDs

extension Chat {
    
    ///Xóa 1 phần tử trong mảng userUIDs. Xóa 1 nội dung tin nhắn
    func removeUserUIDs(completion: @escaping () -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let ref = Chat.db.document(uid)
        ref.updateData(["userUIDs": FieldValue.arrayRemove([userUID])]) { error in
            if let error = error {
                print("removeUserUIDs error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    ///Xóa 1 tin nhắn
    class func deleteChat(chatUID: String) {
        let ref = Chat.db.document(chatUID)
        
        ref.delete { error in
            if let error = error {
                print("deleteChat error: \(error.localizedDescription)")
            }
        }
    }
}
