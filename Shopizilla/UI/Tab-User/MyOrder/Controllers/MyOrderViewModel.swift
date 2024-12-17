//
//  MyOrderViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/05/2022.
//

import UIKit

class MyOrderViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: MyOrderVC
    
    var address: Address?
    var isReview = false
    
    lazy var reviews: [Review] = [] //Sản phẩm này đã đánh giá chưa
    
    //MARK: - Initializes
    init(vc: MyOrderVC) {
        self.vc = vc
    }
}

//MARK: - Address

extension MyOrderViewModel {
    
    func getAddress() {
        if let shoppingStatus = vc.shoppingStatus,
           let shopping = shoppingStatus.shoppings.first,
            let addressID = shoppingStatus.addressID
        {
            ShoppingCart.fetchAddress(shoppingID: shopping.uid, addressID: addressID) { address in
                self.address = address
                self.vc.hud?.removeHUD {}
                self.vc.collectionView.isHidden = false
                self.vc.reloadData()
            }
        }
    }
}

//MARK: - Review

extension MyOrderViewModel {
    
    func getReview() {
        //Nếu mặt hàng này đã giao thành công
        if let shoppingStatus = vc.shoppingStatus, shoppingStatus.status == "3" {
            Review.fetchReviews(orderID: shoppingStatus.orderID) { reviews in
                self.reviews.removeAll()
                self.reviews = reviews
                
                let reviewIDs = self.reviews.map({ $0.productUID })
                
                //Nếu productUID nào chưa Review thì...
                let newShoppings = shoppingStatus.shoppings.filter({
                    !reviewIDs.contains("\($0.category)-\($0.prID)".uppercased())
                })
                
                DispatchQueue.main.async {
                    self.isReview = true
                    self.vc.collectionView.reloadData()
                    
                    if self.reviews.count == 0 || newShoppings.count != 0 {
                        self.vc.collectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: .bottom, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - SetupCell

extension MyOrderViewModel {
    
    func myOrderInfoCVCell(_ cell: MyOrderInfoCVCell, indexPath: IndexPath) {
        guard let shoppingStatus = vc.shoppingStatus else {
            return
        }
        
        cell.notifTitleLbl.text = ShoppingCartModel.fromNumberToString(num: shoppingStatus.status)
        cell.orderNumberTitleLbl.text = "Order number".localized()
        cell.orderDateTitleLbl.text = "Order date".localized()
        cell.orderNumberLbl.text = "#\(shoppingStatus.orderID)"
        cell.delegate = vc
        
        let paidImgName = shoppingStatus.paymentMethod.replacingOccurrences(of: " ", with: "")
        if paidImgName != "" {
            cell.payImageView.image = UIImage(named: "paid-success\(paidImgName)")
        }
        
        if let address = address  {
            cell.addressTitleLbl.text = "Delivery address".localized()
            cell.addressLbl.text = address.street + "\n" + "\(address.city), \(address.state), \(address.country)" + "\n" + address.phoneNumber
        }
        
        if let orderDate = longFormatter().date(from: shoppingStatus.orderDate) {
            let f = createDateFormatter()
            f.dateFormat = "MMM d, yyyy"
            
            let orderStr = f.string(from: orderDate)
            cell.orderDateLbl.text = orderStr
            
            let delivedDate = orderDate.addingTimeInterval(60*60*24*7)
            let delivedStr = f.string(from: delivedDate)
            let txt: String
            
            switch shoppingStatus.status {
            case "1": txt = "Orders placed on".localized() + " " + "\(orderStr)."
            case "2": txt = "Parcel will be delivered before".localized() + " " + "\(delivedStr)."
            case "3": txt = "Parcel is successfully delivered.".localized()
            default: txt = "Order has been cancelled.".localized()
            }
            
            cell.notifSubtitleLbl.text = txt
        }
    }
    
    func bagCVCell(_ cell: BagCVCell, indexPath: IndexPath) {
        guard let shoppingStatus = vc.shoppingStatus else {
            return
        }
        let shopping = shoppingStatus.shoppings[indexPath.item]
        cell.bagCVCell(shopping, indexPath: indexPath)
        
        cell.cvLeadingConstraint.constant = 20.0
        cell.cvTrailingConstraint.constant = -20.0
        
        cell.numLbl.text = ""
        cell.nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        
        cell.newPriceLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        
        let price = shopping.price * ((100 - shopping.saleOff)/100)
        cell.newPriceLbl.text = price.formattedCurrency + " (x \(shopping.quantity))"
        
        cell.trashBtn.isHidden = true
        cell.btnSV.isHidden = true
        cell.oldPriceLbl.isHidden = true
    }
    
    func myOrderSubCVCell(_ cell: MyOrderSubCVCell, indexPath: IndexPath) {
        guard let shoppingStatus = vc.shoppingStatus else {
            return
        }
        
        let fee = shoppingStatus.shippingFee
        cell.shippingFeeLbl.text = fee == 0 ? "Free" : fee.formattedCurrency
        cell.updatePrice(shoppingStatus)
        
        cell.delegate = vc
        cell.rateBtn.isHidden = true
        cell.rateView.isHidden = true
        
        //isReview: Đã lấy Review từ Firebase.
        //TK đăng nhập ko phải là Admin.
        if isReview && !User.isAdmin() {
            //Kiểm tra sản phẩm đã đánh giá chưa
            if reviews.count != 0 {
                //Lọc lấy các productUID từ Reviews thông qua orderID
                let reviewIDs = reviews.map({ $0.productUID })
                
                //Nếu productUID nào chưa Review thì...
                let newShoppings = shoppingStatus.shoppings.filter({
                    !reviewIDs.contains("\($0.category)-\($0.prID)".uppercased())
                })
                
                cell.rateBtn.isHidden = newShoppings.count == 0
                cell.rateView.isHidden = newShoppings.count == 0
                
            } else {
                //Nếu chưa đánh giá
                //Kiểm tra xem nó được đi đến từ đâu. Order Placed/ On Going / ...etc...
                cell.rateBtn.isHidden = !(shoppingStatus.status == "3")
                cell.rateView.isHidden = !(shoppingStatus.status == "3")
            }
        }
    }
}
