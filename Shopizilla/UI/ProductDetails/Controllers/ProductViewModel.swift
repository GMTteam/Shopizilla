//
//  ProductViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 24/04/2022.
//

import UIKit

class ProductViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: ProductVC
    
    lazy var imageURLs: [String] = [] //Hình ảnh của sản phẩm
    lazy var relatedProducts: [Product] = [] //Sản phẩm liên quan
    
    var shoppingCart: ShoppingCart? //Lưu mới hoặc cập nhật
    var wishlist: Wishlist? //Lưu mới hoặc cập nhật
    
    lazy var colors: [MoreColor] = [] //Sản phẩm này có bao nhiêu màu
    lazy var reviews: [Review] = [] //Sản phẩm này có đánh giá chưa
    
    var isFavorite = false
    var isAnimating = false //Đang xử lý hoạt ảnh
    
    var rating1 = 0
    var rating2 = 0
    var rating3 = 0
    var rating4 = 0
    var rating5 = 0
    var total = 0
    var avg: Double = 0.0
    var ratingImg: UIImage?
    
    //MARK: - Initializes
    init(vc: ProductVC) {
        self.vc = vc
    }
}

//MARK: - Get Attributes

extension ProductViewModel {
    
    func updateUI(_ isScroll: Bool) {
        //CoverImage
        imageURLs = vc.product.imageURLs
        DownloadImage.shared.batchDownloadImages(links: imageURLs)
        
        vc.coverView.updateHeight(vc, product: vc.product)
        vc.coverView.reloadData()
        
        if isScroll {
            DispatchQueue.main.async {
                self.vc.coverCV.reloadData()
                
                let indexPath = IndexPath(item: 0, section: 0)
                self.vc.coverCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                
                self.vc.coverView.pageControl.numberOfPages = self.imageURLs.count
                self.vc.coverView.pageControl.currentPage = 0
            }
        }
        
        //PageControl
        vc.pageControl.numberOfPages = vc.product.imageURLs.count
        
        //Title
        vc.titleView.updateHeight(vc, product: vc.product)
        
        //Size
        if vc.selectedSize == nil {
            vc.selectedSize = vc.product.sizes.first
            
        } else {
            if !vc.product.sizes.contains(vc.selectedSize!) {
                vc.selectedSize = vc.product.sizes.first
            }
        }
        
        vc.sizeView.updateHeight(vc, product: vc.product)
        vc.sizeView.reloadData()
        
        //Color
        var moreColorPrs = appDL.allProducts.filter({
            vc.product.moreColors.contains($0.uid)
        })
        moreColorPrs.insert(vc.product, at: 0)
        
        colors = moreColorPrs.map({
            MoreColor(productUID: $0.uid, color: $0.color)
        })
        
        if vc.selectedColor == nil {
            vc.selectedColor = colors.first
        }
        
        vc.colorView.updateHeight(vc, color: vc.selectedColor?.color ?? "")
        vc.colorView.reloadData()
        
        //Description
        vc.desView.updateHeight(vc, product: vc.product)
        
        //Related Products
        relatedProducts = appDL.allProducts.filter({
            vc.product.relatedIDs.contains($0.productID) &&
            $0.productID != vc.product.productID
        })
        
        vc.relatedView.updateHeight(vc, count: relatedProducts.count)
        vc.relatedView.reloadData()
        
        //UpdateUI
        vc.containerView.updateHeight(vc)
        
        //BottomView
        vc.bottomView.setupHidden(false)
        vc.bottomView.updatePrice(vc.product)
    }
}

//MARK: - SelectColor

extension ProductViewModel {
    
    func selectColor() {
        guard let selectedColor = vc.selectedColor else {
            return
        }
        
        if let pr = appDL.allProducts.first(where: { $0.uid == selectedColor.productUID }) {
            vc.product = pr
        }
        
        updateUI(true)
    }
}

//MARK: - Wishlist

extension ProductViewModel {
    
    func wishlistUI() {
        getWishlist {
            self.isFavorite = self.wishlist != nil
            self.vc.naviView.updateHeartBtn(self.isFavorite)
        }
    }
    
    func getWishlist(completion: @escaping () -> Void) {
        if let product = vc.product,
           let selectedColor = vc.selectedColor,
           let selectedSize = vc.selectedSize,
           selectedColor.color != ""
        {
            Wishlist.fetchWishlistBy(product: product, color: selectedColor.color, size: selectedSize) { wishlist in
                self.wishlist = wishlist
                completion()
            }
        }
    }
    
    func saveWishlist() {
        getWishlist {
            if let wishlist = self.wishlist {
                print("*** Xóa Wishlist ***")
                wishlist.deleteWishlist {
                    self.vc.naviView.heartBtn.isUserInteractionEnabled = true
                }
                
            } else {
                guard let selectedColor = self.vc.selectedColor,
                      selectedColor.color != "",
                      let selectedSize = self.vc.selectedSize else {
                    return
                }
                
                print("*** Thêm Wishlist *** ")
                let model = WishlistModel(category: self.vc.product.category,
                                          subcategory: self.vc.product.subcategory,
                                          prID: self.vc.product.productID,
                                          color: selectedColor.color,
                                          size: selectedSize)
                self.wishlist = Wishlist(model: model)
                
                self.wishlist?.saveWishlist {
                    self.vc.naviView.heartBtn.isUserInteractionEnabled = true
                }
            }
        }
    }
}

//MARK: - Review

extension ProductViewModel {
    
    func getReview() {
        if let product = vc.product {
            Review.fetchReviews(product: product) { reviews in
                self.reviews = reviews
                
                self.rating1 = reviews.filter({ $0.rating == 1 }).count
                self.rating2 = reviews.filter({ $0.rating == 2 }).count
                self.rating3 = reviews.filter({ $0.rating == 3 }).count
                self.rating4 = reviews.filter({ $0.rating == 4 }).count
                self.rating5 = reviews.filter({ $0.rating == 5 }).count
                
                self.total = reviews.count
                let sum = Double([self.rating1*1,
                                  self.rating2*2,
                                  self.rating3*3,
                                  self.rating4*4,
                                  self.rating5*5].reduce(0, +))
                self.avg = self.total != 0 ? sum/Double(self.total) : 0
                
                if !self.avg.isNaN {
                    let i = Int(self.avg)
                    let j = round((self.avg - Double(i))*10)/10
                    let k: Double
                    
                    if j < 0.5 {
                        k = Double(i)
                        
                    } else if j == 0.5 {
                        k = self.avg
                        
                    } else {
                        k = Double(i) + 1
                    }
                    
                    self.ratingImg = UIImage(named: "icon-rating\(k)")
                    self.vc.reviewsView.updateUI(vc: self.vc, setHidden: self.reviews.count == 0, img: self.ratingImg, avgTxt: kText(Double(self.total)))
                }
            }
        }
    }
}

//MARK: - Get ShoppingCart

extension ProductViewModel {
    
    func getShoppingCart() {
        guard let product = vc.product else {
            return
        }
        
        shoppingCart = appDL.shoppings.filter({
            $0.category == product.category &&
            $0.subcategory == product.subcategory &&
            $0.prID == product.productID &&
            $0.price == product.price &&
            $0.saleOff == product.saleOff &&
            $0.status == "0"
        }).first
        
        let quantity = shoppingCart?.quantity ?? 0
        vc.bottomView.numLbl.text = "\(quantity)"
    }
}

//MARK: - Save ShoppingCart

extension ProductViewModel {
    
    func saveShoppingCart() {
        guard let product = vc.product else {
            return
        }
        
        //Update
        if let shoppingCart = shoppingCart {
            //Nếu giá ko đổi
            //Lần mua này có giảm giá ko
            //Nếu ko. Chỉ cần cập nhật vào đơn hàng
            if shoppingCart.price == product.price &&
                shoppingCart.saleOff == product.saleOff &&
                shoppingCart.color == vc.selectedColor?.color &&
                shoppingCart.size == vc.selectedSize
            {
                print("*** Cập nhật đơn hàng ***")
                shoppingCart.updateQuantity {
                    self.vc.bottomView.addBtn.isUserInteractionEnabled = true
                }
                
            } else {
                print("*** Nếu có giảm giá || Giá đã đổi || Size khác ***")
                saveNewShoppingCart(product)
            }

        } else { //New
            print("*** Mặt hàng mới *** ")
            saveNewShoppingCart(product)
        }
    }
    
    func saveNewShoppingCart(_ product: Product) {
        guard let selectedColor = vc.selectedColor, selectedColor.color != "",
              let selectedSize = vc.selectedSize else {
            return
        }
        
        let model = ShoppingCartModel(color: selectedColor.color, size: selectedSize, status: "0")
        shoppingCart = ShoppingCart(model: model)
        
        shoppingCart!.saveShoppingCart(product: product, selectSize: selectedSize) {
            self.vc.bottomView.addBtn.isUserInteractionEnabled = true
        }
    }
}

//MARK: - Animate BagView

extension ProductViewModel {
    
    func animateBagView() {
        isAnimating = true
        
        let bagPos = vc.naviView.bagView.superview!.convert(vc.naviView.bagView.frame.origin, to: nil)
        let bottomPos = vc.bottomView.addBtn.superview!.convert(vc.bottomView.addBtn.frame.origin, to: nil)
        let bagH = screenWidth * (200/1000)
        
        let bagView = UIView(frame: CGRect(x: bagPos.x, y: bagPos.y, width: 40.0, height: 40.0))
        bagView.clipsToBounds = true
        bagView.backgroundColor = defaultColor
        bagView.layer.cornerRadius = 20.0
        bagView.alpha = 0.0
        vc.view.addSubview(bagView)
        
        let numLbl = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        numLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        numLbl.text = "+1"
        numLbl.textColor = .white
        numLbl.textAlignment = .center
        numLbl.alpha = 0.0
        bagView.addSubview(numLbl)
        
        //Di chuyển đến bị trí Add to Cart
        let trans = CGAffineTransform(translationX: -((screenWidth-40)/2)+20, y: bottomPos.y-45)
        let scale = CGAffineTransform(scaleX: bagH/40, y: bagH/40)
        bagView.transform = scale.concatenating(trans)
        
        //Trả về vị trí cũ
        UIView.animate(withDuration: 1.0) {
            bagView.transform = .identity
            bagView.alpha = 1.0
            numLbl.alpha = 1.0
            
        } completion: { _ in
            //Giảm tỉ lệ
            UIView.animate(withDuration: 0.33) {
                bagView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                
            } completion: { _ in
                //Tăng tỉ lệ. Giảm alpha
                UIView.animate(withDuration: 0.33) {
                    bagView.transform = .identity
                    bagView.alpha = 0.0
                    numLbl.alpha = 0.0
                    
                } completion: { _ in
                    self.vc.view.layoutIfNeeded()
                    
                    //Hiển thị Badge và xóa animate
                    UIView.animate(withDuration: 0.33) {
                        self.vc.naviView.updateBadge(appDL.badge)
                        self.vc.view.layoutIfNeeded()
                        
                    } completion: { _ in
                        bagView.removeFromSuperview()
                        self.isAnimating = false
                    }
                }
            }
        }
    }
}

//MARK: - SetupCell

extension ProductViewModel {
    
    func coverCell(_ cell: ProductCoverImageCVCell, indexPath: IndexPath) {
        let imageURL = imageURLs[indexPath.item]
        cell.coverImageView.image = nil
        cell.tag = indexPath.item
        
        DownloadImage.shared.downloadImage(link: imageURL) { image in
            if cell.tag == indexPath.item {
                cell.coverImageView.image = image
            }
        }
    }
    
    func sizeCell(_ cell: ProductSizeCVCell, indexPath: IndexPath) {
        let size = vc.product.sizes[indexPath.item]
        
        cell.sizeLbl.text = size
        cell.isSelect = vc.selectedSize == size
    }
    
    func colorCell(_ cell: ProductColorCVCell, indexPath: IndexPath) {
        let model = colors[indexPath.item]
        cell.setHiddenHalf()
        
        if let selectedColor = vc.selectedColor {
            cell.containerView.layer.borderColor = UIColor.clear.cgColor
            cell.innerView.backgroundColor = .clear
            
            if selectedColor.productUID == model.productUID {
                let color = selectedColor.color
                
                let component = color.components(separatedBy: ",")
                let first = (component.first ?? "").replacingOccurrences(of: " ", with: "")
                let last = (component.last ?? "").replacingOccurrences(of: " ", with: "")
                
                if component.count == 1 {
                    if first.count == 6 {
                        cell.containerView.layer.borderColor = UIColor(hexStr: first).cgColor
                        cell.innerView.backgroundColor = UIColor(hexStr: first)
                    }
                    
                } else if component.count == 2 {
                    if first.count == 6 {
                        cell.halfLeftBorderImageView.isHidden = false
                        cell.halfLeftBorderImageView.tintColor = UIColor(hexStr: first)
                        
                        cell.halfLeftImageView.isHidden = false
                        cell.halfLeftImageView.tintColor = UIColor(hexStr: first)
                    }
                    
                    if last.count == 6 {
                        cell.halfRightBorderImageView.isHidden = false
                        cell.halfRightBorderImageView.tintColor = UIColor(hexStr: last)
                        
                        cell.halfRightImageView.isHidden = false
                        cell.halfRightImageView.tintColor = UIColor(hexStr: last)
                    }
                }
                
            } else {
                let color = model.color
                
                let component = color.components(separatedBy: ",")
                let first = (component.first ?? "").replacingOccurrences(of: " ", with: "")
                let last = (component.last ?? "").replacingOccurrences(of: " ", with: "")
                
                if component.count == 1 {
                    if first.count == 6 {
                        cell.containerView.layer.borderColor = UIColor.clear.cgColor
                        cell.innerView.backgroundColor = UIColor(hexStr: first)
                    }

                } else if component.count == 2 {
                    if first.count == 6 {
                        cell.halfLeftImageView.isHidden = false
                        cell.halfLeftImageView.tintColor = UIColor(hexStr: first)
                    }

                    if last.count == 6 {
                        cell.halfRightImageView.isHidden = false
                        cell.halfRightImageView.tintColor = UIColor(hexStr: last)
                    }
                }
            }
        }
    }
    
    func relatedCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = relatedProducts[indexPath.item]
        
        cell.setupCell(product, indexPath: indexPath)
        setupShadow(cell.coverView, radius: 1.0, opacity: 0.1)
    }
}
