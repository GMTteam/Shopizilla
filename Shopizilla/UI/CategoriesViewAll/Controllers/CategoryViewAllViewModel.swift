//
//  CategoryViewAllViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 22/04/2022.
//

import UIKit

class CategoryViewAllViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: CategoryViewAllVC
    
    var isLoadMore = false
    
    //MARK: - Initializes
    init(vc: CategoryViewAllVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension CategoryViewAllViewModel {
    
    func getProductsFromSubcategory() {
        guard let category = vc.category, vc.selectedSubcategory != "" else {
            return
        }
        
        if vc.selectedSubcategory == CategoryKey.NewArrivals.rawValue {
            vc.products = appDL.allProducts.filter({ $0.newArrival })
            
        } else {
            vc.products = appDL.allProducts
                .filter({
                    $0.category == category.category &&
                    $0.subcategory == vc.selectedSubcategory
                })
                .sorted(by: { $0.createdDate > $1.createdDate })
        }
        
        if !vc.isLoad {
            vc.filterProducts = vc.products
        }
        
        vc.updateUI()
        vc.isLoad = true
        vc.hud?.removeHUD {}
        isLoadMore = true
        setupFilterProducts()
    }
}

//MARK: - Setups

extension CategoryViewAllViewModel {
    
    func setupFilterProducts() {
        var newProducts: [Product] = vc.products
        
        //Lọc theo giá
        if vc.minPrice != 0.0 && vc.maxPrice != 0.0 {
            if vc.minPrice == vc.maxPrice {
                newProducts = vc.products.filter({ $0.price == vc.minPrice })
                
            } else if vc.minPrice < vc.maxPrice {
                //Products nằm trong phạm vi giá được lọc
                let range = vc.minPrice...vc.maxPrice
                newProducts = vc.products.filter({ range.contains($0.price) })
            }
        }
        
        //Lọc theo Category
        guard vc.selectedCat != "" else {
            vc.filterProducts = newProducts
            setupLayout()
            return
        }
        
        vc.filterProducts = newProducts.filter({ $0.subcategory == vc.selectedCat })
        setupLayout()
    }
    
    private func setupLayout() {
        sortBy()
        
        if vc.keyword != "" {
            vc.filterProducts = vc.filterProductsByKeyword()
        }
        
        let links = vc.filterProducts.map({ $0.imageURL }).filter({ $0 != "" })
        DownloadImage.shared.batchDownloadImages(links: links)
        
        vc.noItemsLbl.isHidden = !(vc.filterProducts.count == 0)
        setupLayoutProductCV()
    }
    
    ///Sắp xếp bởi ...
    func sortBy() {
        if let selectedSort = vc.selectedSort {
            switch selectedSort.index {
            case 0: //Sort A to Z
                vc.filterProducts = vc.filterProducts.sorted(by: { $0.name < $1.name })
                
            case 1: //Sort Z to A
                vc.filterProducts = vc.filterProducts.sorted(by: { $0.name > $1.name })
                
            case 2: //Price: Low to High
                vc.filterProducts = vc.filterProducts.sorted(by: { $0.price < $1.price })
                
            case 3: //Price: High to Low
                vc.filterProducts = vc.filterProducts.sorted(by: { $0.price > $1.price })
                
            case 4: //Random
                vc.filterProducts = vc.filterProducts.shuffled()
                
            default: break
            }
        }
    }
    
    func setupLayoutProductCV() {
        vc.itemWidth = (screenWidth - (vc.column == 3 ? 80 : 60)) / CGFloat(vc.column)
        vc.reloadData()
    }
}

//MARK: - SetupCell

extension CategoryViewAllViewModel {
    
    func subcategoryCell(_ cell: CategoryViewAllSubcatCVCell, indexPath: IndexPath) {
        if let category = vc.category {
            let sub = category.subcategories[indexPath.item]
            cell.titleLbl.text = sub
            cell.isSelect = vc.selectedSubcategory == sub
        }
    }
    
    func productCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = vc.filterProducts[indexPath.item]
        
        cell.setupCell(product, indexPath: indexPath)
        cell.setupConstraintForIcon(vc.column)
        
        setupShadow(cell.coverView, radius: 1.0, opacity: 0.1)
    }
}
