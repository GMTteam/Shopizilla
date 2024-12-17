//
//  AddressModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 29/04/2022.
//

import Foundation
import Firebase

struct AddressModel {
    
    var uid: String = "" //Auto ID
    
    let fullName: String
    let street: String //Tên đường
    let country: String
    let state: String
    let city: String
    let ward: String
    let phoneNumber: String
    let userID: String
    let countryCode: String
    
    var defaultAddress: Bool
    var createdTime: String
}

class Address {
    
    var model: AddressModel
    
    var uid: String { return model.uid }
    var fullName: String { return model.fullName }
    var street: String { return model.street }
    var country: String { return model.country }
    var state: String { return model.state }
    var city: String { return model.city }
    var ward: String { return model.ward }
    var phoneNumber: String { return model.phoneNumber }
    var userID: String { return model.userID }
    var countryCode: String { return model.countryCode }
    var defaultAddress: Bool { return model.defaultAddress }
    var createdTime: String { return model.createdTime }
    
    static let db = Firestore.firestore().collection("Address")
    
    init(model: AddressModel) {
        self.model = model
    }
}

extension Address {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let fullName = dict["fullName"] as? String ?? ""
        let street = dict["street"] as? String ?? ""
        let country = dict["country"] as? String ?? ""
        let state = dict["state"] as? String ?? ""
        let city = dict["city"] as? String ?? ""
        let ward = dict["ward"] as? String ?? ""
        let phoneNumber = dict["phoneNumber"] as? String ?? ""
        let userID = dict["userID"] as? String ?? ""
        let countryCode = dict["countryCode"] as? String ?? ""
        let defaultAddress = dict["defaultAddress"] as? Bool ?? false
        let createdTime = dict["createdTime"] as? String ?? ""
        
        let model = AddressModel(uid: uid,
                                 fullName: fullName,
                                 street: street,
                                 country: country,
                                 state: state,
                                 city: city,
                                 ward: ward,
                                 phoneNumber: phoneNumber,
                                 userID: userID,
                                 countryCode: countryCode,
                                 defaultAddress: defaultAddress,
                                 createdTime: createdTime)
        self.init(model: model)
    }
}

//MARK: - Save

extension Address {
    
    func saveAddress(completion: @escaping () -> Void) {
        let db = Address.db.document(userID)
        
        db.setData(["update": true]) { error in
            if let error = error {
                print("setDataAddress error: \(error.localizedDescription)")
            }
        }
        
        let ref = db.collection("address")
        model.uid = ref.document().documentID
        
        let doc = ref.document(uid)
        doc.setData(toDictionary()) { error in
            if let error = error {
                print("saveAddress error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "fullName": fullName,
            "street": street,
            "country": country,
            "state": state,
            "city": city,
            "ward": ward,
            "phoneNumber": phoneNumber,
            "userID": userID,
            "countryCode": countryCode,
            "defaultAddress": defaultAddress,
            "createdTime": createdTime
        ]
    }
}

//MARK: - Update

extension Address {
    
    func updateAddress(dict: [String: Any], completion: @escaping () -> Void) {
        let db = Address.db.document(userID).collection("address").document(uid)
        db.updateData(dict) { error in
            if let error = error {
                print("updateAddress error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}

//MARK: - Delete

extension Address {
    
    func deleteAddress(completion: @escaping () -> Void) {
        let db = Address.db.document(userID).collection("address").document(uid)
        db.delete { error in
            if let error = error {
                print("deleteAddress error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}

//MARK: - Fetch

extension Address {
    
    ///Lấy tất cả địa chỉ hiện có
    static func fetchAddress(userID: String, completion: @escaping ([Address]) -> Void) {
        let db = Address.db.document(userID).collection("address")
        
        db.getDocuments { snapshot, error in
            var array: [Address] = []
            
            if let error = error {
                print("fetchAddress error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                array = snapshot.documents.map({ Address(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(array)
            }
        }
    }
}
