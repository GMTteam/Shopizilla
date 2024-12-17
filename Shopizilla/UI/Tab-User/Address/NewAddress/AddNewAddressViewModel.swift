//
//  AddNewAddressViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 17/05/2022.
//

import UIKit

class AddNewAddressViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: AddNewAddressVC
    
    lazy var countries: [Country] = [] //Dành cho Quốc Tế
    lazy var states: [State] = [] //Dành cho Việt Nam
    
    //MARK: - Initializes
    init(vc: AddNewAddressVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension AddNewAddressViewModel {
    
    func getData() {
        if let url = Bundle.main.url(forResource: "Cities-VN.json", withExtension: nil) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        self.states = dict.allValues.map({ State(vnDict: $0 as! NSDictionary) })
                    }
                    
                } catch let error as NSError {
                    print("getCity error: \(error.localizedDescription)")
                }
            }
        }
        
        if let url = Bundle.main.url(forResource: "countries+states+cities.json", withExtension: nil) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    if let array = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                        self.countries = array.map({ Country(dict: $0 as! NSDictionary) })
                    }
                    
                } catch let error as NSError {
                    print("getCountries error: \(error.localizedDescription)")
                }
            }
        }
    }
}

//MARK: - SetupCell

extension AddNewAddressViewModel {
    
    func fullNameCell(_ cell: YourNameTVCell, indexPath: IndexPath) {
        cell.textField.delegate = vc
        cell.textField.text = vc.fullNameTxt
        cell.textField.placeholder = "Full name".localized()
        cell.isUserInteractionEnabled = vc.isEdit
        vc.yourNameTVCell = cell
    }
    
    func streetCell(_ cell: YourNameTVCell, indexPath: IndexPath) {
        cell.textField.delegate = vc
        cell.textField.text = vc.addressLineTxt
        cell.textField.placeholder = "Street address".localized()
        cell.isUserInteractionEnabled = vc.isEdit
        vc.addressLineTVCell = cell
    }
    
    func countryCell(_ cell: DateOfBirthTVCell, indexPath: IndexPath) {
        cell.dateLbl.text = vc.countryTxt == "" ? "Country" : vc.countryTxt
        cell.dateLbl.textColor = vc.countryTxt == "" ? .placeholderText : .black
        cell.delegate = vc
        cell.arrowImgView.isHidden = !vc.isEdit
        cell.isUserInteractionEnabled = vc.isEdit
        vc.countryTVCell = cell
    }
    
    func stateCell(_ cell: DateOfBirthTVCell, indexPath: IndexPath) {
        cell.dateLbl.text = vc.stateTxt == "" ? "State/Province".localized() : vc.stateTxt
        cell.dateLbl.textColor = vc.stateTxt == "" ? .placeholderText : .black
        cell.delegate = vc
        cell.arrowImgView.isHidden = !vc.isEdit
        cell.isUserInteractionEnabled = vc.isEdit
        vc.provinceTVCell = cell
    }
    
    func cityCell(_ cell: DateOfBirthTVCell, indexPath: IndexPath) {
        cell.dateLbl.text = vc.cityTxt == "" ? "City/Town".localized() : vc.cityTxt
        cell.dateLbl.textColor = vc.cityTxt == "" ? .placeholderText : .black
        cell.delegate = vc
        cell.arrowImgView.isHidden = !vc.isEdit
        cell.isUserInteractionEnabled = vc.isEdit
        vc.cityTVCell = cell
    }
    
    func wardCell(_ cell: DateOfBirthTVCell, indexPath: IndexPath) {
        cell.dateLbl.text = vc.wardTxt == "" ? "Wards/Village".localized() : vc.wardTxt
        cell.dateLbl.textColor = vc.wardTxt == "" ? .placeholderText : .black
        cell.delegate = vc
        cell.arrowImgView.isHidden = !vc.isEdit
        cell.isUserInteractionEnabled = vc.isEdit
        vc.wardsTVCell = cell
    }
    
    func phoneNumberCell(_ cell: PhoneNumberTVCell, indexPath: IndexPath) {
        cell.textField.delegate = vc
        cell.textField.text = vc.phoneNumberTxt
        cell.textField.keyboardType = .numberPad
        cell.isUserInteractionEnabled = vc.isEdit
        vc.phoneNumberTVCell = cell
    }
    
    func saveCell(_ cell: SaveTVCell, indexPath: IndexPath) {
        cell.saveBtn.tag = 2
        cell.saveBtn.delegate = vc
        cell.saveBtn.isHidden = !vc.isEdit
    }
}
