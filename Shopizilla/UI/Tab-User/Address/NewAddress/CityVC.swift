//
//  CityVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 30/04/2022.
//

import UIKit

protocol CityVCDelegate: AnyObject {
    func cityDidTap(vc: CityVC, selected: String, isCountry: Bool, isProvince: Bool, isCity: Bool, isWards: Bool)
}

class CityVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CityVCDelegate?
    
    private let containerView = UIView()
    private let popupView = UIView()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let searchView = UIView()
    private let searchTF = UITextField()
    private let removeBtn = ButtonAnimation()
    
    private var searchTimer: Timer? //Tự động tìm kiếm theo từ khóa
    private var keyword = "" //Từ khóa để tìm kiếm
    
    lazy var countries: [Country] = [] //Dành cho Quốc Tế
    lazy var states: [State] = [] //Dành cho Việt Nam
    
    lazy var allModels: [String] = [] //Lưu trữ tất cả
    lazy var models: [String] = [] //Dùng để hiển thị
    var cityDict: NSDictionary = [:]
    
    var countryTxt = ""
    var provinceTxt = ""
    var cityTxt = ""
    var wardTxt = ""
    
    var isCountry = false
    var isProvince = false
    var isCity = false
    var isWards = false
    
    var selected = "" //Chọn Tỉnh. Thành phố. Phường, xã
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
}

//MARK: - Setups

extension CityVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        containerView.backgroundColor = .black.withAlphaComponent(0.0)
        view.addSubview(containerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        containerView.addGestureRecognizer(tap)
        
        //TODO: - PopupView
        let popupH: CGFloat = screenWidth + 50
        popupView.frame = CGRect(x: 0.0, y: screenHeight-popupH, width: screenWidth, height: popupH)
        popupView.clipsToBounds = true
        popupView.backgroundColor = .white
        view.addSubview(popupView)
        
        //TODO: - SearchView
        searchView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50)
        searchView.clipsToBounds = true
        searchView.backgroundColor = .white
        popupView.addSubview(searchView)
        
        //TODO: - RemoveBtn
        removeBtn.tag = 0
        removeBtn.delegate = self
        removeBtn.isHidden = true
        
        //TODO: - SearchTF
        searchTF.searchTF(searchView, width: screenWidth-40, dl: self, bgColor: UIColor(hex: 0xEAEAF0), removeBtn: removeBtn)
        searchTF.frame.origin = CGPoint(x: 20.0, y: (50-36)/2)
        searchTF.returnKeyType = .search
        searchTF.addTarget(self, action: #selector(searchEditingChanged), for: .editingChanged)
        
        //TODO: - TableView
        tableView.frame = CGRect(x: 0.0, y: 50.0, width: screenWidth, height: screenWidth)
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = separatorColor
        tableView.separatorInset = UIEdgeInsets(top: 40.0, left: 20.0, bottom: 40.0, right: 20.0)
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 50.0
        tableView.register(CityTVCell.self, forCellReuseIdentifier: CityTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        popupView.addSubview(tableView)
        
        popupView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = .black.withAlphaComponent(0.8)
            self.popupView.transform = .identity
        }
    }
    
    @objc private func removeDidTap(_ sender: UIGestureRecognizer) {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        searchTF.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.popupView.transform = CGAffineTransform(translationX: 0.0, y: screenWidth)
            
        } completion: { (_) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func searchEditingChanged(_ tf: UITextField) {
        if let text = tf.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }
            
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchWithKeyword), userInfo: text, repeats: false)
        }
        
        removeBtn.isHidden = tf.text?.count == 0
    }
    
    @objc private func searchWithKeyword(_ notif: Timer) {
        if let text = notif.userInfo as? String {
            keyword = text
        }
        
        searchByKeywork()
    }
    
    private func removeHidden(_ isHidden: Bool) {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.removeBtn.isHidden = isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    private func searchByKeywork() {
        models = keyword != "" ? filterByKeyword() : allModels
        reloadData()
    }
    
    private func filterByKeyword() -> [String] {
        let array = allModels.filter({
            $0.lowercased().range(
                of: keyword.lowercased(),
                options: [.caseInsensitive, .diacriticInsensitive],
                range: nil,
                locale: .current) != nil
        })
        
        return array
    }
}

//MARK: - Add Observer

extension CityVC {
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: .keyboardWillShow, object: nil, queue: nil) { notif in
            if let height = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
               let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.popupView.frame.origin.y = screenHeight-screenWidth-50-(height/2)
                    self.view.layoutIfNeeded()
                }
            }
        }
        NotificationCenter.default.addObserver(forName: .keyboardWillHide, object: nil, queue: nil) { notif in
            if let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.popupView.frame.origin.y = screenHeight-screenWidth-50
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

//MARK: - SetData

extension CityVC {
    
    private func getData() {
        if isCountry {
            allModels = countries.map({ $0.name })
            sortedModels()
            selected = models.first(where: { $0 == countryTxt }) ?? ""
            reloadData()
            return
        }
        
        if isProvince {
            if countryTxt == "Vietnam" {
                allModels = states.map({ $0.name })
                
            } else {
                if let country = countries.first(where: { $0.name == countryTxt }) {
                    allModels = country.states.map({ $0.name })
                }
            }
            
            sortedModels()
            selected = models.first(where: { $0 == provinceTxt }) ?? ""
            reloadData()
            return
        }
        
        if isCity {
            if countryTxt == "Vietnam" {
                if let state = states.first(where: { $0.name == provinceTxt }) {
                    allModels = state.cities.map({ $0.name })
                }
                
            } else {
                if let country = countries.first(where: { $0.name == countryTxt }),
                    let state = country.states.first(where: { $0.name == provinceTxt }) {
                    allModels = state.cities.map({ $0.name })
                }
            }
            
            sortedModels()
            selected = models.first(where: { $0 == cityTxt }) ?? ""
            reloadData()
            return
        }
        
        if isWards {
            if let state = states.first(where: { $0.name == provinceTxt }),
                let city = state.cities.first(where: { $0.name == cityTxt }) {
                allModels = city.wards.map({ $0.nameWithType })
            }
            
            sortedModels()
            selected = models.first(where: { $0 == wardTxt }) ?? ""
            reloadData()
            return
        }
    }
    
    private func sortedModels() {
        allModels = allModels.sorted(by: {
            $0.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current) <
                $1.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        })
        models = allModels
    }
}

//MARK: - UITableViewDataSource

extension CityVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTVCell.id, for: indexPath) as! CityTVCell
        cell.nameLbl.text = models[indexPath.row]
        cell.accessoryType = selected == models[indexPath.row] ? .checkmark : .none
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CityVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selected = models[indexPath.row]
        reloadData()
        searchTF.resignFirstResponder()
        
        delegate?.cityDidTap(vc: self, selected: selected, isCountry: isCountry, isProvince: isProvince, isCity: isCity, isWards: isWards)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - ButtonAnimationDelegate

extension CityVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //SearchRemove
            searchTimer?.invalidate()
            searchTimer = nil
            
            searchTF.text = ""
            searchTF.resignFirstResponder()
            
            keyword = ""
            removeHidden(true)
            searchByKeywork()   
        }
    }
}

// MARK: - UITextFieldDelegate

extension CityVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTimer?.invalidate()
        searchTimer = nil
        
        var txt = ""
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            txt = text
        }
        
        removeHidden(textField.text?.count == 0 || txt == "")
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            keyword = text
            
        } else {
            keyword = ""
            textField.text = ""
        }
        
        searchByKeywork()
    }
}
