//
//  ReviewStarModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

struct ReviewStarModel {
    
    var userID: String = "" //User đã đánh giá
    let rating: Int //Đánh giá bao nhiêu sao
    let description: String
    var imageURLs: [String]
    let orderID: String //ID đơn đặt hàng
}

class ReviewStar {
    
    private let model: ReviewStarModel
    
    var userID: String { return model.userID }
    var rating: Int { return model.rating }
    var description: String { return model.description }
    var imageURLs: [String] { return model.imageURLs }
    var orderID: String { return model.orderID }
    
    init(model: ReviewStarModel) {
        self.model = model
    }
}

extension ReviewStar {
    
    convenience init(dict: [String: Any]) {
        let userID = dict["userID"] as? String ?? ""
        let rating = dict["rating"] as? Int ?? 0
        let description = dict["description"] as? String ?? ""
        let imageURLs = dict["imageURLs"] as? [String] ?? []
        let orderID = dict["orderID"] as? String ?? ""
        
        let model = ReviewStarModel(userID: userID,
                                    rating: rating,
                                    description: description,
                                    imageURLs: imageURLs,
                                    orderID: orderID)
        self.init(model: model)
    }
}
