//
//  ReviewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit
import Firebase

struct ReviewModel {
    
    var uid: String = "" //AutoID tự đặt cho Review
    let productUID: String //UID của sản phẩm. VD: MEN-NA035
    let productID: String //ID của sản phẩm. VD: NA035
    let category: String
    let subcategory: String
    var createdTime: String = "" //Thời gian tạo. Tự động
    var userID: String = "" //User đã đánh giá
    let rating: Int //Đánh giá bao nhiêu sao
    let description: String
    var imageURLs: [String]
    let orderID: String //ID đơn đặt hàng
}

class Review {
    
    private var model: ReviewModel
    
    var uid: String { return model.uid }
    var productUID: String { return model.productUID }
    var productID: String { return model.productID }
    var category: String { return model.category }
    var subcategory: String { return model.subcategory }
    var createdTime: String { return model.createdTime }
    var userID: String { return model.userID }
    var rating: Int { return model.rating }
    var description: String { return model.description }
    var imageURLs: [String] { return model.imageURLs }
    var orderID: String { return model.orderID }
    
    static let db = Firestore.firestore().collection("Reviews")
    
    init(model: ReviewModel) {
        self.model = model
    }
}

extension Review {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let productUID = dict["productUID"] as? String ?? ""
        let productID = dict["productID"] as? String ?? ""
        let category = dict["category"] as? String ?? ""
        let subcategory = dict["subcategory"] as? String ?? ""
        let createdTime = dict["createdTime"] as? String ?? ""
        let userID = dict["userID"] as? String ?? ""
        let rating = dict["rating"] as? Int ?? 0
        let description = dict["description"] as? String ?? ""
        let imageURLs = dict["imageURLs"] as? [String] ?? []
        let orderID = dict["orderID"] as? String ?? ""
        
        let model = ReviewModel(uid: uid,
                                productUID: productUID,
                                productID: productID,
                                category: category,
                                subcategory: subcategory,
                                createdTime: createdTime,
                                userID: userID,
                                rating: rating,
                                description: description,
                                imageURLs: imageURLs,
                                orderID: orderID)
        self.init(model: model)
    }
}

//MARK: - Save

extension Review {
    
    func saveReview(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let db = Review.db
        model.uid = db.document().documentID
        model.createdTime = longFormatter().string(from: Date())
        model.userID = userID
        
        let doc = db.document(uid)
        doc.setData(toDictionary()) { error in
            if let error = error {
                print("saveReview error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "productUID": productUID,
            "productID": productID,
            "category": category,
            "subcategory": subcategory,
            "createdTime": createdTime,
            "userID": userID,
            "rating": rating,
            "description": description,
            "imageURLs": imageURLs,
            "orderID": orderID
        ]
    }
}

//MARK: - Fetch

extension Review {
    
    ///Lấy Reviews của riêng 1 sản phẩm
    static func fetchReviews(product: Product, completion: @escaping ([Review]) -> Void) {
        let db = Review.db.whereField("productUID", isEqualTo: product.uid)
        
        db.getDocuments { snapshot, error in
            var reviews: [Review] = []
            
            if let error = error {
                print("fetchReviews error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                reviews = snapshot.documents.map({ Review(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(reviews)
            }
        }
    }
    
    ///Lấy Review của đơn hàng, bên trong Delivered (My Order).
    static func fetchReviews(orderID: String, completion: @escaping ([Review]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let db = Review.db
            .whereField("orderID", isEqualTo: orderID)
            .whereField("userID", isEqualTo: userID)
        
        db.getDocuments { snapshot, error in
            var reviews: [Review] = []
            
            if let error = error {
                print("fetchReviews error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                reviews = snapshot.documents.map({ Review(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(reviews)
            }
        }
    }
}
