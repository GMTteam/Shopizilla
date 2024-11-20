//
//  ShopModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 09/06/2022.
//

import UIKit
import Firebase

struct ShopModel {
    
    let uid: String
    let name: String
    let index: Int
    let bannerURL: String
}

class Shop {
    
    private let model: ShopModel
    
    var uid: String { return model.uid }
    var name: String { return model.name }
    var index: Int { return model.index }
    var bannerURL: String { return model.bannerURL }
    
    static let db = Firestore.firestore().collection("Shops")
    
    init(model: ShopModel) {
        self.model = model
    }
}

extension Shop {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let index = dict["index"] as? Int ?? 0
        let bannerURL = dict["bannerURL"] as? String ?? ""
        
        let model = ShopModel(uid: uid, name: name, index: index, bannerURL: bannerURL)
        self.init(model: model)
    }
}

//MARK: - Fetch

extension Shop {
    
    class func fetchShops(completion: @escaping ([Shop]) -> Void) {
        let ref = Shop.db.order(by: "index", descending: false)
        
        ref.getDocuments { snapshot, error in
            var shops: [Shop] = []
            
            if let error = error {
                print("fetchShops error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                shops = snapshot.documents.map({ Shop(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(shops)
            }
        }
    }
}
