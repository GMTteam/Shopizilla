//
//  APIKeyModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/04/2022.
//

import UIKit

struct APIKeyModel {
    
    let serverKey: String
    let senderID: String
    let appID: String
    let instagram: String
    let phoneNumber: String
    let email: String
    let adminID: String
    let stripePublicKey: String
    let stripeSecretKey: String
    let applePayID: String
    let payPalClientID: String
    let payPalSecretKey: String
    let address: String
}

class APIKey {
    
    private let model: APIKeyModel
    
    var serverKey: String { return model.serverKey }
    var senderID: String { return model.senderID }
    var appID: String { return model.appID }
    var instagram: String { return model.instagram }
    var phoneNumber: String { return model.phoneNumber }
    var email: String { return model.email }
    var adminID: String { return model.adminID }
    var stripePublicKey: String { return model.stripePublicKey }
    var stripeSecretKey: String { return model.stripeSecretKey }
    var applePayID: String { return model.applePayID }
    var payPalClientID: String { return model.payPalClientID }
    var payPalSecretKey: String { return model.payPalSecretKey }
    var address: String { return model.address }
    
    init(model: APIKeyModel) {
        self.model = model
    }
}

extension APIKey {
    
    convenience init(dict: NSDictionary) {
        let serverKey = dict["ServerKey"] as? String ?? ""
        let senderID = dict["GCM_SENDER_ID"] as? String ?? ""
        let appID = dict["AppID"] as? String ?? ""
        let instagram = dict["Instagram"] as? String ?? ""
        let phoneNumber = dict["PhoneNumber"] as? String ?? ""
        let email = dict["Email"] as? String ?? ""
        let adminID = dict["AdminID"] as? String ?? ""
        let stripePublicKey = dict["Stripe-PublicKey"] as? String ?? ""
        let stripeSecretKey = dict["Stripe-SecretKey"] as? String ?? ""
        let applePayID = dict["ApplePayID"] as? String ?? ""
        let payPalClientID = dict["PayPal-ClientID"] as? String ?? ""
        let payPalSecretKey = dict["PayPal-SecretKey"] as? String ?? ""
        let address = dict["Address"] as? String ?? ""
        
        let model = APIKeyModel(serverKey: serverKey,
                                senderID: senderID,
                                appID: appID,
                                instagram: instagram,
                                phoneNumber: phoneNumber,
                                email: email,
                                adminID: adminID,
                                stripePublicKey: stripePublicKey,
                                stripeSecretKey: stripeSecretKey,
                                applePayID: applePayID,
                                payPalClientID: payPalClientID,
                                payPalSecretKey: payPalSecretKey,
                                address: address)
        self.init(model: model)
    }
}
