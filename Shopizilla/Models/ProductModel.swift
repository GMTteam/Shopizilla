//
//  ProductModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/04/2022.
//

import UIKit
import Firebase

struct ProductModel {
    
    var uid: String = "" //ID tự đặt
    
    let productID: String //Mã sản phẩm
    let name: String
    let price: Double
    
    let saleOff: Double //Giảm giá
    let saleOffFromDate: String //Từ ngày
    let saleOffToDate: String //Đến ngày
    
    let featured: Bool
    let bestSeller: Bool
    let newArrival: Bool
    
    let descriptionShort: String
    let descriptionFull: String
    
    let imageURL: String
    let imageURLs: [String]
    
    let color: String
    let sizes: [String]
    
    var createdDate: String = ""
    let updatedDate: String
    
    let permalink: String //Liên kết đi đến Website
    
    let category: String //Danh mục chính
    let subcategory: String //Danh mục phụ
    
    let isShow: Bool //Sản phẩm ẩn hay hiện
    var stockQuantity: Int = 0
    
    var tags: [String]
    var relatedIDs: [String] //Sản phẩm liên quan. Lấy productID của sản phẩm
    var moreColors: [String] //Sản phẩm có nhiều màu. Lấy UID của sản phẩm
}

class Product {
    
    var model: ProductModel
    
    var uid: String { return model.uid }
    
    var productID: String { return model.productID }
    var name: String { return model.name }
    var price: Double { return model.price }
    
    var saleOff: Double { return model.saleOff }
    var saleOffFromDate: String { return model.saleOffFromDate }
    var saleOffToDate: String { return model.saleOffToDate }
    
    var featured: Bool { return model.featured }
    var bestSeller: Bool { return model.bestSeller }
    var newArrival: Bool { return model.newArrival }
    
    var descriptionShort: String { return model.descriptionShort }
    var descriptionFull: String { return model.descriptionFull }
    
    var imageURL: String { return model.imageURL }
    var imageURLs: [String] { return model.imageURLs }
    
    var color: String { return model.color }
    var sizes: [String] { return model.sizes }
    
    var createdDate: String { return model.createdDate }
    var updatedDate: String { return model.updatedDate }
    
    var permalink: String { return model.permalink }
    
    var category: String { return model.category }
    var subcategory: String { return model.subcategory }
    
    var isShow: Bool { return model.isShow }
    var stockQuantity: Int { return model.stockQuantity }
    
    var tags: [String] { return model.tags }
    var relatedIDs: [String] { return model.relatedIDs }
    var moreColors: [String] { return model.moreColors }
    
    static let db = Firestore.firestore().collection("Products")
    
    init(model: ProductModel) {
        self.model = model
    }
}

extension Product {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        
        let productID = dict["productID"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let price = dict["price"] as? Double ?? 0.0
        
        let saleOff = dict["saleOff"] as? Double ?? 0.0
        let saleOffFromDate = dict["saleOffFromDate"] as? String ?? ""
        let saleOffToDate = dict["saleOffToDate"] as? String ?? ""
        
        let featured = dict["featured"] as? Bool ?? false
        let bestSeller = dict["bestSeller"] as? Bool ?? false
        let newArrival = dict["newArrival"] as? Bool ?? false
        
        let descriptionShort = dict["descriptionShort"] as? String ?? ""
        let descriptionFull = dict["descriptionFull"] as? String ?? ""
        
        let imageURL = dict["imageURL"] as? String ?? ""
        let imageURLs = dict["imageURLs"] as? [String] ?? []
        
        let color = dict["color"] as? String ?? ""
        let sizes = dict["sizes"] as? [String] ?? []
        
        let createdDate = dict["createdDate"] as? String ?? ""
        let updatedDate = dict["updatedDate"] as? String ?? ""
        
        let permalink = dict["permalink"] as? String ?? ""
        
        let category = dict["category"] as? String ?? ""
        let subcategory = dict["subcategory"] as? String ?? ""
        
        let isShow = dict["isShow"] as? Bool ?? false
        let stockQuantity = dict["stockQuantity"] as? Int ?? 0
        
        let tags = dict["tags"] as? [String] ?? []
        let relatedIDs = dict["relatedIDs"] as? [String] ?? []
        let moreColors = dict["moreColors"] as? [String] ?? []
        
        let model = ProductModel(uid: uid,
                                 productID: productID,
                                 name: name,
                                 price: price,
                                 saleOff: saleOff,
                                 saleOffFromDate: saleOffFromDate,
                                 saleOffToDate: saleOffToDate,
                                 featured: featured,
                                 bestSeller: bestSeller,
                                 newArrival: newArrival,
                                 descriptionShort: descriptionShort,
                                 descriptionFull: descriptionFull,
                                 imageURL: imageURL,
                                 imageURLs: imageURLs,
                                 color: color,
                                 sizes: sizes,
                                 createdDate: createdDate,
                                 updatedDate: updatedDate,
                                 permalink: permalink,
                                 category: category,
                                 subcategory: subcategory,
                                 isShow: isShow,
                                 stockQuantity: stockQuantity,
                                 tags: tags,
                                 relatedIDs: relatedIDs,
                                 moreColors: moreColors)
        self.init(model: model)
    }
}

//MARK: - Fetch All Products

extension Product {
    
    ///Lấy tất cả Products với 'isShow' bằng 'true'
    static func fetchAllProduct(completion: @escaping ([Product]) -> Void) {
        let ref = Product.db.whereField("isShow", isEqualTo: true)
        
        ref.getDocuments { snapshot, error in
            var products: [Product] = []
            
            if let error = error {
                print("fetchAllProduct error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                products = snapshot.documents.map({ Product(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(products)
            }
        }
    }
    
    ///Lấy Product theo uid đã chỉ định
    static func fetchProduct(uid: String, completion: @escaping (Product?) -> Void) {
        let ref = Product.db.document(uid)
        
        ref.getDocument { snapshot, error in
            var product: Product?
            
            if let error = error {
                print("fetchProduct error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot, let dict = snapshot.data() {
                product = Product(dict: dict)
            }
            
            DispatchQueue.main.async {
                completion(product)
            }
        }
    }
}
