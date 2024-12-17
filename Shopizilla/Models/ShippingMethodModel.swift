//
//  ShippingMethodModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 01/05/2022.
//

import UIKit
import Firebase

struct ShippingMethodModel {
    
    var uid: String = "" //Auto ID
    let name: String //Tên phương thức vận chuyển
    let fee: Double //Chi phí vận chuyển
    let index: Int //Số thứ tự
}

class ShippingMethod {
    
    private var model: ShippingMethodModel
    
    var uid: String { return model.uid }
    var name: String { return model.name }
    var fee: Double { return model.fee }
    var index: Int { return model.index }
    
    static let db = Firestore.firestore().collection("ShippingMethods")
    
    init(model: ShippingMethodModel) {
        self.model = model
    }
}

extension ShippingMethod {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let fee = dict["fee"] as? Double ?? 0.0
        let index = dict["index"] as? Int ?? 0
        
        let model = ShippingMethodModel(uid: uid, name: name, fee: fee, index: index)
        self.init(model: model)
    }
}

//MARK: - Fetch

extension ShippingMethod {
    
    ///Lấy tất cả các phương thức vận chuyển
    static func fetchShippingMethods(completion: @escaping ([ShippingMethod]) -> Void) {
        let db = ShippingMethod.db.order(by: "index", descending: false)
        
        db.getDocuments { snapshot, error in
            var array: [ShippingMethod] = []
            
            if let error = error {
                print("fetchShippingMethods error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                array = snapshot.documents.map({ ShippingMethod(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(array)
            }
        }
    }
}
