//
//  BagVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit

class BagVC: UIViewController {

    // MARK: - Properties
    private let menuBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    
    let separatorView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let bagCenterView = BagCenterView()
    let bottomView = BagBottomView()
    
    var promoCodeUID = ""
    var promoCode: PromoCode?
    var coin: Double = 0.0 //Trừ số tiền từ coin hiện có. Nếu người dùng sử dụng
    
    private var spacing: CGFloat {
        let tabH = tabBarController?.tabBar.frame.height ?? (appDL.isIPhoneX ? 44+39 : 44)
        let bt: CGFloat = 150 + 110 - tabH + spBottom
        return bt
    }
    
    var bagPromoCodeCVCell: BagPromoCodeCVCell?
    
    private var menuContainerVC: LeftMenuContainerVC?
    private var promoCodeVC: PromoCodeVC?
    
    private var viewModel: BagViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        updateBadge(appDL.badge)
        
        if appDL.shoppings.count == 0 {
            bagCenterView.downloadGIF()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if appDL.shoppings.count == 0 {
            bagCenterView.bagImageView.image = nil
        }
    }
}

// MARK: - Setups

extension BagVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Bag".localized()
        
        viewModel = BagViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: spacing, right: 0.0)
        collectionView.register(BagCVCell.self, forCellWithReuseIdentifier: BagCVCell.id)
        collectionView.register(BagPromoCodeCVCell.self, forCellWithReuseIdentifier: BagPromoCodeCVCell.id)
        view.addSubview(collectionView)
        
        collectionView.setupLayout(scrollDirection: .vertical)
        collectionView.setupConstraint(superView: view)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = appDL.shoppings.count == 0
        
        //TODO: - BagCenterView
        setupCenterView()
        
        if appDL.shoppings.count != 0 {
            bagCenterView.removeFromSuperview()
        }
        
        //TODO: - BottomView
        bottomView.isHidden = appDL.shoppings.count == 0
        view.addSubview(bottomView)
        
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomView.orderBtn.delegate = self
        bottomView.orderBtn.tag = 2
        
        bottomView.updateUI(nil, coin: 0.0)
        bottomView.setupTxtForBtn("Continue".localized())
        bottomView.bottomConstraint.constant = -spBottom
    }
    
    private func setupCenterView() {
        bagCenterView.updateUI(self)
        bagCenterView.addBtn.delegate = self
        bagCenterView.addBtn.tag = 1
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc private func doneDidTap() {
        bagPromoCodeCVCell?.promoCodeTF.resignFirstResponder()
    }
}

// MARK: - NavigationBar

extension BagVC {
    
    private func setupNavi() {
        //TODO: - LeftView
        let leftView = createLeftView(menuBtn)
        menuBtn.delegate = self
        
        //TODO: - RightView
        let rightView = createRightView(bagBtn, badgeLbl)
        
        //TODO: - UINavigationItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    
    func updateBadge(_ badge: Int) {
        let bagImg = UIImage(named: badge == 0 ? "icon-bagRight" : "icon-bagCenter")
        bagBtn.setImage(bagImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        bagBtn.tintColor = defaultColor
        
        badgeLbl.isHidden = badge == 0
        badgeLbl.text = "\(badge)"
    }
}

// MARK: - Add Observer

extension BagVC {
    
    private func addObserver() {
        //Cập nhật Pos cho LeftMenu mỗi khi app hoạt động trong nền
        NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if let vc = self.menuContainerVC {
                vc.centerVC.view.frame.origin.x = vc.xPos
            }
        }
        NotificationCenter.default.addObserver(forName: .bagKey, object: nil, queue: nil) { _ in
            if appDL.shoppings.count != 0 {
                self.bagCenterView.removeFromSuperview()
                
            } else {
                self.setupCenterView()
            }
            
            self.updateBadge(appDL.badge)
            self.reloadData()
            self.bottomView.isHidden = appDL.shoppings.count == 0
            self.collectionView.isHidden = appDL.shoppings.count == 0
            
            self.bottomView.updateUI(self.promoCode, coin: self.coin)
        }
        NotificationCenter.default.addObserver(forName: .signOutKey, object: nil, queue: nil) { _ in
            self.reloadData()
            self.setupCenterView()
            self.bottomView.isHidden = appDL.shoppings.count == 0
            self.collectionView.isHidden = appDL.shoppings.count == 0
        }
        NotificationCenter.default.addObserver(forName: .keyboardWillShow, object: nil, queue: nil) { notif in
            if let height = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
               let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.collectionView.contentInset.bottom = height
                    self.view.layoutIfNeeded()
                }
            }
        }
        NotificationCenter.default.addObserver(forName: .keyboardWillHide, object: nil, queue: nil) { notif in
            if let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.collectionView.contentInset.bottom = self.spacing
                    self.view.layoutIfNeeded()
                }
            }
        }
        NotificationCenter.default.addObserver(forName: .orderCompletedKey, object: nil, queue: nil) { notif in
            let vc = OrderHistoryVC()
            vc.currentUser = appDL.currentUser
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        NotificationCenter.default.addObserver(forName: .placeOrderKey, object: nil, queue: nil) { notif in
            self.setupPromoCodeUID("")
            self.bottomView.updateUI(nil, coin: 0.0)
        }
    }
}

// MARK: - ButtonAnimationDelegate

extension BagVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Menu
            doneDidTap()
            
            removeMenuContainerView(menuContainerVC)
            menuContainerVC = createMenuContainerView(tabBarController, navigationController, self, self)
            
        } else if sender.tag == 1 { //Add Product
            tabBarController?.selectedIndex = 2
            
        } else if sender.tag == 2 { //Continue
            guard let currentUser = appDL.currentUser else {
                return
            }

            let vc = AddressVC()
            vc.currentUser = currentUser
            vc.fromAddress = false
            vc.promoCode = promoCode
            vc.coin = coin
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - MenuContainerVCDelegate

extension BagVC: LeftMenuContainerVCDelegate {
    
    func completionAnim(_ isComplete: Bool) {
        createEffect(isComplete, vc: self, selector: #selector(handlerRemoveMenu))
        
        if !isComplete {
            removeMenuContainerView(menuContainerVC)
        }
    }
    
    @objc private func handlerRemoveMenu() {
        menuContainerVC?.toggleSideMenu()
        removeEffect()
    }
}

//MARK: - SideMenuTVCDelegate

extension BagVC: LeftMenuTVCDelegate {
    
    func categoryDidTap(_ category: String) {
        goToCategoryDetail(viewController: self, category: category)
    }
    
    func aboutUsDidTap() {
        goToAboutUsVC(self)
    }
    
    func informationDidTap() {
        goToInformationVC(self)
    }
    
    func loginDidTap() {
        goToWelcomeVC(self)
    }
}

//MARK: - UICollectionViewDataSource

extension BagVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? appDL.shoppings.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BagCVCell.id, for: indexPath) as! BagCVCell
            viewModel.bagCVCell(cell, indexPath: indexPath)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BagPromoCodeCVCell.id, for: indexPath) as! BagPromoCodeCVCell
            viewModel.bagPromoCodeCVCell(cell, indexPath: indexPath)
            
            cell.promoCodeTF.addDoneBtn(target: self, selector: #selector(doneDidTap))
            cell.promoCodeTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            bagPromoCodeCVCell = cell
            
            return cell
        }
    }
    
    @objc private func editingChanged(_ tf: UITextField) {
        if let text = tf.text,
           !text.trimmingCharacters(in: .whitespaces).isEmpty {
            bagPromoCodeCVCell?.setTxtForBtn("Apply".localized())
            bagPromoCodeCVCell?.removeBtn.isHidden = false
            
        } else {
            bagPromoCodeCVCell?.setTxtForBtn("Choose".localized())
            bagPromoCodeCVCell?.removeBtn.isHidden = true
        }
    }
}

//MARK: - UICollectionViewDelegate

extension BagVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        let shopping = appDL.shoppings[indexPath.item]
        
        if let product = appDL.allProducts.first(where: {
            $0.category == shopping.category &&
            $0.subcategory == shopping.subcategory &&
            $0.productID == shopping.prID
        }) {
            let vc = ProductVC()
            vc.fromBag = true
            vc.product = product
            vc.selectedSize = shopping.size
            vc.selectedColor = MoreColor(productUID: "\(shopping.category)-\(shopping.prID)".uppercased(), color: shopping.color)
            
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension BagVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: screenWidth, height: BagCVCell.coverH + 10)
            
        } else {
            return CGSize(width: screenWidth, height: 60.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
            
        } else {
            return CGSize(width: screenWidth, height: 40.0)
        }
    }
}

//MARK: - BagCVCellDelegate

extension BagVC: BagCVCellDelegate {
    
    func plusDidTap(_ cell: BagCVCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let shopping = appDL.shoppings[indexPath.item]
            cell.plusBtn.isUserInteractionEnabled = false
            
            shopping.updateQuantity {
                cell.plusBtn.isUserInteractionEnabled = true
                self.reloadData()
            }
        }
    }
    
    func minusDidTap(_ cell: BagCVCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let shopping = appDL.shoppings[indexPath.item]
            cell.minusBtn.isUserInteractionEnabled = false
            
            shopping.updateQuantity(addNum: -1) {
                cell.minusBtn.isUserInteractionEnabled = true
                self.reloadData()
            }
        }
    }
    
    func deleteDidTap(_ cell: BagCVCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let alert = UIAlertController(title: "Remove from cart?".localized(), message: "This product will be removed from cart.".localized(), preferredStyle: .alert)
            let removeAct = UIAlertAction(title: "Remove".localized(), style: .destructive) { _ in
                let shopping = appDL.shoppings.remove(at: indexPath.item)
                
                self.collectionView.performBatchUpdates {
                    self.collectionView.deleteItems(at: [indexPath])
                    
                } completion: { _ in
                    shopping.deleteShoppingCart {
                        self.reloadData()
                        
                        if appDL.shoppings.count <= 0 {
                            self.setupCenterView()
                            self.bagCenterView.downloadGIF()
                        }
                    }
                }
            }
            let cancelAct = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            
            alert.addAction(removeAct)
            alert.addAction(cancelAct)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - BagPromoCodeCVCellDelegate

extension BagVC: BagPromoCodeCVCellDelegate {
    
    func choosePromoCodeDidTap(_ cell: BagPromoCodeCVCell) {
        doneDidTap()
        
        if promoCodeUID == "" {
            promoCodeVC?.removeFromParent()
            promoCodeVC = nil
            
            promoCodeVC = PromoCodeVC()
            promoCodeVC?.view.frame = kWindow.bounds
            promoCodeVC?.delegate = self
            promoCodeVC?.promoCode = promoCode
            promoCodeVC?.coin = coin
            kWindow.addSubview(promoCodeVC!.view)
            
        } else {
            viewModel.getPromoCode()
        }
    }
    
    func removePromoCodeDidTap(_ cell: BagPromoCodeCVCell) {
        setupPromoCodeUID("", fromRemove: true)
    }
}

//MARK: - UITextFieldDelegate

extension BagVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneDidTap()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == bagPromoCodeCVCell?.promoCodeTF {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty {
                promoCodeUID = text
                
            } else {
                promoCodeUID = ""
            }
        }
    }
}

//MARK: - PromoCodeVCDelegate

extension BagVC: PromoCodeVCDelegate {
    
    func removePromoCodeDidTap(vc: PromoCodeVC) {
        vc.removeHandler {
            self.promoCode = nil
            self.setupPromoCodeUID("")
            self.bottomView.updateUI(nil, coin: 0.0)
        }
    }
    
    func applyPromoCodeDidSelect(vc: PromoCodeVC, promoCode: PromoCode?, coin: Double) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        vc.removeHandler {
            if let promoCode = promoCode {
                self.promoCode = promoCode
                self.setupPromoCodeUID(promoCode.uid)
            }
            
            self.coin = coin
            self.viewModel.getPromoCode()
        }
    }
    
    private func setupPromoCodeUID(_ code: String, fromRemove: Bool = false) {
        promoCodeUID = code
        
        //Xóa từ popup Promo Code. Ko phải từ xóa tạm trong UITextField
        if !fromRemove {
            coin = code == "" ? 0.0 : coin
            promoCode = code == "" ? nil : promoCode
        }
        
        bagPromoCodeCVCell?.promoCodeTF.text = promoCodeUID
        bagPromoCodeCVCell?.setTxtForBtn(code == "" ? "Choose".localized() : "Apply".localized())
        bagPromoCodeCVCell?.removeBtn.isHidden = code == ""
    }
}
