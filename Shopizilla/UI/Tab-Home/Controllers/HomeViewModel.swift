//
//  HomeViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/04/2022.
//

import UIKit
import Firebase

class HomeViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: HomeVC
    
    lazy var banners: [Banner] = []
    
    lazy var newArrivalPrs: [Product] = [] //New Arrivals
    lazy var featuredPrs: [Product] = [] //Featured
    
    lazy var categories: [(name: String, count: Int)] = [] //Tên của danh mục
    lazy var allCategories: [Category] = [] //Tất cả danh mục hiện tại
    lazy var allProducts: [Product] = [] //Tất cả sản phẩm. Cho phần Categories
    lazy var selectProducts: [Product] = [] //Chọn Products theo Category
    
    var selectSubcategory = "" //Chọn Subcategory
    var previousSubcategory = "" //Chọn Subcategory trước đó. Ko refresh 2 lần cho 1 subcategory
    
    var bannerTimer: Timer?
    var bannerIndex = 0
    
    //MARK: - Initializes
    init(vc: HomeVC) {
        self.vc = vc
    }
}

//MARK: - CurrentUser

extension HomeViewModel {
    
    func getCurrentUser() {
        User.fetchCurrentUser { user in
            appDL.currentUser = user
            
            //Đẩy một thông báo khi người dùng cập nhật gì đó
            NotificationCenter.default.post(name: .signInKey, object: nil)
        }
    }
}

//MARK: - Banner

extension HomeViewModel {
    
    func getBanners() {
        Banner.fetchBanners { banners in
            self.banners.removeAll()
            self.banners = banners
            
            let links = self.banners.map({ $0.imageURL }).filter({ $0 != "" })
            DownloadImage.shared.batchDownloadImages(links: links)
            
            let link = self.banners.first?.imageURL ?? ""
            
            DownloadImage.shared.downloadImage(link: link) { image in
                let size = image?.size ?? CGSize(width: 790.0, height: 252.0)
                let scale = (size.height/size.width)
                
                self.vc.bannerView.itemWidth = (screenWidth-40)
                self.vc.bannerView.cvHeight = self.vc.bannerView.itemWidth * scale
                self.vc.bannerView.setupHeightConstraint(vc: self.vc, count: banners.count)
                self.vc.bannerView.reloadData()
                self.vc.hud?.removeHUD {}
                
                if self.bannerTimer != nil {
                    self.bannerTimer?.invalidate()
                    self.bannerTimer = nil
                }

                self.bannerTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true, block: { _ in
                    self.bannerScrollTo()
                })
            }
        }
    }
    
    private func bannerScrollTo() {
        let items = InfiniteDataSource.numberOfItemsInSection(numberOfItemsInSection: banners.count, numberOfSection: 0, multiplier: vc.bannerView.isMultiplier)
        
        DispatchQueue.main.async {
            self.bannerIndex += 1
            
            if self.bannerIndex == items {
                self.bannerIndex = 0
            }
            
            let indexPath = IndexPath(item: self.bannerIndex, section: 0)
            let isAnim = self.bannerIndex != 0
            
            self.vc.bannerCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isAnim)
        }
    }
}

//MARK: - Categories

extension HomeViewModel {
    
    func getCategories() {
        let start = DispatchTime.now()
        
        Category.fetchCategories { categs in
            self.categories.removeAll()
            self.allCategories = categs
            appDL.allCategories = categs
            
            //Hiển thị Danh Mục cho Home
            if let index = categs.firstIndex(where: { $0.category == "Home" }) {
                self.categories = categs[index].subcategories.map({ (name: $0, count: 0) })
            }
            
            Product.fetchAllProduct { products in
                self.allProducts = products
                appDL.allProducts = products
                
                self.getNewArrivals()
                self.getFeatured()
                
                //Thêm số lượng sản phẩm vào danh mục
                let accTxt = CategoryKey.Accessories.rawValue
                let count = self.allProducts.filter({ $0.category == accTxt }).count
                
                if let index = self.categories.firstIndex(where: { $0.name == accTxt }) {
                    self.categories[index].count = count
                }
                
                for i in 0..<self.categories.count {
                    if self.categories[i].name != accTxt {
                        let count = self.allProducts.filter({
                            $0.subcategory == self.categories[i].name
                        }).count
                        self.categories[i].count = count
                    }
                }
                
                self.selectSubcategory = self.categories.first?.name ?? ""
                self.getProductsFromSubcategory()
                
                self.vc.categoriesView.setupHeightConstraint(vc: self.vc, count: self.categories.count)
                self.vc.categoriesTopView.reloadData()
                self.vc.categoriesView.reloadData()
                
                let end = DispatchTime.now()
                let time = (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                print("*** downloadTime: \(time)s")
            }
        }
    }
}

//MARK: - Products For Subcategory

extension HomeViewModel {
    
    func getProductsFromSubcategory() {
        //Nếu Category là Accessories thì lọc theo category_Key
        selectProducts = allProducts.filter({
            if selectSubcategory == CategoryKey.Accessories.rawValue {
                return $0.category == selectSubcategory
                
            } else {
                return $0.subcategory == selectSubcategory
            }
        })
        
        if previousSubcategory == selectSubcategory { return }
        
        previousSubcategory = selectSubcategory
        selectProducts = selectProducts.shuffled()
        
        let links = selectProducts.map({ $0.imageURL }).filter({ $0 != "" })
        DownloadImage.shared.batchDownloadImages(links: links)
    }
}

//MARK: - New Arrivals

extension HomeViewModel {
    
    private func getNewArrivals() {
        newArrivalPrs = allProducts.filter({ $0.newArrival }).shuffled()
        
        let links = newArrivalPrs.map({ $0.imageURL }).filter({ $0 != "" })
        DownloadImage.shared.batchDownloadImages(links: links)
        
        vc.newArrivalView.setupHeightConstraint(vc: vc, count: newArrivalPrs.count)
        vc.newArrivalView.reloadData()
    }
}

//MARK: - Featured

extension HomeViewModel {
    
    private func getFeatured() {
        featuredPrs = allProducts.filter({ $0.featured }).shuffled()
        
        let links = featuredPrs.map({ $0.imageURL }).filter({ $0 != "" })
        DownloadImage.shared.batchDownloadImages(links: links)
        
        vc.featuredView.setupHeightConstraint(vc: vc, setHidden: featuredPrs.count == 0)
        vc.featuredView.reloadData()
    }
}

//MARK: - Badge

extension HomeViewModel {
    
    //Lấy sản phẩm cho Giỏ Hàng
    func getBadge() {
        ShoppingCart.fetchShoppingCartByCurrentUser(status: "0") { shoppings in
            appDL.shoppings = shoppings
            appDL.badge = appDL.shoppings.map({ $0.quantity }).reduce(0, +)
            self.vc.updateBadge(appDL.badge)
            
            NotificationCenter.default.post(name: .bagKey, object: nil)
        }
    }
}

//MARK: - SetupCell

extension HomeViewModel {
    
    func bannerCell(_ cell: HomeBannerCVCell, indexPath: IndexPath) {
        let banner = banners[indexPath.item]
        
        cell.bannerImageView.image = nil
        cell.nameLbl.text = banner.name
        cell.desLbl.text = banner.description
        cell.delegate = vc
        
        cell.nameLbl.isHidden = true
        cell.desLbl.isHidden = true
        cell.shopNowBtn.isHidden = true
        cell.tag = indexPath.item
        
        DownloadImage.shared.downloadImage(link: banner.imageURL) { image in
            if cell.tag == indexPath.item {
                cell.bannerImageView.image = image
                
                cell.nameLbl.isHidden = false
                cell.desLbl.isHidden = false
                cell.shopNowBtn.isHidden = false
            }
        }
    }
    
    func newArrivalCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = newArrivalPrs[indexPath.item]
        cell.setupCell(product, indexPath: indexPath)
    }
    
    func categoriesTopCell(_ cell: HomeCategoriesTopCVCell, indexPath: IndexPath) {
        let cat = categories[indexPath.item]
        
        cell.titleLbl.text = cat.name
        cell.iconImageView.image = UIImage(named: "cat-\(cat.name.lowercased())")?.withRenderingMode(.alwaysTemplate)
        cell.subtitleLbl.text = "\(cat.count)"
        cell.isSelect = selectSubcategory == cat.name
    }
    
    func categoriesCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = selectProducts[indexPath.item]
        cell.setupCell(product, indexPath: indexPath)
    }
    
    func featuredCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = featuredPrs[indexPath.item]
        cell.setupCell(product, indexPath: indexPath)
    }
}
