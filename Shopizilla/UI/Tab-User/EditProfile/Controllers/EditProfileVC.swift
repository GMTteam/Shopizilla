//
//  EditProfileVC.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

class EditProfileVC: UIViewController {
    
    //MARK: - Properties
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let headerView = AvatarHeaderView()
    
    lazy var titles: [String] = [
        "Your Name".localized(),
        "Phone Number".localized(),
        "Date of Birth".localized(),
        "Gender".localized(),
        "Email".localized(),
        ""
    ]
    
    private var avatar: UIImage?
    private var fullNameTxt = ""
    private var genderTxt: String?
    private var dateOfBirthTxt: String?
    private var phoneNumberTxt = ""
    private var emailTxt = ""
    
    private let maxValue = 999_999_999_999_999_999
    private var codeTxt: String?
    private var selectedCode: PhoneCodeModel?
    
    var currentUser: User!
    
    private var yourNameTVCell: YourNameTVCell?
    private var phoneNumberTVCell: PhoneNumberTVCell?
    
    private var currentDate: Date? //Chuyển ngày tháng năm sinh thành Date()
    private var dateOfBirthVC: DateOfBirthVC?
    private var photoAlertVC: PhotoAlertVC?
    private var imagePickerHelper: ImagePickerHelper?
    
    private var willShowObs: Any?
    private var willHideObs: Any?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
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

extension EditProfileVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Edit Profile".localized()
        
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
        tableView.contentInset.top = 20.0
        tableView.register(YourNameTVCell.self, forCellReuseIdentifier: YourNameTVCell.id)
        tableView.register(PhoneNumberTVCell.self, forCellReuseIdentifier: PhoneNumberTVCell.id)
        tableView.register(DateOfBirthTVCell.self, forCellReuseIdentifier: DateOfBirthTVCell.id)
        tableView.register(GenderTVCell.self, forCellReuseIdentifier: GenderTVCell.id)
        tableView.register(EmailTVCell.self, forCellReuseIdentifier: EmailTVCell.id)
        tableView.register(SaveTVCell.self, forCellReuseIdentifier: SaveTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //TODO: - HeaderView
        let profW: CGFloat = screenWidth*0.3
        let headerH: CGFloat = 20 + profW + 30
        
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: headerH)
        tableView.tableHeaderView = headerView
        
        headerView.editBtn.tag = 1
        headerView.editBtn.delegate = self
        
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

extension EditProfileVC {
    
    private func updateUI() {
        guard let currentUser = currentUser else {
            return
        }
        
        headerView.updateUI(user: currentUser)
        
        fullNameTxt = currentUser.fullName
        phoneNumberTxt = currentUser.phoneNumber
        dateOfBirthTxt = currentUser.dateOfBirth
        genderTxt = currentUser.gender
        emailTxt = currentUser.email != "" ? currentUser.email : currentUser.type
        
        if let dateOfBirth = dateOfBirthTxt,
            let date = longFormatter().date(from: dateOfBirth) {
            currentDate = date
        }
        
        let code = Locale.current.regionCode ?? "VN"
        
        PhoneCodeModel.shared { array in
            self.selectedCode = array.first(where: { $0.code == code })
            self.codeTxt = self.selectedCode?.code
        }
        
        reloadData()
    }
}

//MARK: - AddObserver

extension EditProfileVC {
    
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

extension EditProfileVC: UITableViewDataSource {
    
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
            
            cell.textField.delegate = self
            cell.textField.text = fullNameTxt
            yourNameTVCell = cell
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTVCell.id, for: indexPath) as! PhoneNumberTVCell
            
            phoneNumberTVCell = cell
            cell.textField.delegate = self
            cell.textField.text = phoneNumberTxt
            cell.textField.keyboardType = .numberPad
            
            /*
            if let model = selectedCode {
                cell.textField.text = phoneNumberTxt.format(with: model)
            }
            */
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateOfBirthTVCell.id, for: indexPath) as! DateOfBirthTVCell
            
            cell.dateFormatter(currentDate)
            cell.dateLbl.textColor = dateOfBirthTxt == nil ? .gray : .black
            cell.delegate = self
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenderTVCell.id, for: indexPath) as! GenderTVCell
            
            cell.delegate = self
            cell.checkMaleView.isHidden = true
            cell.checkFemaleView.isHidden = true
            
            if genderTxt != nil || genderTxt != "" {
                if genderTxt == "Male".localized() {
                    cell.isMale = true
                    
                } else if genderTxt == "Female".localized() {
                    cell.isMale = false
                }
            }
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailTVCell.id, for: indexPath) as! EmailTVCell
            cell.emailLbl.text = emailTxt
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SaveTVCell.id, for: indexPath) as! SaveTVCell
            cell.saveBtn.tag = 2
            cell.saveBtn.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section].uppercased()
    }
}

//MARK: - UITableViewDelegate

extension EditProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = tableView.rowHeight
        if indexPath.section == titles.count-1 {
            height = 60.0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section != titles.count-1) ? 30.0 : 10.0
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

extension EditProfileVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        endDidTap()
        
        if sender.tag == 1 { //Avatar
            photoAlertVC?.removeFromParent()
            photoAlertVC?.view.removeFromSuperview()
            photoAlertVC = nil
            
            photoAlertVC = PhotoAlertVC()
            photoAlertVC!.view.frame = kWindow.bounds
            photoAlertVC!.delegate = self
            kWindow.addSubview(photoAlertVC!.view)
            
        } else if sender.tag == 2 { //Save
            guard let currentUser = currentUser else { return }
            
            guard fullNameTxt != "" else { return }
            
            let hud = HUD.hud(kWindow)
            
            var dict: [String: Any] = [
                "fullName": fullNameTxt,
                "isUpdate": true,
            ]
            
            if phoneNumberTxt != "" {
                dict["phoneNumber"] = phoneNumberTxt
            }
            
            if let dateOfBirthTxt = dateOfBirthTxt, dateOfBirthTxt != "" {
                dict["dateOfBirth"] = dateOfBirthTxt
            }
            
            if let genderTxt = genderTxt, genderTxt != "" {
                dict["gender"] = genderTxt
            }
            
            guard let avatar = avatar else {
                print(dict as NSDictionary)
                
                //Nếu ko có Avatar
                currentUser.updateInformation(dict: dict) { error in
                    hud.removeHUD {}

                    if let error = error {
                        self.showError(mes: error.localizedDescription)

                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                return
            }
            
            //Nếu có Avatar
            let storage = FirebaseStorage(image: avatar)
            storage.saveAvatar(userUID: currentUser.uid) { avatarLink in
                if let link = avatarLink {
                    dict["avatarLink"] = link
                }
                
                print(dict as NSDictionary)
                
                currentUser.updateInformation(dict: dict) { error in
                    hud.removeHUD {}

                    if let error = error {
                        self.showError(mes: error.localizedDescription)

                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - GenderTVCellDelegate

extension EditProfileVC: GenderTVCellDelegate {
    
    func checkDidTap(_ cell: GenderTVCell, genderTxt: String) {
        endDidTap()
        self.genderTxt = genderTxt
        tableView.reloadRows(at: [IndexPath(item: 0, section: 3)], with: .none)
    }
}

//MARK: - UITextFieldDelegate

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endDidTap()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == yourNameTVCell?.textField {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.containsOnlyLetters {
                fullNameTxt = text

            } else {
                fullNameTxt = ""
            }
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            
        } else if textField == phoneNumberTVCell?.textField {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.isNumber {
                phoneNumberTxt = text

            } else {
                phoneNumberTxt = ""
            }
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }
    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == yourNameTVCell?.textField {
            return true
            
        } else if textField == phoneNumberTVCell?.textField {
            let invalid = CharacterSet(charactersIn: "0123456789").inverted
            
            if string.rangeOfCharacter(from: invalid) == nil {
                if let text = textField.text {
                    let str = NSString(string: text).replacingCharacters(in: range, with: string)
                    
                    if str.isEmpty {
                        phoneNumberTxt = ""
                    }
                    
                    if let integer = Decimal(string: str.filter({ $0.isWholeNumber })) {
                        if integer <= Decimal(maxValue) {
                            //let model = selectedCode
                            //.format(with: model)
                            
                            textField.text = "\(integer)"
                            phoneNumberTxt = "\(integer)"
                        }
                        
                        return false
                    }
                }
                
                return true
            }
        }
        
        return false
    }
    */
}

//MARK: - DateOfBirthTVCellDelegate

extension EditProfileVC: DateOfBirthTVCellDelegate {
    
    func birthDidTap(_ cell: DateOfBirthTVCell) {
        endDidTap()
        createDateOfBirth()
    }
    
    private func createDateOfBirth() {
        dateOfBirthVC?.removeFromParent()
        dateOfBirthVC?.view.removeFromSuperview()
        dateOfBirthVC = nil
        
        dateOfBirthVC = DateOfBirthVC()
        dateOfBirthVC!.view.frame = kWindow.bounds
        dateOfBirthVC!.currentDate = currentDate
        dateOfBirthVC!.delegate = self
        kWindow.addSubview(dateOfBirthVC!.view)
    }
}

//MARK: - DateOfBirthVCDelegate

extension EditProfileVC: DateOfBirthVCDelegate {
    
    func doneDidSelect(_ vc: DateOfBirthVC, currentDate: Date) {
        vc.remove {
            self.dateOfBirthTxt = longFormatter().string(from: currentDate)
            self.currentDate = currentDate
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
        }
    }
}

//MARK: - PhotoAlertVCDelegate

extension EditProfileVC: PhotoAlertVCDelegate {
    
    func takePhoto() {
        imagePickerHelper = ImagePickerHelper(vc: self, isTakePhoto: true, completion: { image in
            self.setupAvatar(image)
        })
    }
    
    func photoFromLibrary() {
        imagePickerHelper = ImagePickerHelper(vc: self, isTakePhoto: false, completion: { image in
            self.setupAvatar(image)
        })
    }
    
    private func setupAvatar(_ image: UIImage?) {
        let size = headerView.profileImageView.frame.size
        let newImage = SquareImage.shared.squareImage(image!, targetSize: size)
        headerView.profileImageView.image = newImage
        avatar = image
    }
}
