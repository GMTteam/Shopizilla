//
//  PromoCodeVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 15/06/2022.
//

import UIKit

protocol PromoCodeVCDelegate: AnyObject {
    func removePromoCodeDidTap(vc: PromoCodeVC)
    func applyPromoCodeDidSelect(vc: PromoCodeVC, promoCode: PromoCode?, coin: Double)
}

class PromoCodeVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: PromoCodeVCDelegate?
    
    private let containerView = UIView()
    private let naviView = UIView()
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let removeBtn = ButtonAnimation()
    private let titleLbl = UILabel()
    private let applyBtn = ButtonAnimation()
    
    var coin: Double = 0.0 //Lấy số tiền có từ Coin. 1000c = $1
    var promoCode: PromoCode?
    var hud: HUD?
    
    private var viewModel: PromoCodeViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let height: CGFloat = screenHeight*0.5 + 50
        let kView = UIView(frame: CGRect(x: 0.0, y: screenHeight-height, width: screenWidth, height: height))
        kView.clipsToBounds = true
        kView.backgroundColor = .clear
        kView.tag = 111
        view.addSubview(kView)
        
        hud = HUD.hud(kView)
        
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

//MARK: - Setups

extension PromoCodeVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        viewModel = PromoCodeViewModel(vc: self)
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        //TODO: - NaviView
        naviView.frame = CGRect(x: 0.0, y: screenHeight*0.5-1-50, width: screenWidth, height: 50.0)
        naviView.backgroundColor = .white
        naviView.clipsToBounds = true
        view.addSubview(naviView)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        titleLbl.textAlignment = .center
        titleLbl.textColor = .black
        titleLbl.text = "Promo Code".localized()
        naviView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: naviView.centerXAnchor).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: naviView.centerYAnchor).isActive = true
        
        //TODO: - RemoveBtn
        setupBtnForNaviView(removeBtn, tag: 1, txt: "Remove".localized())
        removeBtn.leadingAnchor.constraint(equalTo: naviView.leadingAnchor, constant: 20.0).isActive = true
        
        //TODO: - ApplyBtn
        setupBtnForNaviView(applyBtn, tag: 2, txt: "Apply".localized())
        applyBtn.trailingAnchor.constraint(equalTo: naviView.trailingAnchor, constant: -20.0).isActive = true
        
        applyBtn.isUserInteractionEnabled = false
        applyBtn.alpha = 0.4
        
        //TODO: - SeparatorView
        separatorView.frame = CGRect(x: 0.0, y: screenHeight*0.5-1, width: screenWidth, height: 1.0)
        separatorView.backgroundColor = UIColor(hex: 0xF6F6F6)
        separatorView.clipsToBounds = true
        view.addSubview(separatorView)
        
        //TODO: - TableView
        tableView.frame = CGRect(x: 0.0, y: screenHeight*0.5, width: screenWidth, height: screenHeight*0.5)
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset.top = 20.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = (screenWidth-40) * (300/748) + 20
        tableView.register(CoinTVCell.self, forCellReuseIdentifier: CoinTVCell.id)
        tableView.register(PromoCodeTVCell.self, forCellReuseIdentifier: PromoCodeTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        tap.numberOfTouchesRequired = 1
        containerView.addGestureRecognizer(tap)
        
        setupAnim()
    }
    
    private func setupBtnForNaviView(_ btn: ButtonAnimation, tag: Int, txt: String) {
        let attr = createMutableAttributedString(fgColor: .black, txt: txt)
        btn.setAttributedTitle(attr, for: .normal)
        btn.tag = tag
        btn.delegate = self
        btn.clipsToBounds = true
        naviView.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor).isActive = true
    }
    
    private func setupAnim() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        naviView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        separatorView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        tableView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.naviView.transform = .identity
            self.separatorView.transform = .identity
            self.tableView.transform = .identity
        }
    }
    
    @objc private func removeDidTap() {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.naviView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            self.separatorView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            self.tableView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension PromoCodeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let user = appDL.currentUser {
                return user.coin == 0 ? 0 : 1
            }
            
            return 0
            
        } else {
            return viewModel.promoCodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CoinTVCell.id, for: indexPath) as! CoinTVCell
            viewModel.coinTVCell(cell, indexPath: indexPath)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PromoCodeTVCell.id, for: indexPath) as! PromoCodeTVCell
            viewModel.promoCodeTVCell(cell, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension PromoCodeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if let user = appDL.currentUser {
                if let cell = tableView.cellForRow(at: indexPath) as? CoinTVCell {
                    cell.isSelect = !cell.isSelect
                    coin = cell.isSelect ? user.coin : 0.0
                    reloadData()
                }
                
                let isBool = coin != 0.0 || promoCode != nil
                applyBtn.isUserInteractionEnabled = isBool
                applyBtn.alpha = isBool ? 1.0 : 0.4
            }
            
        } else {
            let promoCode = viewModel.promoCodes[indexPath.row]
            
            guard let startDate = longFormatter().date(from: promoCode.startDate),
                  let endDate = longFormatter().date(from: promoCode.endDate),
                  let user = appDL.currentUser else {
                return
            }

            //Nếu PromoCode còn hạn và currentUser chưa sử dụng mã này
            let enable = (startDate...endDate).contains(viewModel.today) && !promoCode.userUIDs.contains(user.uid)
            guard enable else { return }
            
            self.promoCode = promoCode
            self.reloadData()
            
            self.applyBtn.isUserInteractionEnabled = self.promoCode != nil
            self.applyBtn.alpha = self.promoCode != nil ? 1.0 : 0.4
        }
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

//MARK: - ButtonAnimationDelegate

extension PromoCodeVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Remove
            coin = 0.0
            promoCode = nil
            reloadData()
            
            delegate?.removePromoCodeDidTap(vc: self)
            
        } else if sender.tag == 2 { //Apply
            delegate?.applyPromoCodeDidSelect(vc: self, promoCode: promoCode, coin: coin)
        }
    }
}
