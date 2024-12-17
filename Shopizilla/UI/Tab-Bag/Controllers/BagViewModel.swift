//
//  BagViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 27/04/2022.
//

import UIKit

class BagViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: BagVC
    
    let today = Date()
    
    //MARK: - Initializes
    init(vc: BagVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension BagViewModel {
    
    func getPromoCode() {
        guard let currentUser = appDL.currentUser else {
            return
        }
        
        //Nếu người dùng sử dụng mã giảm giá và coin hiện có
        if vc.promoCode != nil && vc.coin != 0.0 {
            updatePromoCode(currentUser)
            return
        }
        
        //Nếu người dùng sử dụng coin hiện có
        if vc.promoCode == nil && vc.coin != 0.0 {
            vc.bottomView.updateUI(vc.promoCode, coin: vc.coin)
            return
        }
        
        if vc.promoCode != nil {
            updatePromoCode(currentUser)
            
        } else {
            PromoCode.fetchPromoCode(vc.promoCodeUID) { promoCode in
                self.vc.promoCode = promoCode
                self.updatePromoCode(currentUser)
            }
        }
    }
    
    private func updatePromoCode(_ currentUser: User) {
        //Mã tồn tại
        guard let promoCode = vc.promoCode else {
            //Mã ko tồn tại
            vc.showAlert(title: "Oops".localized() + " !!!", mes: "Promo code does not exist.".localized()) {}
            return
        }
        
        //Mã chưa sử dụng
        guard !promoCode.userUIDs.contains(currentUser.uid) else {
            //Nếu đã sử dụng
            vc.showAlert(title: "Oops".localized() + " !!!", mes: "Promo code used.".localized()) {}
            return
        }
        
        //Mã còn hạn sử dụng
        guard let startDate = longFormatter().date(from: promoCode.startDate) else {
            return
        }
        guard let endDate = longFormatter().date(from: promoCode.endDate) else {
            return
        }
        
        if (startDate...endDate).contains(self.today) {
            vc.bagPromoCodeCVCell?.setTxtForBtn("Applied".localized())
            vc.bottomView.updateUI(promoCode, coin: vc.coin)
            
        } else {
            vc.showAlert(title: "Oops".localized() + " !!!", mes: "Promo code has expired.".localized()) {}
        }
    }
}

//MARK: - SetupCell

extension BagViewModel {
    
    func bagCVCell(_ cell: BagCVCell, indexPath: IndexPath) {
        let shopping = appDL.shoppings[indexPath.item]
        cell.bagCVCell(shopping, indexPath: indexPath)
        cell.updatePrice(shopping)
        cell.delegate = vc
    }
    
    func bagPromoCodeCVCell(_ cell: BagPromoCodeCVCell, indexPath: IndexPath) {
        cell.delegate = vc
        cell.promoCodeTF.text = vc.promoCodeUID
        cell.promoCodeTF.delegate = vc
    }
}
