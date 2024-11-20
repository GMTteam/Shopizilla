//
//  ShoppingStatusModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 03/05/2022.
//

import UIKit

struct ShoppingStatusModel {
    
    let status: String //Tên 'Str'. Ko phải 'Num'
    var shoppings: [ShoppingCart] = [] //Số lượng sản phẩm trong 1 đơn hàng
    let orderID: String //ID của đơn hàng
    let orderDate: String //Ngày đặt hàng
    let onGoingDate: String //Ngày đi
    let deliveredDate: String //Ngày hoàn thành
    let cancelledDate: String //Ngày hủy
    let percentPromotion: Double? //Có áp dụng % của mã khuyễn mãi không
    let shippingFee: Double //Phí vận chuyển
    let userID: String //Dùng để xác nhận khi là Admin. Hoặc hủy khi là currenrUser
    let addressID: String? //ID địa chỉ hiện tại
    let saleOff: Double //Giảm giá
    let isPaid: Bool //Đã thanh toán chưa
    let paymentID: String //ID cho thanh toán (nếu đã thanh toán)
    let paymentMethod: String //Hình thức thanh toán
    let coin: Double //
}

class ShoppingStatus {
    
    private let model: ShoppingStatusModel
    
    var status: String { return model.status }
    var shoppings: [ShoppingCart] { return model.shoppings }
    var orderID: String { return model.orderID }
    var orderDate: String { return model.orderDate }
    var onGoingDate: String { return model.onGoingDate }
    var deliveredDate: String { return model.deliveredDate }
    var cancelledDate: String { return model.cancelledDate }
    var percentPromotion: Double? { return model.percentPromotion }
    var shippingFee: Double { return model.shippingFee }
    var userID: String { return model.userID }
    var addressID: String? { return model.addressID }
    var saleOff: Double { return model.saleOff }
    var isPaid: Bool { return model.isPaid }
    var paymentID: String { return model.paymentID }
    var paymentMethod: String { return model.paymentMethod }
    var coin: Double { return model.coin }
    
    init(model: ShoppingStatusModel) {
        self.model = model
    }
}

extension ShoppingStatus {
    
    //Lấy mảng từ ShoppingCart
    class func getNewShoppingStatus(shoppings: [ShoppingCart]) -> [ShoppingStatus] {
        let newArray: [ShoppingStatus] = shoppings.map({ shopping in
            let model = ShoppingStatusModel(status: shopping.status,
                                            shoppings: [shopping],
                                            orderID: shopping.orderID,
                                            orderDate: shopping.orderDate,
                                            onGoingDate: shopping.onGoingDate,
                                            deliveredDate: shopping.deliveredDate,
                                            cancelledDate: shopping.cancelledDate,
                                            percentPromotion: shopping.percentPromotion,
                                            shippingFee: shopping.shippingFee,
                                            userID: shopping.userID,
                                            addressID: shopping.addressID,
                                            saleOff: shopping.saleOff,
                                            isPaid: shopping.isPaid,
                                            paymentID: shopping.paymentID,
                                            paymentMethod: shopping.paymentMethod,
                                            coin: shopping.coin)
            return ShoppingStatus(model: model)
        })
        
        return newArray
    }
    
    //Nhóm các đơn hàng giống nhau
    class func getNewShoppingStatus(dict: [String: [ShoppingStatus]]) -> [ShoppingStatus] {
        var newShoppingStatus: [ShoppingStatus] = []
        
        for (key, value) in dict {
            var arr: [ShoppingCart] = []
            
            for v in value {
                arr += v.shoppings
            }
            
            let shop = value.first(where: { $0.orderID == key })
            let model = ShoppingStatusModel(status: shop?.status ?? "",
                                            shoppings: arr,
                                            orderID: shop?.orderID ?? "",
                                            orderDate: shop?.orderDate ?? "",
                                            onGoingDate: shop?.onGoingDate ?? "",
                                            deliveredDate: shop?.deliveredDate ?? "",
                                            cancelledDate: shop?.cancelledDate ?? "",
                                            percentPromotion: shop?.percentPromotion,
                                            shippingFee: shop?.shippingFee ?? 0.0,
                                            userID: shop?.userID ?? "",
                                            addressID: shop?.addressID,
                                            saleOff: shop?.saleOff ?? 0.0,
                                            isPaid: shop?.isPaid ?? false,
                                            paymentID: shop?.paymentID ?? "",
                                            paymentMethod: shop?.paymentMethod ?? "",
                                            coin: shop?.coin ?? 0.0)
            let shoppingS = ShoppingStatus(model: model)
            newShoppingStatus.append(shoppingS)
        }
        
        return newShoppingStatus
    }
}
