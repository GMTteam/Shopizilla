//
//  PaymentMethodModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 01/05/2022.
//

import UIKit
import Firebase

struct PaymentMethodModel {
    
    var uid: String = "" //Auto ID
    let name: String //Tên phương thức thanh toán
    var iconURL: String? //Icon của phương thức. Lấy từ Assets
    let index: Int //Số thứ tự
    let enabled: Bool //Phương thức nào được bật
}

class PaymentMethod {
    
    private var model: PaymentMethodModel
    
    var uid: String { return model.uid }
    var name: String { return model.name }
    var iconURL: String? { return model.iconURL }
    var index: Int { return model.index }
    var enabled: Bool { return model.enabled }
    
    static let db = Firestore.firestore().collection("PaymentMethods")
    
    init(model: PaymentMethodModel) {
        self.model = model
    }
}

extension PaymentMethod {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let iconURL = dict["iconURL"] as? String
        let index = dict["index"] as? Int ?? 0
        let enabled = dict["enabled"] as? Bool ?? false
        
        let model = PaymentMethodModel(uid: uid, name: name, iconURL: iconURL, index: index, enabled: enabled)
        self.init(model: model)
    }
}

//MARK: - Fetch

extension PaymentMethod {
    
    ///Lấy tất cả các phương thức thanh toán
    static func fetchPaymentMethods(completion: @escaping ([PaymentMethod]) -> Void) {
        let db = PaymentMethod.db.order(by: "index", descending: false)
        
        db.getDocuments { snapshot, error in
            var array: [PaymentMethod] = []
            
            if let error = error {
                print("fetchPaymentMethods error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                array = snapshot.documents
                    .map({ PaymentMethod(dict: $0.data()) })
                    .filter({ $0.enabled })
            }
            
            DispatchQueue.main.async {
                completion(array)
            }
        }
    }
}
