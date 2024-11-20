//
//  PromoCodeViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 15/06/2022.
//

import UIKit

class PromoCodeViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: PromoCodeVC
    
    lazy var promoCodes: [PromoCode] = []
    let today = Date()
    
    var isLoaded = false
    
    //MARK: - Initializes
    init(vc: PromoCodeVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension PromoCodeViewModel {
    
    func getData() {
        PromoCode.fetchAllPromoCode { promoCodes in
            if let user = appDL.currentUser {
                //Lọc mã sử dụng cho toàn bộ User 'toUserUIDs == []'
                //Hoặc lọc mã chỉ áp dụng cho người dùng này 'toUserUIDs.contains(user.uid)'
                self.promoCodes = promoCodes.filter({ $0.toUserUIDs == [] || $0.toUserUIDs.contains(user.uid) })
            }
            
            if self.vc.promoCode != nil {
                self.vc.promoCode = self.promoCodes.first(where: { $0.uid == self.vc.promoCode?.uid })
            }
            
            self.vc.reloadData()
            self.vc.hud?.removeHUD {}
            self.isLoaded = true
            self.vc.view.viewWithTag(111)?.removeFromSuperview()
        }
    }
}

//MARK: - SetupCell

extension PromoCodeViewModel {
    
    func coinTVCell(_ cell: CoinTVCell, indexPath: IndexPath) {
        if let user = appDL.currentUser, isLoaded {
            cell.bgImageView.image = UIImage(named: "promo-coinBG")
            cell.iconImageView.image = UIImage(named: "promo-coinIcon")
            cell.coinImageView.image = UIImage(named: "icon-coin")
            
            cell.checkView.isHidden = false
            cell.innerView.isHidden = false
            
            cell.coinLbl.text = kText(user.coin)
            cell.subLbl.text = "1000c = $1"
            cell.isSelect = vc.coin != 0.0
        }
    }
    
    func promoCodeTVCell(_ cell: PromoCodeTVCell, indexPath: IndexPath) {
        let promoCode = promoCodes[indexPath.row]
        
        let isDis = promoCode.type == PromoCode.PromoType.Discount.rawValue
        let bgImage = UIImage(named: isDis ? "promo-discountBG" : "promo-freeshipBG")
        let iconImage = UIImage(named: isDis ? "promo-discountIcon" : "promo-freeshipIcon")
        
        cell.bgImageView.image = bgImage
        cell.iconImageView.image = iconImage
        cell.titleLbl.text = promoCode.type.uppercased()
        
        cell.containerView.alpha = 1.0
        cell.containerView.isUserInteractionEnabled = true
        
        if let percent = Formatter.withDecimal.string(for: promoCode.percent) {
            cell.percentLbl.text = percent + "%"
        }
        
        if let startDate = longFormatter().date(from: promoCode.startDate),
           let endDate = longFormatter().date(from: promoCode.endDate),
            let user = appDL.currentUser
        {
            let startTime = NSDate().timeIntervalSince(startDate)
            let endTime = endDate.timeIntervalSince(startDate)
            let remaining = endTime - startTime
            
            let day = String(DateModel.shared.days(remaining, f: "%0.1d"))
            let hour = String(DateModel.shared.hours(remaining, f: "%0.1d"))
            let minute = String(DateModel.shared.minutes(remaining, f: "%0.1d"))
            
            var txt = ""
            
            if day != "0" {
                let str = day == "1" ? "day".localized() : "days".localized()
                txt = "Only \(day) \(str) left"

            } else {
                if hour != "0" {
                    let str = hour == "1" ? "hour".localized() : "hours".localized()
                    txt = "Only \(hour) \(str) left"

                } else {
                    if minute != "0" {
                        let str = minute == "1" ? "minute".localized() : "minutes".localized()
                        txt = "Only \(minute) \(str) left"

                    } else {
                        txt = "Expired".localized()
                    }
                }
            }
            
            cell.timeLbl.text = txt
            cell.timeLbl.isHidden = txt == ""
            
            let enable = (startDate...endDate).contains(today) && !promoCode.userUIDs.contains(user.uid)
            
            cell.containerView.alpha = enable ? 1.0 : 0.4
            cell.containerView.isUserInteractionEnabled = enable
        }
        
        cell.isSelect = promoCode.uid == vc.promoCode?.uid
    }
}
