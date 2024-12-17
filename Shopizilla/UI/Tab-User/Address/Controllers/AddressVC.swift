//
//  AddressVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 29/04/2022.
//

import UIKit

class AddressVC: UIViewController {
    
    //MARK: - Properties
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    let bottomView = BagBottomView()
    
    var fromAddress = true
    var promoCode: PromoCode? //Đến trang thanh toán
    var coin: Double = 0.0 //Đến trang thanh toán
    
    var hud: HUD?
    var currentUser: User!
    
    private var viewModel: AddressViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.getAddress()
        viewModel.getPhoneCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.address.count == 0 {
            hud = HUD.hud(view)
        }
    }
}

//MARK: - Setups

extension AddressVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Address".localized()
        
        viewModel = AddressViewModel(vc: self)
        
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
        tableView.rowHeight = viewModel.heightForRow()
        tableView.register(AddressTVCell.self, forCellReuseIdentifier: AddressTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //TODO: - BottomView
        bottomView.isHidden = true
        view.addSubview(bottomView)
        
        bottomView.orderBtn.delegate = self
        bottomView.orderBtn.tag = 1
        
        bottomView.totalView.isHidden = fromAddress
        
        /*
        var bottomH: CGFloat = (appDL.isIPhoneX ? 39 : 0) + 70
        
        if !fromAddress {
            bottomView.updateUI(promoCode, coin: coin)
            bottomH += 50
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomH, right: 0.0)
        */
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10.0),
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension AddressVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTVCell.id, for: indexPath) as! AddressTVCell
        viewModel.addressTVCell(cell, indexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension AddressVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let addr = viewModel.address[indexPath.row]
        
        guard !addr.defaultAddress else {
            return
        }
        
        let alert = UIAlertController(title: "Set to default address".localized(), message: nil, preferredStyle: .alert)
        let okAct = UIAlertAction(title: "OK".localized(), style: .default) { _ in
            let hud = HUD.hud(kWindow)
            
            addr.updateAddress(dict: ["defaultAddress" : true]) {}
            
            if self.viewModel.address.count == 1 {
                hud.removeHUD {}
                self.viewModel.getAddress()
                
            } else {
                //Lọc lấy các address còn lại. Khác với address hiện tại
                let array = self.viewModel.address.filter({ $0.uid != addr.uid && $0.defaultAddress })
                
                //Nếu giá trị nào tồn tại 'true'. Thì đặt thành 'false'
                for i in 0..<array.count {
                    let arr = array[i]
                    
                    if arr.defaultAddress {
                        arr.updateAddress(dict: ["defaultAddress" : false]) {
                            if i == array.count-1 {
                                hud.removeHUD {}
                                self.viewModel.getAddress()
                            }
                        }
                    }
                }
            }
        }
        let cancelAct = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        alert.addAction(okAct)
        alert.addAction(cancelAct)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.address.count != 0 {
            let r = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 60.0)
            let headerView = UIView(frame: r)
            headerView.backgroundColor = UIColor(hex: 0xF6F6F6)
            
            let titleLbl = UILabel(frame: CGRect(x: 20.0, y: 15.0, width: screenWidth-40, height: 30.0))
            titleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
            titleLbl.textColor = .darkGray
            headerView.addSubview(titleLbl)
            
            let txt: String
            if fromAddress {
                txt = "Address".uppercased().localized()
                
            } else {
                txt = "Shipping to address".uppercased().localized()
            }
            
            titleLbl.text = txt
            
            return headerView
        }
        
        return nil
    }
}

//MARK: - ButtonAnimationDelegate

extension AddressVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Add New Address
            
            //Nếu ko tồn tại 1 địa chỉ. Hoặc thêm mới khi đi từ Address
            if fromAddress || (!fromAddress && viewModel.address.count == 0) {
                let vc = AddNewAddressVC()
                vc.currentUser = currentUser
                vc.delegate = self
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
                return
            }
            
            //Tiến hành thanh toán
            if let address = viewModel.address.first(where: { $0.defaultAddress }) {
                let vc = CheckoutVC()
                vc.promoCode = promoCode
                vc.coin = coin
                vc.address = address
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                
            } else {
                //Nếu ko có địa chỉ mặc định
                showAlert(title: "Please choose an address".localized(), mes: nil) {}
            }
        }
    }
}

//MARK: - AddressTVCellDelegate

extension AddressVC: AddressTVCellDelegate {
    
    func delDidTap(cell: AddressTVCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let addr = viewModel.address[indexPath.row]
            
            if addr.defaultAddress {
                showAlert(title: "Oops".localized() + " !!!", mes: "You can't delete the default address") {}
                
            } else {
                let alert = UIAlertController(title: "Are you sure you want delete this address?".localized(), message: "You cannot undo this action".localized(), preferredStyle: .alert)
                let okAct = UIAlertAction(title: "Delete".localized(), style: .destructive) { _ in
                    let addr = self.viewModel.address.remove(at: indexPath.row)
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                    self.tableView.endUpdates()
                    
                    addr.deleteAddress {
                        self.viewModel.getAddress()
                    }
                }
                let cancelAct = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                
                alert.addAction(okAct)
                alert.addAction(cancelAct)
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func editDidTap(cell: AddressTVCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let vc = AddNewAddressVC()
            vc.currentUser = currentUser
            vc.address = viewModel.address[indexPath.row]
            vc.delegate = self
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - AddNewAddressVCDelegate

extension AddressVC: AddNewAddressVCDelegate {
    
    func addNewAddressDidTap(_ vc: AddNewAddressVC) {
        print("addNewAddressDidTap")
        vc.navigationController?.popViewController(animated: true)
        viewModel.getAddress()
    }
}
