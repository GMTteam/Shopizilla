//
//  AddressViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 29/04/2022.
//

import UIKit

class AddressViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: AddressVC
    
    lazy var address: [Address] = []
    var selectedCode: PhoneCodeModel?
    
    //MARK: - Initializes
    init(vc: AddressVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension AddressViewModel {
    
    func getAddress() {
        guard let currentUser = vc.currentUser else {
            return
        }
        
        Address.fetchAddress(userID: currentUser.uid) { address in
            self.address = address.sorted(by: { $0.defaultAddress && !$1.defaultAddress })
            
            let addrTxt = "Add New Address".localized()
            
            if !self.vc.fromAddress {
                let txt = self.address.count == 0 ? addrTxt : "Continue".localized()
                self.vc.bottomView.setupTxtForBtn(txt)
                
            } else {
                self.vc.bottomView.setupTxtForBtn(addrTxt)
            }
            
            self.vc.bottomView.isHidden = false
            self.vc.hud?.removeHUD {}
            self.vc.reloadData()
        }
    }
    
    func heightForRow() -> CGFloat {
        let fontW: CGFloat = (screenWidth-40)/2
        let fontS: CGFloat = 17.0
        let txt1 = "Ng".estimatedTextRect(width: fontW, fontN: FontName.ppSemiBold, fontS: fontS).height
        let txt2 = "Ng".estimatedTextRect(width: fontW, fontN: FontName.ppRegular, fontS: fontS).height
        return 10 + txt1 + txt2*5 + 20
    }
    
    func getPhoneCode() {
        let code = "VN" //Locale.current.regionCode ?? "VN"
        
        PhoneCodeModel.shared { array in
            self.selectedCode = array.first(where: { $0.code == code })
            self.vc.reloadData()
        }
    }
}

//MARK: - SetupCell

extension AddressViewModel {
    
    func addressTVCell(_ cell: AddressTVCell, indexPath: IndexPath) {
        if address.count != 0 {
            let addr = address[indexPath.row]
            
            cell.innerView.isHidden = !addr.defaultAddress
            
            let fnAtt: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppSemiBold, size: 17.0)!,
                .foregroundColor: UIColor.black
            ]
            let addrAtt: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppRegular, size: 17.0)!,
                .foregroundColor: UIColor.black
            ]
            
            let phoneNumber = addr.phoneNumber
            
            /*
            if let selectedCode = selectedCode {
                let newNum = addr.phoneNumber.replacingOccurrences(of: "+", with: "")
                var index = newNum.startIndex
                
                for m in selectedCode.code.getMask() where index < newNum.endIndex {
                    if m == "X" {
                        phoneNumber.append(newNum[index])
                        index = newNum.index(after: index)
                        
                    } else {
                        phoneNumber.append(m)
                    }
                }
            }
            */
            
            let fnAttr = NSAttributedString(string: addr.fullName + "\n", attributes: fnAtt)
            let lineAttr = NSAttributedString(string: addr.street + "\n", attributes: addrAtt)
            let countryAttr = NSAttributedString(string: addr.country + "\n", attributes: addrAtt)
            let provinceAttr = NSAttributedString(string: addr.state + "\n", attributes: addrAtt)
            let cityAttr = NSAttributedString(string: addr.city + "\n", attributes: addrAtt)
            let phoneAttr = NSAttributedString(string: phoneNumber, attributes: addrAtt)
            
            let attr = NSMutableAttributedString()
            attr.append(fnAttr)
            attr.append(lineAttr)
            attr.append(countryAttr)
            attr.append(provinceAttr)
            attr.append(cityAttr)
            attr.append(phoneAttr)
            
            cell.addressLbl.attributedText = attr
            cell.delegate = vc
            cell.selectionStyle = .none
            
            cell.deleteBtn.isHidden = !vc.fromAddress
            cell.editBtn.isHidden = !vc.fromAddress
        }
    }
}
