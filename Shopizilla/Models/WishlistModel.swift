//
//  WishlistModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/04/2022.
//

import UIKit
import Firebase

struct WishlistModel {
    
    let category: String
    let subcategory: String
    let prID: String //ID của sản phẩm
    let color: String
    let size: String
    
    var createdTime: String = ""
    var uid: String = "" //Auto ID
    var userID: String = "" //ID người dùng
    
    var product: Product? = nil
}

class Wishlist {
    
    private var model: WishlistModel
    
    var category: String { return model.category }
    var subcategory: String { return model.subcategory }
    var prID: String { return model.prID }
    var color: String { return model.color }
    var size: String { return model.size }
    
    var createdTime: String { return model.createdTime }
    var uid: String { return model.uid }
    var userID: String { return model.userID }
    
    var product: Product? { return model.product }
    
    static let db = Firestore.firestore().collection("Wishlists")
    static var listener: ListenerRegistration? //All Wishlists by currentUser
    
    init(model: WishlistModel) {
        self.model = model
    }
}

extension Wishlist {
    
    convenience init(dict: [String: Any]) {
        let category = dict["category"] as? String ?? ""
        let subcategory = dict["subcategory"] as? String ?? ""
        let prID = dict["prID"] as? String ?? ""
        let color = dict["color"] as? String ?? ""
        let size = dict["size"] as? String ?? ""
        let createdTime = dict["createdTime"] as? String ?? ""
        let uid = dict["uid"] as? String ?? ""
        let userID = dict["userID"] as? String ?? ""
        
        let model = WishlistModel(category: category,
                                  subcategory: subcategory,
                                  prID: prID,
                                  color: color,
                                  size: size,
                                  createdTime: createdTime,
                                  uid: uid,
                                  userID: userID)
        self.init(model: model)
    }
}

//MARK: - Save

extension Wishlist {
    
    ///Lưu thông tin Product đến Wishlist
    func saveWishlist(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let db = Wishlist.db.document(userID)
            
        db.setData(["update": true]) { error in
            if let error = error {
                print("setDataWishlist error: \(error.localizedDescription)")
            }
        }
        
        let ref = db.collection("wishlists")
        
        model.uid = ref.document().documentID
        model.createdTime = longFormatter().string(from: Date())
        model.userID = userID
        
        let doc = ref.document(uid)
        doc.setData(toDictionary()) { error in
            if let error = error {
                print("saveWishlist error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "category": category,
            "subcategory": subcategory,
            "prID": prID,
            "color": color,
            "size": size,
            "createdTime": createdTime,
            "uid": uid,
            "userID": userID
        ]
    }
    
    class func removeObserver() {
        Wishlist.listener?.remove()
        Wishlist.listener = nil
    }
}

//MARK: - Delete

extension Wishlist {
    
    ///Xóa 1 Wishlist cụ thể
    func deleteWishlist(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let db = Wishlist.db.document(userID).collection("wishlists").document(uid)
        db.delete { error in
            if let error = error {
                print("deleteWishlist error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}

//MARK: - Fetch

extension Wishlist {
    
    ///Lấy 1 Wishlist cụ thể cho currentUser
    static func fetchWishlistBy(product: Product, color: String, size: String, completion: @escaping (Wishlist?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let db = Wishlist.db.document(userID).collection("wishlists")
            .whereField("category", isEqualTo: product.category)
            .whereField("subcategory", isEqualTo: product.subcategory)
            .whereField("prID", isEqualTo: product.productID)
            .whereField("color", isEqualTo: color)
            .whereField("size", isEqualTo: size)
        
        db.getDocuments { snapshot, error in
            var wishlist: Wishlist?
            
            if let error = error {
                print("fetchWishlistBy error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                let array = snapshot.documents.map({ Wishlist(dict: $0.data()) })
                wishlist = array.first
            }
            
            DispatchQueue.main.async {
                completion(wishlist)
            }
        }
    }
    
    ///Lấy toàn bộ Wishlists cho currentUser
    static func fetchWishlists(completion: @escaping ([Wishlist]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let db = Wishlist.db.document(userID).collection("wishlists")
        
        removeObserver()
        
        listener = db.addSnapshotListener({ snapshot, error in
            var wishlists: [Wishlist] = []
            
            if let error = error {
                print("fetchWishlistBy error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                wishlists = snapshot.documents
                    .map({ Wishlist(dict: $0.data()) })
                    .sorted(by: { $0.createdTime > $1.createdTime })
            }
            
            DispatchQueue.main.async {
                completion(wishlists)
            }
        })
    }
}
