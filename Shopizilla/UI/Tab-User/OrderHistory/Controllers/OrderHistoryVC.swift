//
//  OrderHistoryVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 03/05/2022.
//

import UIKit

class OrderHistoryVC: UIViewController {
    
    //MARK: - Properties
    let centerView = OrderHistoryCenterView()
    
    let topView = OrderHistoryTopView()
    var topCV: UICollectionView { return topView.collectionView }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let ref = UIRefreshControl()
    let layout = OrderHistoryLayout()
    
    var currentUser: User!
    var hud: HUD?
    var isFirstLoad = true
    
    lazy var models: [StatusModel] = {
        return StatusModel.shared()
    }()
    var selectedStatus: StatusModel?
    
    private var shoppingCartObs: Any?
    private var viewModel: OrderHistoryViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
        
        viewModel.getData()
        
        if selectedStatus == nil {
            selectedStatus = models.first(where: { $0.index == 0 })
        }
        
        if let index = models.firstIndex(where: { $0.index == selectedStatus?.index }) {
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: index, section: 0)
                self.topCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && isFirstLoad {
            isFirstLoad = false
            hud = HUD.hud(view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            removeObserverBy(observer: shoppingCartObs)
        }
    }
}

//MARK: - Setups

extension OrderHistoryVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Order History".localized()
        
        viewModel = OrderHistoryViewModel(vc: self)
        
        //TODO: - CenterView
        view.addSubview(centerView)
        
        centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //TODO: - TopView
        view.addSubview(topView)
        
        topView.setupDataSourceAndDelegate(dl: self)
        topView.layout.delegate = self
        
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.register(OrderHistoryCVCell.self, forCellWithReuseIdentifier: OrderHistoryCVCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        //TODO: - Layout
        layout.scrollDirection = .vertical
        layout.contentPadding = SpacingMode(horizontal: 0.0, vertical: 0.0)
        layout.cellPadding = 0.0
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        //TODO: - NSLayoutConstraint
        collectionView.setupConstraint(superView: view, subview: topView, topC: 10.0, bottomC: -30.0)
        
        collectionView.refreshControl = ref
        ref.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc private func refreshHandler() {
        ref.beginRefreshing()
        viewModel.getData()
        
        delay(duration: 1.0) {
            self.ref.endRefreshing()
        }
    }
}

//MARK: - Add Observer

extension OrderHistoryVC {
    
    private func addObserver() {
        shoppingCartObs = NotificationCenter.default.addObserver(forName: .shoppingCartKey, object: nil, queue: nil) { _ in
            //Cho Admin
            if User.isAdmin() {
                self.viewModel.updateData(appDL.allShoppingCarts)
                
            } else {
                self.viewModel.getData()
                self.topView.reloadData()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension OrderHistoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCV {
            return models.count
            
        } else {
            return viewModel.shoppingStatus.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderHistoryTopCVCell.id, for: indexPath) as! OrderHistoryTopCVCell
            viewModel.orderHistoryTopCVCell(cell: cell, indexPath: indexPath)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderHistoryCVCell.id, for: indexPath) as! OrderHistoryCVCell
            viewModel.orderHistoryCVCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension OrderHistoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCV {
            selectedStatus = models[indexPath.item]
            
            DispatchQueue.main.async {
                self.topCV.reloadData()
                self.topCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
            viewModel.loadDataBy()
            
        } else {
            let vc = MyOrderVC()
            vc.shoppingStatus = viewModel.shoppingStatus[indexPath.item]
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if let cell = cell as? OrderHistoryCVCell, viewModel.shoppingStatus.count != 0 {
                var count = viewModel.shoppingStatus[indexPath.item].shoppings.count
                count = count >= 2 ? 2 : count
                
                let height = OrderHistoryCVCell.centerH * CGFloat(count)
                
                cell.centerHConstraint.constant = height
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension OrderHistoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCV {
            return CGSize(width: 150.0, height: 50.0)
            
        } else {
            let sp: CGFloat = 10*2
            let top: CGFloat = OrderHistoryCVCell.topH
            let bottom: CGFloat = OrderHistoryCVCell.bottomH
            let itemH = OrderHistoryCVCell.centerH
            return CGSize(width: screenWidth, height: itemH + top + bottom + sp)
        }
    }
}

//MARK: - CustomLayoutDelegate

extension OrderHistoryVC: CustomLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath, cv: UICollectionView) -> CGSize {
        if cv == topCV {
            let model = models[indexPath.item]
            let width = model.title.estimatedTextRect(fontN: FontName.ppMedium, fontS: 16).width
            return CGSize(width: width + 40, height: 50)
            
        } else {
            let sp: CGFloat = 10*2
            let top: CGFloat = OrderHistoryCVCell.topH
            let bottom: CGFloat = OrderHistoryCVCell.bottomH
            let itemH = OrderHistoryCVCell.centerH
            
            guard viewModel.shoppingStatus.count != 0 else {
                return CGSize(width: screenWidth, height: itemH + top + bottom + sp)
            }
            
            var count = viewModel.shoppingStatus[indexPath.item].shoppings.count
            count = count >= 2 ? 2 : count
            
            let height = itemH * CGFloat(count)
            
            return CGSize(width: screenWidth, height: height + top + bottom + sp)
        }
    }
}

//MARK: - UIScrollViewDelegate

extension OrderHistoryVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let diffH = scrollView.contentSize.height - scrollView.contentOffset.y
            let pull = abs(diffH - scrollView.bounds.height)
            
            if Int(pull) <= 0 {}
        }
    }
}

//MARK: - OrderHistoryCVCellDelegate

extension OrderHistoryVC: OrderHistoryCVCellDelegate {
    
    func cancelDidTap(_ cell: OrderHistoryCVCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let shop = viewModel.shoppingStatus.remove(at: indexPath.item)
            let key = PushNotification.NotifKey.OrderUpdates.rawValue
            let pushShared = PushNotification.shared
            
            if let index = viewModel.allShoppingStatus.firstIndex(where: {
                $0.orderID == shop.orderID
            }) {
                viewModel.allShoppingStatus.remove(at: index)
            }
            
            collectionView.performBatchUpdates {
                collectionView.deleteItems(at: [indexPath])
                
            } completion: { _ in
                if let selectedStatus = self.selectedStatus {
                    switch selectedStatus.index {
                    case 0: //Order Placed
                        for i in 0..<shop.shoppings.count {
                            var dict: [String: Any] = [:]

                            //Khi Admin xác nhận đơn hàng
                            if User.isAdmin() {
                                dict["status"] = "2"
                                dict["onGoingDate"] = longFormatter().string(from: Date())

                            } else {
                                //Khi User hủy đơn hàng
                                dict["status"] = "4"
                                dict["cancelledDate"] = longFormatter().string(from: Date())
                            }

                            let shopping = shop.shoppings[i]
                            shopping.updateShoppingCart(dict: dict) {
                                if i == shop.shoppings.count-1 {
                                    self.viewModel.getData()
                                }
                            }
                        }

                        if User.isAdmin() {
                            let title = "On Going".localized()
                            let body = "Your order has been confirmed by ShopiZilla".localized()
                            let imageURL = shop.shoppings.first?.imageURL ?? ""

                            //Đẩy thông báo
                            pushShared.sendPushNotifToChat(toUID: shop.userID + "-" + key,
                                                           title: title,
                                                           body: body,
                                                           imageLink: imageURL,
                                                           notifUID: shop.orderID,
                                                           type: key)
                        }
                        
                    case 1: //On Going
                        if User.isAdmin() {
                            //Khi đơn hàng đã giao thành công
                            for i in 0..<shop.shoppings.count {
                                let dict: [String: Any] = [
                                    "status": "3",
                                    "isPaid": true,
                                    "deliveredDate": longFormatter().string(from: Date())
                                ]

                                let shopping = shop.shoppings[i]
                                shopping.updateShoppingCart(dict: dict) {
                                    if i == shop.shoppings.count-1 {
                                        self.viewModel.getData()
                                    }
                                }
                            }
                            
                            let title = "Delivered".localized()
                            let body = "The order has been successfully delivered. How do you see this product? Please rate it,...".localized()
                            let imageURL = shop.shoppings.first?.imageURL ?? ""
                            
                            //Đẩy thông báo
                            pushShared.sendPushNotifToChat(toUID: shop.userID + "-" + key,
                                                           title: title,
                                                           body: body,
                                                           imageLink: imageURL,
                                                           notifUID: shop.orderID,
                                                           type: key)
                        }
                        
                    case 2: break //Delivered
                    case 3: break //Cancelled
                    default: break
                    }
                }
            }
        }
    }
}
