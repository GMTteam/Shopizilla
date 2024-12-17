//
//  NewArrivalViewAllViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 18/04/2022.
//

import UIKit

class NewArrivalViewAllViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: NewArrivalViewAllVC
    
    var isLoadMore = false
    
    //MARK: - Initializes
    init(vc: NewArrivalViewAllVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension NewArrivalViewAllViewModel {
    
    func getNewArrivals() {
        delay(duration: 1.0) {
            self.vc.updateUI()
            self.vc.hud?.removeHUD {}
            self.isLoadMore = true
            self.setupFilterProducts()
        }
    }
}

//MARK: - Setups

extension NewArrivalViewAllViewModel {
    
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
        
        vc.filterProducts = newProducts.filter({
            return $0.category == vc.selectedCat || $0.subcategory == vc.selectedCat
        })
        
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

extension NewArrivalViewAllViewModel {
    
    func productCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = vc.filterProducts[indexPath.item]
        
        cell.setupCell(product, indexPath: indexPath)
        cell.setupConstraintForIcon(vc.column)
        
        setupShadow(cell.coverView, radius: 1.0, opacity: 0.1)
    }
}
