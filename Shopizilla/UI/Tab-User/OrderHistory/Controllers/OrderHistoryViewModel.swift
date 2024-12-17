//
//  OrderHistoryViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/05/2022.
//

import UIKit

class OrderHistoryViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: OrderHistoryVC
    
    lazy var allShoppingStatus: [ShoppingStatus] = []
    lazy var shoppingStatus: [ShoppingStatus] = []
    
    //MARK: - Initializes
    init(vc: OrderHistoryVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension OrderHistoryViewModel {
    
    func getData() {
        //Nếu tài khoản đăng nhập ko là Admin
        if !User.isAdmin() {
            ShoppingCart.fetchShoppingCartByCurrentUser(status: "") { shoppings in
                self.updateData(shoppings)
            }
            
        } else {
            //Nếu tài khoản đăng nhập là Admin
            delay(duration: 1.0) {
                self.updateData(appDL.allShoppingCarts)
            }
        }
    }
    
    func updateData(_ shoppings: [ShoppingCart]) {
        //Lấy mảng từ ShoppingCart
        let newArray = ShoppingStatus.getNewShoppingStatus(shoppings: shoppings)
        let dict = Dictionary(grouping: newArray) { element in
            return element.orderID
        }
        
        //Nhóm các đơn hàng giống nhau
        let newShoppingStatus = ShoppingStatus.getNewShoppingStatus(dict: dict)
        allShoppingStatus = newShoppingStatus.sorted(by: {
            return $0.orderDate > $1.orderDate
        })
        
        loadDataBy()
    }
    
    //Lấy dữ liệu theo 'status'
    func loadDataBy() {
        let status = ShoppingCartModel.fromStringToNumber(str: vc.selectedStatus?.title ?? "")
        shoppingStatus = allShoppingStatus.filter({ $0.status == status })
        
        vc.reloadData()
        vc.topView.reloadData()
        vc.hud?.removeHUD {}
        
        vc.centerView.isHidden = shoppingStatus.count != 0
        vc.collectionView.isHidden = shoppingStatus.count == 0
    }
}

//MARK: - SetupCell

extension OrderHistoryViewModel {
    
    func orderHistoryTopCVCell(cell: OrderHistoryTopCVCell, indexPath: IndexPath) {
        let model = vc.models[indexPath.item]
        cell.titleLbl.text = model.title
        cell.isSelect = vc.selectedStatus?.index == model.index
        cell.redView.isHidden = true
        
        //Delivered
        if model.index == 2 && !User.isAdmin() {
            let shoppings = allShoppingStatus.flatMap({ $0.shoppings }).filter({
                !$0.isReview && $0.status == "3"
            })
            cell.redView.isHidden = shoppings.count == 0
        }
    }
    
    func orderHistoryCVCell(cell: OrderHistoryCVCell, indexPath: IndexPath) {
        let shop = shoppingStatus[indexPath.item]
        
        //TODO: - TopView
        let item = shop.shoppings.count
        cell.itemLbl.text = item == 1 ? ("(1 " + "item".localized() + ")") : ("(" + "\(item) " + "items".localized() + ")")
        cell.statusLbl.text = ShoppingCartModel.fromNumberToString(num: shop.status)
        cell.tag = indexPath.item
        
        if let shoppingCart = shop.shoppings.first {
            DownloadImage.shared.downloadImage(link: shoppingCart.imageURL) { image in
                if cell.tag == indexPath.item {
                    cell.coverImageView.image = image
                }
            }
        }
        
        cell.redView.isHidden = true
        
        //Delivered
        if vc.selectedStatus?.index == 2 && !User.isAdmin() {
            let shoppings = shop.shoppings.filter({ !$0.isReview && $0.status == "3" })
            cell.redView.isHidden = shoppings.count == 0
        }
        
        //TODO: - Center
        cell.item_2View.isHidden = shop.shoppings.count <= 1
        
        if shop.shoppings.count == 1 {
            cell.item_1View.updateUI(shop.shoppings[0])
        }
        
        if shop.shoppings.count >= 2 {
            cell.item_1View.updateUI(shop.shoppings[0])
            cell.item_2View.updateUI(shop.shoppings[1])
        }
        
        //TODO: - Bottom
        let perc = (100 - (shop.percentPromotion ?? 0.0))/100
        let total = ((shop.shoppings.map({
            $0.total * ((100 - $0.saleOff)/100)
            
        }).reduce(0, +)) * perc) + shop.shippingFee - (shop.coin/1000)
        
        let paidTxt = shop.isPaid ? "(PAID)".localized() : ""
        cell.totalLbl.text = "Total:".localized() + "\n" + total.formattedCurrency + " \(paidTxt)"
        
        cell.cancelBtn.isHidden = true
        cell.paidImageView.isHidden = true
        
        cell.delegate = vc
        cell.orderDateLbl.text = ""
        
        let paidImgName = shop.paymentMethod.replacingOccurrences(of: " ", with: "")
        var dateStr: String?
        
        if let selectedStatus = vc.selectedStatus {
            switch selectedStatus.index {
            case 0: //Order Placed
                dateStr = shop.orderDate
                
                let txt: String
                if User.isAdmin() {
                    txt = "Confirm".localized()
                    cell.cancelBtn.isHidden = false
                    
                } else {
                    txt = "Cancel".localized()
                    
                    cell.cancelBtn.isHidden = shop.isPaid
                    cell.paidImageView.isHidden = !shop.isPaid
                    
                    if shop.isPaid && paidImgName != "" {
                        cell.paidImageView.image = UIImage(named: "paid-\(paidImgName)")
                    }
                }
                
                updateCancel(cell: cell, txt: txt)
                
            case 1: //On Going
                dateStr = shop.onGoingDate
                
                if User.isAdmin() {
                    cell.cancelBtn.isHidden = false
                    updateCancel(cell: cell, txt: "Complete".localized())
                    
                } else {
                    cell.paidImageView.isHidden = !shop.isPaid
                    
                    if shop.isPaid && shop.paymentMethod != "" {
                        cell.paidImageView.image = UIImage(named: "paid-\(paidImgName)")
                    }
                }
                
            case 2: //Delivered
                dateStr = shop.deliveredDate
                
            case 3: //Cancelled
                dateStr = shop.cancelledDate
                
            default: break
            }
        }
        
        if let dateStr = dateStr,
            dateStr != "",
            let date = longFormatter().date(from: dateStr)
        {
            let f = createDateFormatter()
            f.dateFormat = "EEE, MMM d, yyyy"
            
            cell.orderDateLbl.text = f.string(from: date)
        }
    }
    
    private func updateCancel(cell: OrderHistoryCVCell, txt: String) {
        let cancelW = txt.estimatedTextRect(fontN: FontName.ppBold, fontS: 16.0).width + 30
        let cancelAttr = createMutableAttributedString(fgColor: .white, txt: txt)
        cell.cancelBtn.setAttributedTitle(cancelAttr, for: .normal)
        cell.cancelWConstraint.constant = cancelW
    }
}
