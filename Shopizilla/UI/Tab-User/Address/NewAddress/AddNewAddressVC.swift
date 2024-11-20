//
//  AddNewAddNew.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 29/04/2022.
//

import UIKit

protocol AddNewAddressVCDelegate: AnyObject {
    func addNewAddressDidTap(_ vc: AddNewAddressVC)
}

class AddNewAddressVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: AddNewAddressVCDelegate?
    
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    lazy var titles: [TitleAddressModel] = {
        return TitleAddressModel.shared()
    }()
    
    var fullNameTxt = ""
    var addressLineTxt = "" //Tên đường
    var countryTxt = ""
    var countryCodeTxt = ""
    var stateTxt = ""
    var cityTxt = ""
    var wardTxt = ""
    var phoneNumberTxt = ""
    var defaultAddress = false
    
    var address: Address!
    var currentUser: User!
    
    var yourNameTVCell: YourNameTVCell?
    var addressLineTVCell: YourNameTVCell?
    var countryTVCell: DateOfBirthTVCell?
    var provinceTVCell: DateOfBirthTVCell?
    var cityTVCell: DateOfBirthTVCell?
    var wardsTVCell: DateOfBirthTVCell?
    var phoneNumberTVCell: PhoneNumberTVCell?
    
    var selectedCountry: Country?
    var selectedState: State?
    var selectedCity: City?
    var selectedWard: Ward?
    var isEdit = true //Cho phép sửa ko. Nếu đi từ MyOrder thì là false
    
    private var cityVC: CityVC?
    
    private var willShowObs: Any?
    private var willHideObs: Any?
    
    private var viewModel: AddNewAddressViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: willShowObs)
        removeObserverBy(observer: willHideObs)
    }
}

//MARK: - Setups

extension AddNewAddressVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        viewModel = AddNewAddressViewModel(vc: self)
        
        let txt: String
        if !isEdit {
            txt = "Address Detail".localized()
            
        } else {
            txt = address != nil ? "Update Address".localized() : "New Address".localized()
        }
        
        navigationItem.title = txt
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        tableView.register(YourNameTVCell.self, forCellReuseIdentifier: YourNameTVCell.id)
        tableView.register(DateOfBirthTVCell.self, forCellReuseIdentifier: DateOfBirthTVCell.id)
        tableView.register(PhoneNumberTVCell.self, forCellReuseIdentifier: PhoneNumberTVCell.id)
        tableView.register(SaveTVCell.self, forCellReuseIdentifier: SaveTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endDidTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func endDidTap() {
        view.endEditing(true)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UpdateUI

extension AddNewAddressVC {
    
    private func updateUI() {
        if let address = address {
            fullNameTxt = address.fullName
            addressLineTxt = address.street
            countryTxt = address.country
            stateTxt = address.state
            cityTxt = address.city
            wardTxt = address.ward
            phoneNumberTxt = address.phoneNumber
            defaultAddress = address.defaultAddress
        }
        
        if let currentUser = currentUser {
            if fullNameTxt == "" {
                fullNameTxt = currentUser.fullName
            }
            
            if phoneNumberTxt == "" {
                phoneNumberTxt = currentUser.phoneNumber
            }
        }
        
        reloadData()
    }
}

//MARK: - AddObserver

extension AddNewAddressVC {
    
    private func addObserver() {
        willShowObs = NotificationCenter.default.addObserver(forName: .keyboardWillShow, object: nil, queue: nil) { notif in
            if let height = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
               let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.tableView.contentInset.bottom = height
                    self.view.layoutIfNeeded()
                }
            }
        }
        willHideObs = NotificationCenter.default.addObserver(forName: .keyboardWillHide, object: nil, queue: nil) { notif in
            if let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.tableView.contentInset.bottom = 0.0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension AddNewAddressVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: YourNameTVCell.id, for: indexPath) as! YourNameTVCell
            viewModel.fullNameCell(cell, indexPath: indexPath)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: YourNameTVCell.id, for: indexPath) as! YourNameTVCell
            viewModel.streetCell(cell, indexPath: indexPath)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateOfBirthTVCell.id, for: indexPath) as! DateOfBirthTVCell
            viewModel.countryCell(cell, indexPath: indexPath)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateOfBirthTVCell.id, for: indexPath) as! DateOfBirthTVCell
            viewModel.stateCell(cell, indexPath: indexPath)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateOfBirthTVCell.id, for: indexPath) as! DateOfBirthTVCell
            viewModel.cityCell(cell, indexPath: indexPath)
            
            var isHidden = false
            
            if countryTxt != "",
               let country = viewModel.countries.first(where: { $0.name == countryTxt }),
               let state = country.states.first(where: { $0.name == stateTxt }) {
                isHidden = state.cities.count == 0
            }
            
            cell.isHidden = isHidden
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateOfBirthTVCell.id, for: indexPath) as! DateOfBirthTVCell
            viewModel.wardCell(cell, indexPath: indexPath)
            cell.isHidden = countryTxt != "Vietnam"
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTVCell.id, for: indexPath) as! PhoneNumberTVCell
            viewModel.phoneNumberCell(cell, indexPath: indexPath)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SaveTVCell.id, for: indexPath) as! SaveTVCell
            viewModel.saveCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section].title.uppercased()
    }
}

//MARK: - UITableViewDelegate

extension AddNewAddressVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = tableView.rowHeight
        
        if indexPath.section == titles.count-1 {
            height = 60.0
        }
        
        if indexPath.section == 4 {
            if countryTxt != "",
               let country = viewModel.countries.first(where: { $0.name == countryTxt }),
               let state = country.states.first(where: { $0.name == stateTxt }) {
                height = state.cities.count == 0 ? 0.0 : height
            }
        }
        
        if indexPath.section == 5 {
            height = countryTxt == "Vietnam" ? height : 0.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = (section != titles.count-1) ? 30.0 : 10.0
        
        if section == 4 {
            if countryTxt != "",
               let country = viewModel.countries.first(where: { $0.name == countryTxt }),
               let state = country.states.first(where: { $0.name == stateTxt }) {
                height = state.cities.count == 0 ? 0.0 : height
            }
        }
        
        if section == 5 {
            height = countryTxt == "Vietnam" ? height : 0.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != titles.count-1 {
            let r = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 30.0)
            let headerView = UIView(frame: r)
            headerView.backgroundColor = .white
            
            let titleLbl = UILabel(frame: CGRect(x: 20.0, y: 0.0, width: screenWidth-40, height: 30.0))
            titleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
            titleLbl.textColor = .darkGray
            titleLbl.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
            headerView.addSubview(titleLbl)
            
            return headerView
        }
        
        return nil
    }
}

//MARK: - ButtonAnimationDelegate

extension AddNewAddressVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        endDidTap()
        
        if sender.tag == 2 { //Save
            guard let currentUser = currentUser else { return }
            
            guard fullNameTxt != "" else {
                setupAnimBorderView(yourNameTVCell!.containerView)
                return
            }
            guard addressLineTxt != "" else {
                setupAnimBorderView(addressLineTVCell!.containerView)
                return
            }
            guard countryTxt != "" else {
                setupAnimBorderView(countryTVCell!.containerView)
                return
            }
            guard stateTxt != "" else {
                setupAnimBorderView(provinceTVCell!.containerView)
                return
            }
            
            if countryTxt != "",
               let country = viewModel.countries.first(where: { $0.name == countryTxt }),
               let state = country.states.first(where: { $0.name == stateTxt }),
               state.cities.count != 0
            {
                guard cityTxt != "" else {
                    setupAnimBorderView(cityTVCell!.containerView)
                    return
                }
            }
            
            if countryTxt == "Vietnam" {
                guard wardTxt != "" else {
                    setupAnimBorderView(wardsTVCell!.containerView)
                    return
                }
            }
            
            guard phoneNumberTxt != "" else {
                setupAnimBorderView(phoneNumberTVCell!.containerView)
                return
            }
            
            let color = UIColor.lightGray.withAlphaComponent(0.5)
            borderView(yourNameTVCell!.containerView, color: color)
            borderView(addressLineTVCell!.containerView, color: color)
            borderView(countryTVCell!.containerView, color: color)
            borderView(provinceTVCell!.containerView, color: color)
            borderView(cityTVCell!.containerView, color: color)
            borderView(wardsTVCell!.containerView, color: color)
            borderView(phoneNumberTVCell!.containerView, color: color)
            
            let hud = HUD.hud(kWindow)
            
            guard address == nil else {
                //Update Address
                let dict: [String: Any] = [
                    "fullName": fullNameTxt,
                    "street": addressLineTxt,
                    "country": countryTxt,
                    "state": stateTxt,
                    "city": cityTxt,
                    "ward": wardTxt,
                    "countryCode": countryCodeTxt,
                    "phoneNumber": phoneNumberTxt,
                    "createdTime": longFormatter().string(from: Date())
                ]
                
                address.updateAddress(dict: dict) {
                    hud.removeHUD {}
                    self.delegate?.addNewAddressDidTap(self)
                    print("*** updateAddress")
                }
                
                return
            }
            
            //New Address
            let model = AddressModel(fullName: fullNameTxt,
                                     street: addressLineTxt,
                                     country: countryTxt,
                                     state: stateTxt,
                                     city: cityTxt,
                                     ward: wardTxt,
                                     phoneNumber: phoneNumberTxt,
                                     userID: currentUser.uid,
                                     countryCode: countryCodeTxt,
                                     defaultAddress: defaultAddress,
                                     createdTime: longFormatter().string(from: Date()))
            let address = Address(model: model)
            
            address.saveAddress {
                hud.removeHUD {}
                self.delegate?.addNewAddressDidTap(self)
                print("*** saveAddress")
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddNewAddressVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endDidTap()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let color = UIColor.lightGray.withAlphaComponent(0.5)
        if textField == yourNameTVCell?.textField {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.containsOnlyLetters {
                fullNameTxt = text
                borderView(yourNameTVCell!.containerView, color: color)
                
            } else {
                fullNameTxt = ""
            }
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            
        } else if textField == addressLineTVCell?.textField {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty
            {
                addressLineTxt = text
                borderView(addressLineTVCell!.containerView, color: color)

            } else {
                addressLineTxt = ""
            }
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            
        } else if textField == phoneNumberTVCell?.textField {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty
            {
                phoneNumberTxt = text
                borderView(wardsTVCell!.containerView, color: color)

            } else {
                phoneNumberTxt = ""
            }
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 6)], with: .none)
        }
    }
}

//MARK: - DateOfBirthTVCellDelegate

extension AddNewAddressVC: DateOfBirthTVCellDelegate {
    
    func birthDidTap(_ cell: DateOfBirthTVCell) {
        endDidTap()
        
        if let indexPath = tableView.indexPath(for: cell) {
            let item = titles[indexPath.section]
            
            var isCountry = false
            var isProvince = false
            var isCity = false
            var isWards = false
            
            switch item.symbol {
            case "fullName-": break //Full Name
            case "street-": break //Street
            case "country-": //Country
                isCountry = true
                
            case "state-": //State/Province
                if countryTxt == "" { return }
                isProvince = true
                
            case "city-": //City/Town
                if stateTxt == "" { return }
                isCity = true
                
            case "ward-": //Ward/Village
                if cityTxt == "" { return }
                isWards = true
                
            case "phoneNumber-": break //Phone Number
            default: break
            }
            
            cityVC?.removeFromParent()
            cityVC = nil
            
            cityVC = CityVC()
            cityVC?.view.frame = kWindow.bounds
            cityVC?.delegate = self
            
            cityVC?.isCountry = isCountry
            cityVC?.isProvince = isProvince
            cityVC?.isCity = isCity
            cityVC?.isWards = isWards
            
            cityVC?.countries = viewModel.countries
            cityVC?.states = viewModel.states
            
            cityVC?.countryTxt = countryTxt
            cityVC?.provinceTxt = stateTxt
            cityVC?.cityTxt = cityTxt
            cityVC?.wardTxt = wardTxt
            
            kWindow.addSubview(cityVC!.view)
        }
    }
}

//MARK: - CityVCDelegate

extension AddNewAddressVC: CityVCDelegate {
    
    func cityDidTap(vc: CityVC, selected: String, isCountry: Bool, isProvince: Bool, isCity: Bool, isWards: Bool) {
        vc.removeHandler {
            let color = UIColor.lightGray.withAlphaComponent(0.5)
            
            if isCountry {
                if self.countryTxt != selected {
                    self.stateTxt = ""
                    self.cityTxt = ""
                    self.wardTxt = ""
                }
                
                self.countryTxt = selected
                self.countryCodeTxt = self.viewModel.countries.first(where: {
                    $0.name == self.countryTxt
                })?.code ?? ""
                borderView(self.countryTVCell!.containerView, color: color)
                
            } else if isProvince {
                if self.stateTxt != selected {
                    self.cityTxt = ""
                    self.wardTxt = ""
                }
                
                self.stateTxt = selected
                borderView(self.provinceTVCell!.containerView, color: color)
                
            } else if isCity {
                if self.cityTxt != selected {
                    self.wardTxt = ""
                }
                
                self.cityTxt = selected
                borderView(self.cityTVCell!.containerView, color: color)
                
            } else if isWards {
                self.wardTxt = selected
                borderView(self.phoneNumberTVCell!.containerView, color: color)
            }
            
            self.reloadData()
        }
    }
}
