//
//  ProductVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/04/2022.
//

import UIKit

class ProductVC: UIViewController {
    
    //MARK: - Properties
    let separatorView = UIView()
    private let scrollView = ProductScrollView()
    
    var containerView: ProductContainerView { return scrollView.containerView }
    
    var coverView: ProductCoverImageView { return containerView.coverView }
    var coverCV: UICollectionView { return coverView.collectionView }
    var pageControl: UIPageControl { return coverView.pageControl }
    
    var titleView: ProductTitleView { return containerView.titleView }
    
    var sizeView: ProductSizeView { return containerView.sizeView }
    var sizeCV: UICollectionView { return sizeView.collectionView }
    
    var colorView: ProductColorView { return containerView.colorView }
    var colorCV: UICollectionView { return colorView.collectionView }
    
    var desView: ProductDescriptionView { return containerView.desView }
    var reviewsView: ProductReviewsView { return containerView.reviewsView }
    
    var relatedView: ProductRelatedView { return containerView.relatedView }
    var relatedCV: UICollectionView { return relatedView.collectionView }
    
    let naviView = ProductNaviView()
    let bottomView = ProductBottomView()
    let notifView = NotifView()
    
    private var isShowDes = false //Hiện-Ẩn Description
    
    var product: Product!
    
    var fromBag = false
    var selectedSize: String? //Chọn 'Size'
    var selectedColor: MoreColor? //Chọn 'Color'
    
    private var bagObs: Any?
    
    private var shareVC: ShareVC?
    private var viewModel: ProductViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        saveCoreData()
        addObserver()
        
        viewModel.getShoppingCart()
        viewModel.wishlistUI()
        viewModel.getReview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        naviView.setupHiddenBtn()
        
        guard let _ = product else {
            return
        }
        
        viewModel.updateUI(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            removeObserverBy(observer: bagObs)
        }
    }
}

//MARK: - Setups

extension ProductVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        viewModel = ProductViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self)
        scrollView.contentInset.bottom = (appDL.isIPhoneX ? 39 : 0) + 70
        
        coverView.setupDataSourceAndDelegate(dl: self)
        sizeView.setupDataSourceAndDelegate(dl: self)
        colorView.setupDataSourceAndDelegate(dl: self)
        relatedView.setupDataSourceAndDelegate(dl: self)
        
        //TODO: - NaviView
        setupNavi()
        
        //TODO: - BottomView
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(bottomView.addView)
        bottomView.setupAddView()
        
        bottomView.setupAddBtn()
        bottomView.addBtn.delegate = self
        bottomView.addBtn.tag = 3
        
        bottomView.plusBtn.delegate = self
        bottomView.minusBtn.delegate = self
        
        //TODO: - NotifView
        notifView.setupViews(view)
    }
    
    private func saveCoreData() {
        //Save to CoreData
        if let product = product {
            CoreDataStack.fetchRecentlyViewed { recentlyViewed in
                var id = UUID().uuidString
                
                if let recently = recentlyViewed.first(where: {
                    $0.productID == product.productID && $0.category == product.category
                }) {
                    id = recently.id
                }
                
                CoreDataStack.updateProductIDRecentlyViewed(with: product, id: id)
            }
        }
    }
}

// MARK: - SetupNavi

extension ProductVC {
    
    private func setupNavi() {
        naviView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: statusH+44)
        view.addSubview(naviView)
        
        naviView.backBtn.delegate = self
        naviView.backBtn.tag = 0
        
        naviView.heartBtn.delegate = self
        naviView.heartBtn.tag = 1
        
        naviView.bagBtn.delegate = self
        naviView.bagBtn.tag = 2
        
        naviView.shareBtn.delegate = self
        naviView.shareBtn.tag = 6
        
        naviView.chatBtn.delegate = self
        naviView.chatBtn.tag = 7
        
        desView.titleView.delegate = self
        desView.titleView.tag = 0
        
        reviewsView.delegate = self
        reviewsView.tag = 1
        
        naviView.updateBadge(appDL.badge)
    }
}

// MARK: - AddObserver

extension ProductVC {
    
    private func addObserver() {
        bagObs = NotificationCenter.default.addObserver(forName: .bagKey, object: nil, queue: nil) { _ in
            self.viewModel.getShoppingCart()
            
            if !self.viewModel.isAnimating {
                self.naviView.updateBadge(appDL.badge)
            }
        }
    }
}

// MARK: - ButtonAnimationDelegate

extension ProductVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
            
        } else if sender.tag == 1 { //Heart
            if !User.logged() {
                goToWelcomeVC(self)
                
            } else {
                guard isInternetAvailable() else {
                    return
                }
                
                viewModel.isFavorite = !viewModel.isFavorite
                naviView.updateHeartBtn(viewModel.isFavorite)
                
                naviView.heartBtn.isUserInteractionEnabled = false
                viewModel.saveWishlist()
            }
            
        } else if sender.tag == 2 { //Bag
            if fromBag {
                navigationController?.popViewController(animated: true)
                
            } else {
                tabBarController?.selectedIndex = 2
            }
            
        } else if sender.tag == 3 { //Add to Cart
            if !User.logged() {
                goToWelcomeVC(self)
                
            } else {
                guard isInternetAvailable() else {
                    return
                }
                
                bottomView.addBtn.isUserInteractionEnabled = false
                viewModel.animateBagView()
                viewModel.saveShoppingCart()
            }
            
        } else if sender.tag == 4 { //Plus
            if !User.logged() {
                goToWelcomeVC(self)
                
            } else {
                guard isInternetAvailable() else {
                    return
                }
                
                if let shopping = viewModel.shoppingCart {
                    bottomView.plusBtn.isUserInteractionEnabled = false
                    
                    shopping.updateQuantity {
                        self.bottomView.plusBtn.isUserInteractionEnabled = true
                    }
                    
                } else {
                    if let product = product {
                        print("*** Mặt hàng mới *** ")
                        viewModel.saveNewShoppingCart(product)
                    }
                }
            }
            
        } else if sender.tag == 5 { //Minus
            if !User.logged() {
                goToWelcomeVC(self)
                
            } else {
                guard isInternetAvailable() else {
                    return
                }
                
                if let shopping = viewModel.shoppingCart {
                    bottomView.minusBtn.isUserInteractionEnabled = false
                    
                    //Nếu 2 sản phẩm trở lên thì xóa 1
                    if shopping.quantity > 1 {
                        shopping.updateQuantity(addNum: -1) {
                            self.bottomView.minusBtn.isUserInteractionEnabled = true
                        }
                        
                    } else {
                        //Nếu chỉ 1 sản phẩm thì xóa khỏi giỏ
                        shopping.deleteShoppingCart {
                            self.bottomView.minusBtn.isUserInteractionEnabled = true
                        }
                    }
                }
            }
            
        } else if sender.tag == 6 { //Share
            shareVC?.removeFromParent()
            shareVC = nil
            
            shareVC = ShareVC()
            shareVC!.view.frame = kWindow.bounds
            shareVC!.imgLink = viewModel.imageURLs[pageControl.currentPage]
            shareVC!.titleTxt = product.name
            shareVC!.product = product
            shareVC!.delegate = self
            kWindow.addSubview(shareVC!.view)
            
        } else if sender.tag == 7 { //Chat
            if !User.logged() {
                goToWelcomeVC(self)
                
            } else {
                guard isInternetAvailable() else { return }
                guard !User.isAdmin() else { return }
                guard let selectedColor = selectedColor,
                      selectedColor.color != "",
                      let selectedSize = selectedSize else {
                    return
                }
                
                let vc = ChatVC()
                vc.product = product
                vc.prSize = selectedSize
                vc.prColor = selectedColor.color
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - ViewAnimationDelegate

extension ProductVC: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if sender.tag == 0 { //Description
            isShowDes = !isShowDes
            
            containerView.stackView.setCustomSpacing(isShowDes ? 20 : 0, after: desView)
            desView.hiddenDescription(self, setHidden: isShowDes)
            
        } else if sender.tag == 1 { //Reviews
            let vc = ProductReviewVC()
            
            vc.kTitle = product.name
            vc.reviews = viewModel.reviews
            vc.rating1 = viewModel.rating1
            vc.rating2 = viewModel.rating2
            vc.rating3 = viewModel.rating3
            vc.rating4 = viewModel.rating4
            vc.rating5 = viewModel.rating5
            vc.total = viewModel.total
            vc.avg = viewModel.avg
            vc.ratingImg = viewModel.ratingImg
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coverCV {
            return viewModel.imageURLs.count
            
        } else if collectionView == sizeCV {
            return product.sizes.count
            
        } else if collectionView == colorCV {
            return viewModel.colors.count
            
        } else if collectionView == relatedCV {
            return viewModel.relatedProducts.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == coverCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCoverImageCVCell.id, for: indexPath) as! ProductCoverImageCVCell
            viewModel.coverCell(cell, indexPath: indexPath)
            
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
            pinch.delegate = self
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            pan.delegate = self
            pan.minimumNumberOfTouches = 2
            pan.maximumNumberOfTouches = 2
            
            cell.coverImageView.isUserInteractionEnabled = true
            cell.coverImageView.addGestureRecognizer(pinch)
            cell.coverImageView.addGestureRecognizer(pan)
            
            return cell
            
        } else if collectionView == sizeCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSizeCVCell.id, for: indexPath) as! ProductSizeCVCell
            viewModel.sizeCell(cell, indexPath: indexPath)
            return cell
            
        } else if collectionView == colorCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductColorCVCell.id, for: indexPath) as! ProductColorCVCell
            viewModel.colorCell(cell, indexPath: indexPath)
            return cell
            
        } else if collectionView == relatedCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
            viewModel.relatedCell(cell, indexPath: indexPath)
            return cell
            
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ProductVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coverCV {
            let vc = ViewImageVC()
            
            vc.index = indexPath.item
            vc.imageLinks = viewModel.imageURLs
            vc.modalPresentationStyle = .fullScreen
            
            present(vc, animated: true)
            
        } else if collectionView == sizeCV {
            selectedSize = product.sizes[indexPath.item]
            
            sizeView.reloadData()
            viewModel.wishlistUI()
            
        } else if collectionView == colorCV {
            selectedColor = viewModel.colors[indexPath.item]
            
            colorView.reloadData()
            viewModel.selectColor()
            
        } else if collectionView == relatedCV {
            let product = viewModel.relatedProducts[indexPath.item]
            goToProductVC(viewController: self, product: product)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coverCV {
            return CGSize(width: coverView.itemWidth, height: collectionView.bounds.height)
            
        } else if collectionView == sizeCV {
            var width: CGFloat = 40.0
            
            if selectedSize == "ONE SIZE" {
                width = "ONE SIZE".estimatedTextRect(fontN: FontName.ppSemiBold, fontS: 15).width + 20
            }
            
            return CGSize(width: width, height: 40.0)
            
        } else if collectionView == colorCV {
            return CGSize(width: 40.0, height: 40.0)
            
        } else if collectionView == relatedCV {
            return CGSize(width: relatedView.itemWidth, height: collectionView.bounds.height)
        }
        
        return .zero
    }
}

// MARK: - UIScrollViewDelegate

extension ProductVC: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == coverCV {
            let offsetX = targetContentOffset.pointee.x / screenWidth
            pageControl.currentPage = Int(offsetX)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ProductVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //Zoom
    @objc private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            if sender.scale >= 1.0 {
                let scale = sender.scale
                sender.view!.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
            //0.2s overlay.alpha = 0.8
            
        default:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
                sender.view!.transform = .identity
                
            } completion: { _ in
                //0.2s overlay.alpha = 0.0
            }
        }
    }
    
    //Pan
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        
        switch sender.state {
        case .began, .changed:
            let translation = sender.translation(in: imageView)
            
            sender.view!.center = CGPoint(x: imageView.center.x + translation.x,
                                          y: imageView.center.y + translation.y)
            sender.setTranslation(.zero, in: imageView)
            
            //0.2s overlay.alpha = 0.8
            
        default:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
                sender.view!.center = self.view.center
                sender.setTranslation(.zero, in: self.view)
                
            } completion: { _ in
                //0.2s overlay.alpha = 0.0
            }
        }
    }
}

//MARK: - ShareVCDelegate

extension ProductVC: ShareVCDelegate {
    
    func copyLinkDidTap(_ vc: ShareVC) {
        vc.removeHandler {
            self.notifView.setupNotifView("Copied".localized())
        }
    }
    
    func viaTextDidTap(_ vc: ShareVC, shortLink: String) {
        vc.removeHandler {
            self.shareOnMessages(shortLink)
        }
    }
    
    func viaContactsDidTap(_ vc: ShareVC, shortLink: String) {
        print("viaContactsDidTap")
    }
    
    func moreDidTap(_ vc: ShareVC, shortLink: String) {
        vc.removeHandler {
            self.share(shortLink)
        }
    }
}
