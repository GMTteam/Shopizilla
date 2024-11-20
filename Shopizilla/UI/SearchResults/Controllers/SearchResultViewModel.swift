//
//  SearchResultViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 19/04/2022.
//

import UIKit

class SearchResultViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: SearchResultVC
    
    //MARK: - Initializes
    init(vc: SearchResultVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension SearchResultViewModel {
    
    func loadData() {
        //Lọc các sản phẩm theo 'keyword'. Lưu trữ trong 'products'
        vc.products = vc.allProducts.filter({
            $0.name.lowercased().range(
                of: self.vc.keyword.lowercased(),
                options: [.diacriticInsensitive, .caseInsensitive],
                range: nil,
                locale: .current) != nil ||
            $0.tags.contains(self.vc.keyword) ||
            $0.subcategory.lowercased().range(
                of: self.vc.keyword.lowercased(),
                options: [.diacriticInsensitive, .caseInsensitive],
                range: nil,
                locale: .current) != nil ||
            $0.category.lowercased().range(
                of: self.vc.keyword.lowercased(),
                options: [.diacriticInsensitive, .caseInsensitive],
                range: nil,
                locale: .current) != nil ||
            $0.productID.lowercased().range(
                of: self.vc.keyword.lowercased(),
                options: [.diacriticInsensitive, .caseInsensitive],
                range: nil,
                locale: .current) != nil
        })
        
        vc.filterProducts = vc.products
        
        let links = vc.filterProducts.map({ $0.imageURL }).filter({ $0 != "" })
        DownloadImage.shared.batchDownloadImages(links: links)
        
        if vc.minPrice == 0.0 && vc.maxPrice == 0.0 {
            let prices = vc.filterProducts.map({ $0.price })
            vc.minPrice = prices.min() ?? 0.0
            vc.maxPrice = prices.max() ?? 0.0
        }
        
        vc.reloadData()
    }
}

//MARK: - Setups

extension SearchResultViewModel {
    
    func setupLayout() {
        sortBy()
        
        vc.noItemsLbl.isHidden = !(vc.filterProducts.count == 0)
        vc.itemWidth = (screenWidth - (vc.column == 3 ? 80 : 60)) / CGFloat(vc.column)
        vc.titleView.titleLbl.text = "Found".localized() + " \(vc.filterProducts.count) " + "Results".localized()
        
        DispatchQueue.main.async {
            self.vc.collectionView.reloadData()
            
            DispatchQueue.main.async {
                if self.vc.filterProducts.count != 0 {
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.vc.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
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
}

//MARK: - SetupCell

extension SearchResultViewModel {
    
    func productCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = vc.filterProducts[indexPath.item]
        
        cell.setupCell(product, indexPath: indexPath)
        cell.setupConstraintForIcon(vc.column)
        
        setupShadow(cell.coverView, radius: 1.0, opacity: 0.1)
    }
}
