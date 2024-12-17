//
//  PurchaseModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/06/2022.
//

import UIKit

struct PurchaseModel {
    
    //Author Sale
    let amount: String //Author earning amount
    let soldAt: String //Purchase date
    let license: String //Regular License - Extended License
    let supportAmount: String
    let supportedUntil: String
    let buyer: String //Buyer username
    let purchaseCount: Int //Number of purchases of this item by this buyer
    
    //Item
    let id: Int //Item ID
    let name: String //Item name
    let authorUsername: String
    let updatedAt: String //Date of last item update approval on Market
    let site: String
    let priceCents: Int //Base price, in cents
    let publishedAt: String //Date of first approval on Market
    
    //Save
    var dict: NSDictionary = [:]
}

class Purchase {
    
    private let model: PurchaseModel
    
    //Author Sale
    var amount: String { return model.amount }
    var soldAt: String { return model.soldAt }
    var license: String { return model.license }
    var supportAmount: String { return model.supportAmount }
    var supportedUntil: String { return model.supportedUntil }
    var buyer: String { return model.buyer }
    var purchaseCount: Int { return model.purchaseCount }
    
    //Item
    var id: Int { return model.id }
    var name: String { return model.name }
    var authorUsername: String { return model.authorUsername }
    var updatedAt: String { return model.updatedAt }
    var site: String { return model.site }
    var priceCents: Int { return model.priceCents }
    var publishedAt: String { return model.publishedAt }
    
    //Save
    var dict: NSDictionary { return model.dict }
    
    init(model: PurchaseModel) {
        self.model = model
    }
}

extension Purchase {
    
    convenience init(dict: NSDictionary) {
        //Author Sale
        let amount = dict["amount"] as? String ?? ""
        let soldAt = dict["sold_at"] as? String ?? ""
        let license = dict["license"] as? String ?? ""
        let supportAmount = dict["support_amount"] as? String ?? ""
        let supportedUntil = dict["supported_until"] as? String ?? ""
        let buyer = dict["buyer"] as? String ?? ""
        let purchaseCount = dict["purchase_count"] as? Int ?? 0
        
        //Item
        var id = 0
        var name = ""
        var authorUsername = ""
        var updatedAt = ""
        var site = ""
        var priceCents = 0
        var publishedAt = ""
        
        if let dict = dict["item"] as? NSDictionary {
            id = dict["id"] as? Int ?? 0
            name = dict["name"] as? String ?? ""
            authorUsername = dict["author_username"] as? String ?? ""
            updatedAt = dict["updated_at"] as? String ?? ""
            site = dict["site"] as? String ?? ""
            priceCents = dict["price_cents"] as? Int ?? 0
            publishedAt = dict["published_at"] as? String ?? ""
        }
        
        var model = PurchaseModel(amount: amount,
                                  soldAt: soldAt,
                                  license: license,
                                  supportAmount: supportAmount,
                                  supportedUntil: supportedUntil,
                                  buyer: buyer,
                                  purchaseCount: purchaseCount,
                                  id: id,
                                  name: name,
                                  authorUsername: authorUsername,
                                  updatedAt: updatedAt,
                                  site: site,
                                  priceCents: priceCents,
                                  publishedAt: publishedAt)
        model.dict = dict
        self.init(model: model)
    }
}
