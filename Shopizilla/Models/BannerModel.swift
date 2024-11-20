//
//  BannerModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/04/2022.
//

import UIKit
import Firebase

struct BannerModel {
    
    let uid: String
    let imageURL: String
    let name: String
    let description: String
    let category: String
    let subcategory: String
}

class Banner {
    
    private let model: BannerModel
    
    var uid: String { return model.uid }
    var imageURL: String { return model.imageURL }
    var name: String { return model.name }
    var description: String { return model.description }
    var category: String { return model.category }
    var subcategory: String { return model.subcategory }
    
    init(model: BannerModel) {
        self.model = model
    }
}

extension Banner {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let imageURL = dict["imageURL"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let description = dict["description"] as? String ?? ""
        let category = dict["category"] as? String ?? ""
        let subcategory = dict["subcategory"] as? String ?? ""
        
        let model = BannerModel(uid: uid, imageURL: imageURL, name: name, description: description, category: category, subcategory: subcategory)
        self.init(model: model)
    }
}

//MARK: - Fetch

extension Banner {
    
    ///Tìm nạp Banners từ Firestore
    class func fetchBanners(completion: @escaping ([Banner]) -> Void) {
        let db = Firestore.firestore().collection("Banners")
        db.getDocuments { snapshot, error in
            var array: [Banner] = []
            
            if let error = error {
                print("*** fetchBanners error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                array = snapshot.documents.map({ Banner(dict: $0.data()) }).shuffled()
            }
            
            DispatchQueue.main.async {
                completion(array)
            }
        }
    }
}
