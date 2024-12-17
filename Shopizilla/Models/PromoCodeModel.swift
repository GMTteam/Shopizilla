//
//  PromoCodeModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 30/04/2022.
//

import UIKit
import Firebase

struct PromoCodeModel {
    
    let uid: String
    let startDate: String
    let endDate: String
    let percent: Double //Phần trăm giảm
    let numberOfUses: Int //Số lượt dùng mã này
    let toUserUIDs: [String] //Mã cho các người dùng có ID bên trong
    let type: String //Đây là Discount hay Freeship
    
    var userUIDs: [String] = [] //ID người dùng nào đã sử dụng mã
}

class PromoCode {
    
    private var model: PromoCodeModel
    
    var uid: String { return model.uid }
    var startDate: String { return model.startDate }
    var endDate: String { return model.endDate }
    var percent: Double { return model.percent }
    var numberOfUses: Int { return model.numberOfUses }
    var toUserUIDs: [String] { return model.toUserUIDs }
    var type: String { return model.type }
    
    var userUIDs: [String] { return model.userUIDs }
    
    static let db = Firestore.firestore().collection("PromoCode")
    
    enum PromoType: String {
        case Discount, Freeship
    }
    
    init(model: PromoCodeModel) {
        self.model = model
    }
}

extension PromoCode {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let startDate = dict["startDate"] as? String ?? ""
        let endDate = dict["endDate"] as? String ?? ""
        let percent = dict["percent"] as? Double ?? 0.0
        let numberOfUses = dict["numberOfUses"] as? Int ?? 0
        let toUserUIDs = dict["toUserUIDs"] as? [String] ?? []
        let type = dict["type"] as? String ?? ""
        
        let model = PromoCodeModel(uid: uid,
                                   startDate: startDate,
                                   endDate: endDate,
                                   percent: percent,
                                   numberOfUses: numberOfUses,
                                   toUserUIDs: toUserUIDs,
                                   type: type)
        self.init(model: model)
    }
}

//MARK: - Update

extension PromoCode {
    
    ///Mã khuyến mãi đã sử dụng
    func updatePromoCode(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let db = PromoCode.db.document(uid)
        db.updateData(["numberOfUses": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("updatePromoCode error: \(error.localizedDescription)")
            }
            
            let doc = db.collection("userIDs").document(userID)
            doc.setData(["used": true]) { error in
                if let error = error {
                    print("updatePromoCodeUserID error: \(error.localizedDescription)")
                }
                
                completion()
            }
        }
    }
}

//MARK: - Fetch

extension PromoCode {
    
    ///Lấy 1 PromoCode
    static func fetchPromoCode(_ promoCode: String, completion: @escaping (PromoCode?) -> Void) {
        let db = PromoCode.db.document(promoCode)
        db.getDocument { snapshot, error in
            var promoCode: PromoCode?
            
            if let error = error {
                print("fetchPromoCode error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot, let dict = snapshot.data() {
                promoCode = PromoCode(dict: dict)
            }
            
            //Xem người dùng đã sử dụng mã chưa
            let ref = db.collection("userIDs")
            ref.getDocuments { snapshot, error in
                if let error = error {
                    print("fetchPromoCodeUserIDs error: \(error.localizedDescription)")
                    
                } else if let snapshot = snapshot {
                    promoCode?.model.userUIDs = snapshot.documents.map({ $0.documentID })
                }
                
                DispatchQueue.main.async {
                    completion(promoCode)
                }
            }
        }
    }
    
    ///Lấy tất cả PromoCode
    static func fetchAllPromoCode(completion: @escaping ([PromoCode]) -> Void) {
        let ref = PromoCode.db.order(by: "endDate", descending: true).limit(to: 30)
        
        ref.getDocuments { snapshot, error in
            var newArray: [PromoCode] = []
            
            if let error = error {
                print("fetchAllPromoCode error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                newArray = snapshot.documents.map({ PromoCode(dict: $0.data()) })
                
                for i in 0..<newArray.count {
                    let ref = PromoCode.db.document(newArray[i].uid).collection("userIDs")
                    
                    ref.getDocuments { snapshot, error in
                        if let error = error {
                            print("fetchPromoCodeUserIDs error: \(error.localizedDescription)")
                            
                        } else if let snapshot = snapshot {
                            newArray[i].model.userUIDs = snapshot.documents.map({ $0.documentID })
                        }
                        
                        if i == newArray.count-1 {
                            DispatchQueue.main.async {
                                completion(newArray)
                            }
                        }
                    }
                }
            }
        }
    }
}
