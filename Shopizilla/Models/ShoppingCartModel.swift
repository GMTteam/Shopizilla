//
//  ShoppingCartModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 27/04/2022.
//

import UIKit
import Firebase

struct ShoppingCartModel {
    
    var uid: String = "" //Auto ID
    
    var name: String = ""
    var quantity: Int = 1
    var price: Double = 0.0
    var total: Double = 0.0
    var imageURL: String = ""
    
    let color: String
    let size: String
    
    var category: String = ""
    var subcategory: String = ""
    var prID: String = "" //ID của Product
    
    var saleOff: Double = 0.0 //Giảm giá
    var saleOffFromDate: String = "" //Từ ngày
    var saleOffToDate: String = "" //Đến ngày
    
    var createdTime: String = "" //Ngày thêm
    var userID: String = "" //ID người dùng
    var prUID: String = "" //MEN-AT565-L
    
    var orderID: String = "" //ID đơn hàng
    var shippingFee: Double = 0.0 //Phí vận chuyển
    var paymentMethod: String = "" //Phương thức thanh toán
    var orderDate: String = "" //Ngày đặt hàng
    var onGoingDate: String = "" //Ngày đi
    var deliveredDate: String = "" //Ngày hoàn thành
    var cancelledDate: String = "" //Ngày hủy
    var promoCode: String? = nil //Áp dụng mã khuyến mãi
    var percentPromotion: Double? = nil //Phần trăm giảm của mã khuyến mãi
    var addressID: String? //ID địa chỉ
    var address: Address? //Địa chỉ giao hàng
    
    var coin: Double = 0.0 //Số Coin đã sử dụng từ ví
    var isPaid: Bool = false //Đã thanh toán chưa
    var isReview: Bool = false //Đã Review chưa
    var paymentID: String = "" //ID khi đã thanh toán bằng Visa || PayPal || ApplePay
    
    //status:
    //0: Còn trong giỏ. Lọc các sản phẩm có giá trị này cho giỏ hàng.
    //1: Đã đặt hàng. 'Order Placed'.
    //2: Đang Giao hàng. Lịch sử mua hàng. 'On Going'.
    //3: Đã giao hàng. Lịch sử mua hàng. 'Delivered'.
    //4: Đã hủy. 'Cancelled'.
    let status: String
    
    enum StatusKey: String {
        case bag = "0"
        case orderPlaced = "1"
        case onGoing = "2"
        case delivered = "3"
        case cancelled = "4"
    }
    
    ///Chuyển đổi Status từ Number thành String
    static func fromNumberToString(num: String) -> String {
        switch num {
        case "0": return "Bag"
        case "1": return "Order Placed"
        case "2": return "On Going"
        case "3": return "Delivered"
        default: return "Cancelled"
        }
    }
    
    ///Chuyển đổi Status từ String gọi thành Number
    static func fromStringToNumber(str: String) -> String {
        switch str {
        case "Bag": return "0"
        case "Order Placed": return "1"
        case "On Going": return "2"
        case "Delivered": return "3"
        default: return "4"
        }
    }
}

class ShoppingCart {
    
    var model: ShoppingCartModel
    
    var uid: String { return model.uid }
    
    var name: String { return model.name }
    var quantity: Int { return model.quantity }
    var price: Double { return model.price }
    var total: Double { return model.total }
    var imageURL: String { return model.imageURL }
    
    var color: String { return model.color }
    var size: String { return model.size }
    
    var category: String { return model.category }
    var subcategory: String { return model.subcategory }
    var prID: String { return model.prID }
    
    var saleOff: Double { return model.saleOff }
    var saleOffFromDate: String { return model.saleOffFromDate }
    var saleOffToDate: String { return model.saleOffToDate }
    
    var createdTime: String { return model.createdTime }
    var userID: String { return model.userID }
    var prUID: String { return model.prUID }
    
    var orderID: String { return model.orderID }
    var shippingFee: Double { return model.shippingFee }
    var paymentMethod: String { return model.paymentMethod }
    var orderDate: String { return model.orderDate }
    var onGoingDate: String { return model.onGoingDate }
    var deliveredDate: String { return model.deliveredDate }
    var cancelledDate: String { return model.cancelledDate }
    var promoCode: String? { return model.promoCode }
    var percentPromotion: Double? { return model.percentPromotion }
    var addressID: String? { return model.addressID }
    var address: Address? { return model.address }
    
    var coin: Double { return model.coin }
    var isPaid: Bool { return model.isPaid }
    var isReview: Bool { return model.isReview }
    var paymentID: String { return model.paymentID }
    
    var status: String { return model.status }
    
    static let db = Firestore.firestore().collection("ShoppingCarts")
    static var listener: ListenerRegistration? //ShoppingCart by currentUser
    static var adminListener: ListenerRegistration? //ShoppingCart by Admin
    
    init(model: ShoppingCartModel) {
        self.model = model
    }
}

extension ShoppingCart {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        
        let name = dict["name"] as? String ?? ""
        let quantity = dict["quantity"] as? Int ?? 0
        let price = dict["price"] as? Double ?? 0.0
        let total = dict["total"] as? Double ?? 0.0
        let imageURL = dict["imageURL"] as? String ?? ""
        
        let color = dict["color"] as? String ?? ""
        let size = dict["size"] as? String ?? ""
        
        let category = dict["category"] as? String ?? ""
        let subcategory = dict["subcategory"] as? String ?? ""
        let prID = dict["prID"] as? String ?? ""
        
        let saleOff = dict["saleOff"] as? Double ?? 0.0
        let saleOffFromDate = dict["saleOffFromDate"] as? String ?? ""
        let saleOffToDate = dict["saleOffToDate"] as? String ?? ""
        
        let createdTime = dict["createdTime"] as? String ?? ""
        let userID = dict["userID"] as? String ?? ""
        let prUID = dict["prUID"] as? String ?? ""
        
        let orderID = dict["orderID"] as? String ?? ""
        let shippingFee = dict["shippingFee"] as? Double ?? 0.0
        let paymentMethod = dict["paymentMethod"] as? String ?? ""
        let orderDate = dict["orderDate"] as? String ?? ""
        let onGoingDate = dict["onGoingDate"] as? String ?? ""
        let deliveredDate = dict["deliveredDate"] as? String ?? ""
        let cancelledDate = dict["cancelledDate"] as? String ?? ""
        let promoCode = dict["promoCode"] as? String
        let percentPromotion = dict["percentPromotion"] as? Double
        let addressID = dict["addressID"] as? String
        
        let coin = dict["coin"] as? Double ?? 0.0
        let isPaid = dict["isPaid"] as? Bool ?? false
        let isReview = dict["isReview"] as? Bool ?? false
        let paymentID = dict["paymentID"] as? String ?? ""
        
        let status = dict["status"] as? String ?? ""
        
        let model = ShoppingCartModel(uid: uid,
                                      name: name,
                                      quantity: quantity,
                                      price: price,
                                      total: total,
                                      imageURL: imageURL,
                                      color: color,
                                      size: size,
                                      category: category,
                                      subcategory: subcategory,
                                      prID: prID,
                                      saleOff: saleOff,
                                      saleOffFromDate: saleOffFromDate,
                                      saleOffToDate: saleOffToDate,
                                      createdTime: createdTime,
                                      userID: userID,
                                      prUID: prUID,
                                      orderID: orderID,
                                      shippingFee: shippingFee,
                                      paymentMethod: paymentMethod,
                                      orderDate: orderDate,
                                      onGoingDate: onGoingDate,
                                      deliveredDate: deliveredDate,
                                      cancelledDate: cancelledDate,
                                      promoCode: promoCode,
                                      percentPromotion: percentPromotion,
                                      addressID: addressID,
                                      coin: coin,
                                      isPaid: isPaid,
                                      isReview: isReview,
                                      paymentID: paymentID,
                                      status: status)
        self.init(model: model)
    }
}

//MARK: - Save

extension ShoppingCart {
    
    ///Lưu mới dữ liệu
    func saveShoppingCart(product: Product, selectSize: String, completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let db = ShoppingCart.db
        
        model.uid = db.document().documentID
        
        model.name = product.name
        model.quantity = 1
        model.price = product.price
        model.total = product.price
        model.imageURL = product.imageURL
        
        model.category = product.category
        model.subcategory = product.subcategory
        model.prID = product.productID
        
        model.saleOff = product.saleOff
        model.saleOffFromDate = product.saleOffFromDate
        model.saleOffToDate = product.saleOffToDate
        
        model.createdTime = longFormatter().string(from: Date())
        model.prUID = "\(product.category)-\(product.productID)-\(selectSize)"
        model.userID = userID
        
        let ref = db.document(uid)
        
        ref.setData(toDictionary()) { error in
            if let error = error {
                print("saveShoppingCart error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "quantity": quantity,
            "total": total,
            "price": price,
            "imageURL": imageURL,
            "color": color,
            "size": size,
            "category": category,
            "subcategory": subcategory,
            "prID": prID,
            "saleOff": saleOff,
            "saleOffFromDate": saleOffFromDate,
            "saleOffToDate": saleOffToDate,
            "createdTime": createdTime,
            "userID": userID,
            "prUID": prUID,
            "isReview": isReview,
            "status": status
        ]
    }
    
    class func removeObserver() {
        ShoppingCart.listener?.remove()
        ShoppingCart.listener = nil
    }
    
    class func removeObserverAdmin() {
        ShoppingCart.adminListener?.remove()
        ShoppingCart.adminListener = nil
    }
}

//MARK: - Delete

extension ShoppingCart {
    
    ///Xóa một ShoppingCart
    func deleteShoppingCart(completion: @escaping () -> Void) {
        let db = ShoppingCart.db.document(uid)
        db.delete { error in
            if let error = error {
                print("deleteShoppingCart error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}

//MARK: - Update

extension ShoppingCart {
    
    ///Cập nhật 'quantity' && 'total'
    ///addNum. Mặc định là +1. Hoặc bỏ bớt sản phẩm -1.
    func updateQuantity(addNum: Int = 1, completion: @escaping () -> Void) {
        let ref = ShoppingCart.db.document(uid)
        
        Firestore.firestore().runTransaction { transaction, errorPointer in
            let sfDocument: DocumentSnapshot
            
            do {
                try sfDocument = transaction.getDocument(ref)
                
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            //Quantity
            guard let oldQuantity = sfDocument.data()?["quantity"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve quantity from snapshot \(sfDocument)"])
                errorPointer?.pointee = error
                return nil
            }
            
            let newQuantity = oldQuantity + addNum
            let toDict: [String: Any] = [
                "quantity": newQuantity,
                "total": self.price * Double(newQuantity)
            ]
            
            guard newQuantity >= 1 else {
                return nil
            }
            
            transaction.updateData(toDict, forDocument: ref)
            return nil
            
        } completion: { object, error in
            if let error = error {
                print("Transaction failed: \(error.localizedDescription)")
                
            } else if let object = object {
                print("SUCCESSFULLY: \(object)")
            }
            
            completion()
        }
    }
    
    ///Cập nhật. status, orderDate, promoCode
    func updateShoppingCart(dict: [String: Any], completion: @escaping () -> Void) {
        let db = ShoppingCart.db.document(uid)
        db.updateData(dict) { error in
            if let error = error {
                print("updateStatus error: \(error)")
            }
            
            completion()
        }
    }
}

//MARK: - Fetch

extension ShoppingCart {
    
    ///Lấy duy nhất ShoppingCart. Để cập nhật 'Quantity' && 'Total'
    ///status: 0. Hàng đang trong giỏ
    static func fetchShoppingCart(product: Product, selectSize: String, completion: @escaping (ShoppingCart?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let prUID = "\(product.category)-\(product.productID)-\(selectSize)"
        let db = ShoppingCart.db
            .whereField("prUID", isEqualTo: prUID)
            .whereField("status", isEqualTo: "0")
            .whereField("userID", isEqualTo: userID)
        
        db.getDocuments { snapshot, error in
            var shopping: ShoppingCart?
            
            if let error = error {
                print("fetchShoppingCart error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                let array = snapshot.documents.map({ ShoppingCart(dict: $0.data()) })
                shopping = array.first(where: {
                    $0.category == product.category &&
                    $0.subcategory == product.subcategory &&
                    $0.prID == product.productID &&
                    $0.price == product.price &&
                    $0.saleOff == product.saleOff &&
                    $0.status == "0"
                })
            }
            
            DispatchQueue.main.async {
                completion(shopping)
            }
        }
    }
    
    ///Lấy tất cả đơn hàng cho Giỏ.
    ///Nếu giá trị status == "". Thì lấy tất cả các đơn thông qua userID
    ///Nếu status == "0". Đang lắng nghe các cập nhật
    ///0: Còn trong giỏ. 'Bag'.
    ///1: Đã đặt hàng. 'Order Placed'.
    ///2: Đang Giao hàng. Lịch sử mua hàng. 'On Going'.
    ///3: Đã giao hàng. Lịch sử mua hàng. 'Delivered'.
    ///4: Đã hủy. 'Cancelled'.
    static func fetchShoppingCartByCurrentUser(status: String, completion: @escaping ([ShoppingCart]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let db = ShoppingCart.db
        
        if status == "" {
            //Lấy tất cả từ userID
            let query = db.whereField("userID", isEqualTo: userID)
            
            query.getDocuments { snapshot, error in
                self.updateShoppingCartBy(snapshot: snapshot, error: error) { array  in
                    DispatchQueue.main.async {
                        completion(array)
                    }
                }
            }
            
        } else {
            //Lấy tất cả theo 'status' && 'userID'
            var query = db
                .whereField("userID", isEqualTo: userID)
                .whereField("status", isEqualTo: status)
            
            //Cập nhập giỏ hàng. Lấy tất cả
            if status == "0" {
                removeObserver()
                
                listener = query.addSnapshotListener { snapshot, error in
                    self.updateShoppingCartBy(snapshot: snapshot, error: error) { array  in
                        DispatchQueue.main.async {
                            completion(array)
                        }
                    }
                }
                
            } else {
                //Lấy các đơn hàng chưa đánh giá
                if status == "3" {
                    query = query.whereField("isReview", isEqualTo: false)
                }
                
                query.getDocuments { snapshot, error in
                    self.updateShoppingCartBy(snapshot: snapshot, error: error) { array  in
                        DispatchQueue.main.async {
                            completion(array)
                        }
                    }
                }
            }
        }
    }
    
    private static func updateShoppingCartBy(snapshot: QuerySnapshot?, error: Error?, completion: @escaping ([ShoppingCart]) -> Void) {
        var array: [ShoppingCart] = []
        
        if let error = error {
            print("fetchShoppingCartBy error: \(error.localizedDescription)")
            
        } else if let snapshot = snapshot {
            array = snapshot.documents
                .map({ ShoppingCart(dict: $0.data()) })
                .sorted(by: { $0.createdTime > $1.createdTime })
        }
        
        completion(array)
    }
    
    ///Lấy tất cả ShoppingCart cho Admin
    static func fetchAllShoppingCart(completion: @escaping ([ShoppingCart]) -> Void) {
        let db = ShoppingCart.db
        removeObserverAdmin()
        
        adminListener = db.addSnapshotListener { snapshot, error in
            self.updateShoppingCartBy(snapshot: snapshot, error: error) { array  in
                DispatchQueue.main.async {
                    completion(array)
                }
            }
        }
    }
}

//MARK: - Address from ShoppingCart

extension ShoppingCart {
    
    func saveAddress(completion: @escaping () -> Void) {
        guard let address = address else {
            return
        }
        
        let db = ShoppingCart.db.document(uid)
            .collection("address")
            .document(address.uid)
        
        db.setData(address.toDictionary()) { error in
            if let error = error {
                print("saveAddress error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
    
    static func fetchAddress(shoppingID: String, addressID: String, completion: @escaping (Address?) -> Void) {
        let db = ShoppingCart.db
            .document(shoppingID)
            .collection("address")
            .document(addressID)
        
        db.getDocument { snapshot, error in
            var address: Address?
            
            if let error = error {
                print("fetchAddress error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot, let dict = snapshot.data() {
                address = Address(dict: dict)
            }
            
            DispatchQueue.main.async {
                completion(address)
            }
        }
    }
}
