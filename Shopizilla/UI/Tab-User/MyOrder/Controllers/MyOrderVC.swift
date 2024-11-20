//
//  MyOrderVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 03/05/2022.
//

import UIKit

class MyOrderVC: UIViewController {
    
    //MARK: - Properties
    let separatorView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var shoppingStatus: ShoppingStatus?
    var hud: HUD?
    
    private var selectRateVC: SelectRateVC?
    private var notifView: UIView?
    private var viewModel: MyOrderViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.getAddress()
        viewModel.getReview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.address == nil {
            hud = HUD.hud(view)
        }
    }
}

//MARK: - Setups

extension MyOrderVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "My Order".localized()
        
        viewModel = MyOrderViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 30.0, right: 0.0)
        collectionView.register(BagCVCell.self, forCellWithReuseIdentifier: BagCVCell.id)
        collectionView.register(MyOrderSubCVCell.self, forCellWithReuseIdentifier: MyOrderSubCVCell.id)
        collectionView.register(MyOrderInfoCVCell.self, forCellWithReuseIdentifier: MyOrderInfoCVCell.id)
        collectionView.isHidden = true
        view.addSubview(collectionView)
        
        collectionView.setupLayout(scrollDirection: .vertical)
        collectionView.setupConstraint(superView: view, subview: separatorView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MyOrderVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if let shoppingStatus = shoppingStatus {
                return shoppingStatus.shoppings.count
            }
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderInfoCVCell.id, for: indexPath) as! MyOrderInfoCVCell
            viewModel.myOrderInfoCVCell(cell, indexPath: indexPath)
            return cell

        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BagCVCell.id, for: indexPath) as! BagCVCell
            viewModel.bagCVCell(cell, indexPath: indexPath)
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrderSubCVCell.id, for: indexPath) as! MyOrderSubCVCell
            viewModel.myOrderSubCVCell(cell, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension MyOrderVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = AddNewAddressVC()
            vc.currentUser = appDL.currentUser
            vc.address = viewModel.address
            vc.isEdit = false
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.section == 1 {
            guard let shoppingStatus = shoppingStatus else {
                return
            }
            let shopping = shoppingStatus.shoppings[indexPath.item]
            
            if let product = appDL.allProducts.first(where: {
                $0.category == shopping.category &&
                $0.subcategory == shopping.subcategory &&
                $0.productID == shopping.prID
            }) {
                let vc = ProductVC()
                vc.product = product
                vc.selectedSize = shopping.size
                vc.selectedColor = MoreColor(productUID: "\(shopping.category)-\(shopping.prID)".uppercased(), color: shopping.color)
                
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyOrderVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let txt = "Mjg".estimatedTextRect(fontN: FontName.ppMedium, fontS: 16).height
            let height = 10 + 100 + 20 + txt*5 + 10
            
            return CGSize(width: screenWidth, height: height)
            
        } else if indexPath.section == 1 {
            return CGSize(width: screenWidth, height: BagCVCell.coverH + 10)

        } else {
            return CGSize(width: screenWidth, height: 300.0)
        }
    }
}

//MARK: - MyOrderSubCVCellDelegate

extension MyOrderVC: MyOrderSubCVCellDelegate {
    
    func rateDidTap(_ cell: MyOrderSubCVCell) {
        guard let shoppingStatus = shoppingStatus else {
            return
        }
        
        //Nếu chỉ có 1 sản phẩm trong đơn hàng
        if shoppingStatus.shoppings.count == 1 {
            goToRateProductVC(shoppingStatus.shoppings.first)
            
        } else {
            //Nếu chỉ có nhiều sản phẩm trong đơn hàng
            let shoppings: [ShoppingCart]
            if viewModel.reviews.count == 0 {
                shoppings = shoppingStatus.shoppings
                
            } else {
                //Lọc lấy các prUID từ ReviewStar thông qua orderID
                let reviewIDs = viewModel.reviews.map({ $0.productUID })
                
                //Nếu prUID nào chưa Review thì...
                shoppings = shoppingStatus.shoppings.filter({
                    !reviewIDs.contains("\($0.category)-\($0.prID)".uppercased())
                })
            }
            
            //Nếu chỉ 1 sản phẩm. Thì đi thẳng đến đánh giá
            if shoppings.count == 1 {
                goToRateProductVC(shoppings.first)
                
            } else {
                //Nếu có 2 sản phẩm. Thì lựa chọn đánh giá cái nào
                selectRateVC?.removeFromParent()
                selectRateVC = nil
                
                selectRateVC = SelectRateVC()
                selectRateVC?.view.bounds = kWindow.bounds
                
                selectRateVC?.shoppings = shoppings
                selectRateVC?.delegate = self
                
                kWindow.addSubview(selectRateVC!.view)
            }
        }
    }
    
    private func goToRateProductVC(_ shopping: ShoppingCart?) {
        let vc = RateProductVC()
        vc.shopping = shopping
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - MyOrderInfoCVCellDelegate

extension MyOrderVC: MyOrderInfoCVCellDelegate {
    
    func orderNumberDidTap(_ cell: MyOrderInfoCVCell) {
        UIPasteboard.general.string = cell.orderNumberLbl.text
        
        guard notifView == nil else {
            return
        }
        
        notifView?.removeFromSuperview()
        notifView = nil
        
        notifView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0))
        notifView?.clipsToBounds = true
        notifView?.backgroundColor = .white
        view.addSubview(notifView!)
        
        let lbl = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0))
        lbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        lbl.text = "Copied".localized()
        lbl.textAlignment = .center
        lbl.textColor = .black
        notifView!.addSubview(lbl)
        
        notifView?.alpha = 0.0
        lbl.alpha = 0.0
        
        setupShadow(notifView!)
        
        UIView.animate(withDuration: 0.5) {
            self.notifView?.alpha = 1.0
            lbl.alpha = 1.0
            
        } completion: { _ in
            delay(duration: 0.5) {
                UIView.animate(withDuration: 0.5) {
                    self.notifView?.alpha = 0.0
                    lbl.alpha = 0.0
                    
                } completion: { _ in
                    self.notifView?.removeFromSuperview()
                    self.notifView = nil
                }
            }
        }
    }
}

//MARK: - RateProductVCDelegate

extension MyOrderVC: RateProductVCDelegate {
    
    func rateDidTap(vc: RateProductVC) {
        vc.navigationController?.popViewController(animated: true)
        viewModel.getReview()
    }
}

//MARK: - SelectRateVCDelegate

extension MyOrderVC: SelectRateVCDelegate {
    
    func selectRate(_ vc: SelectRateVC, shopping: ShoppingCart) {
        vc.removeHandler {
            self.goToRateProductVC(shopping)
        }
    }
}
