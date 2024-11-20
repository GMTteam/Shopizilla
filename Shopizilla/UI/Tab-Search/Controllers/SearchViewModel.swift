//
//  SearchViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: SearchVC
    
    lazy var allProducts: [Product] = []
    lazy var subcategories: [String] = [] //Tất cả danh mục phụ, bao gồm Accessories. Xóa New Arrivals
    
    //Dành cho Search
    lazy var searchResults: [SearchHistory] = [] //Các từ khóa bên trong CoreData
    lazy var searchResultsFilter: [String] = [] //Các từ khóa đã lọc
    
    lazy var recentlyViewed: [RecentlyViewed] = [] //Các prID bên trong CoreData
    lazy var viewedProducts: [Product] = [] //Các Products từ 'recentlyViewed'
    
    //MARK: - Initializes
    init(vc: SearchVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension SearchViewModel {
    
    //Lấy SearchHistories từ CoreData
    func getSearchHistories() {
        CoreDataStack.fetchSearchHistories { searchHistories in
            self.searchResults = searchHistories
            self.searchResultsFilter = self.searchResults.map({ $0.keyword })
            self.vc.searchTableView?.isHidden = self.searchResultsFilter.count == 0
            self.vc.tvReloadData()

            var keywords: [String] = []
            for i in 0..<self.searchResults.count {
                keywords.append(self.searchResults[i].keyword)
                if i == 9 { break }
            }

            self.vc.searchesView.updateHeight(self.vc, keywords: keywords)
            self.vc.searchesView.reloadData()
        }
    }
    
    //Lấy RecentlyViewed từ CoreData
    func getRecentlyViewed() {
        CoreDataStack.fetchRecentlyViewed { recentlyViewed in
            self.recentlyViewed = recentlyViewed

            var array: [Product] = []
            for viewed in recentlyViewed {
                if let pr = appDL.allProducts.first(where: {
                    $0.productID == viewed.productID && $0.category == viewed.category
                }) {
                    array.append(pr)
                }
            }

            self.viewedProducts = array

            let viewed = recentlyViewed.map({ $0.productID })
            self.vc.viewedView.updateHeight(self.vc, viewed: viewed)
            self.vc.viewedView.reloadData()
        }
    }
    
    //Lấy tên tất cả Danh Mục Phụ
    //Hiển thị cho mục trên Search tab
    func getSubcategories() {
        let categs = appDL.allCategories
        subcategories = categs.first(where: { $0.category == "Home" })?.subcategories ?? []
        
        vc.categoriesView.updateHeight(vc, subcats: subcategories)
        vc.categoriesView.reloadData()
        
        vc.containerView.updateHeight(self.vc)
    }
    
    //Nhận các Products theo Subcategory
    func getProductsFromSubcategory(_ subcategory: String) -> [Product] {
        var products: [Product] = []
        
        //Nếu Category là Accessories thì lọc theo khóa category
        if subcategory == CategoryKey.Accessories.rawValue {
            products = allProducts.filter({ $0.category == subcategory })
            
        } else {
            products = allProducts.filter({ $0.subcategory == subcategory })
        }
        
        return products
    }
}

//MARK: - SetupCell

extension SearchViewModel {
    
    func searchHistoryTVCell(_ cell: SearchHistoryTVCell, indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.titleLbl.text = searchResultsFilter[indexPath.row]
    }
    
    func subcategoriesTVCell(_ cell: SearchCategoriesTVCell, indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.titleLbl.text = subcategories[indexPath.row]
    }
    
    func searchesCVCell(_ cell: SearchRecentlySearchesCVCell, indexPath: IndexPath) {
        cell.titleLbl.text = searchResults[indexPath.item].keyword
        cell.delegate = vc
    }
    
    func viewedCell(_ cell: HomeProductCVCell, indexPath: IndexPath) {
        let product = viewedProducts[indexPath.item]
        
        cell.setupCell(product, indexPath: indexPath)
        cell.setupConstraintForIcon(3)
        
        setupShadow(cell.coverView, radius: 1.0, opacity: 0.1)
    }
}
