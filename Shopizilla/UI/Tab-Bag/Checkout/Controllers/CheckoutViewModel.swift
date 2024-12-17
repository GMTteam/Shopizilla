//
//  CheckoutViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 01/05/2022.
//

import UIKit

class CheckoutViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: CheckoutVC
    
    lazy var shippingMethods: [ShippingMethod] = []
    lazy var paymentMethods: [PaymentMethod] = []
    
    var selectedShipping: ShippingMethod?
    var selectedPayment: PaymentMethod?
    
    //MARK: - Initializes
    init(vc: CheckoutVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension CheckoutViewModel {
    
    func getShippingMethod() {
        ShippingMethod.fetchShippingMethods { shippingMethods in
            self.shippingMethods = shippingMethods
            self.selectedShipping = shippingMethods.first(where: { $0.index == 0 })
            
            self.vc.bottomView.isHidden = self.shippingMethods.count == 0
            self.updateTotal()
            
            self.getPaymentMethod()
        }
    }
    
    private func getPaymentMethod() {
        PaymentMethod.fetchPaymentMethods { paymentMethods in
            self.paymentMethods = paymentMethods
            
            self.vc.bottomView.setupAlpha(self.selectedShipping != nil && self.selectedPayment != nil)
            self.vc.hud?.removeHUD {}
            self.vc.reloadData()
        }
    }
    
    func updateTotal() {
        let fee = selectedShipping?.fee ?? 0.0
        vc.bottomView.updateUI(vc, promoCode: vc.promoCode, shippingFee: fee, coin: vc.coin)
    }
}

//MARK: - SetupCell

extension CheckoutViewModel {
    
    func checkoutTVCellSec1(_ cell: CheckoutTVCell, indexPath: IndexPath) {
        let shipping = shippingMethods[indexPath.row]
        
        cell.feeLbl.isHidden = false
        cell.feeLbl.text = shipping.fee.formattedCurrency
        
        cell.nameLbl.text = shipping.name
        cell.innerView.isHidden = selectedShipping?.uid != shipping.uid
        cell.separatorView.isHidden = shippingMethods.count-1 == indexPath.row
        cell.iconImageView.isHidden = true
    }
    
    func checkoutTVCellSec2(_ cell: CheckoutTVCell, indexPath: IndexPath) {
        let payment = paymentMethods[indexPath.row]
        
        cell.feeLbl.isHidden = true
        cell.feeLbl.text = ""
        
        cell.nameLbl.text = payment.name
        cell.innerView.isHidden = selectedPayment?.uid != payment.uid
        cell.separatorView.isHidden = paymentMethods.count-1 == indexPath.row
        cell.iconImageView.isHidden = true
        
        if let icon = payment.iconURL {
            cell.iconImageView.isHidden = false
            cell.iconImageView.image = UIImage(named: icon)
        }
    }
}
