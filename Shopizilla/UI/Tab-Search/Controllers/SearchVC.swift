//
//  SearchVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit

class SearchVC: UIViewController {

    // MARK: - Properties
    let separatorView = UIView()
    let searchController = UISearchController(searchResultsController: nil)
    var searchTableView: UITableView!
    
    let scrollView = SearchScrollView()
    var containerView: SearchContainerView { return scrollView.containerView }
    
    var searchesView: SearchRecentlySearchesView { return containerView.searchesView }
    var searchesCV: UICollectionView { return searchesView.collectionView }
    
    var viewedView: SearchRecentlyViewedView { return containerView.viewedView }
    var viewedCV: UICollectionView { return viewedView.collectionView }
    
    var categoriesView: SearchCategoriesView { return containerView.categoriesView }
    var categoriesTV: UITableView { return categoriesView.tableView }
    
    var hud: HUD?
    
    private var viewModel: SearchViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.allProducts.count == 0 {
            hud = HUD.hud(view)
            viewModel.allProducts = appDL.allProducts
            
            delay(duration: 1.0) {
                self.hud?.removeHUD {}
                
                self.viewModel.getSearchHistories()
                self.viewModel.getRecentlyViewed()
                self.viewModel.getSubcategories()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSearchTableView(tv: searchTableView, searchC: searchController) {
            self.searchTableView = nil
        }
    }
}

// MARK: - Setups

extension SearchVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        viewModel = SearchViewModel(vc: self)
        
        //TODO: - SearchController
        let searchBar = searchController.searchBar
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar.customFontSearchBar()
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self)
        
        searchesView.setupDataSourceAndDelegate(dl: self)
        searchesView.layout.delegate = self
        searchesView.removeAllBtn.delegate = self
        searchesView.removeAllBtn.tag = 0
        
        viewedView.setupDataSourceAndDelegate(dl: self)
        viewedView.viewAllBtn.delegate = self
        viewedView.viewAllBtn.tag = 1
        
        categoriesView.setupDataSourceAndDelegate(dl: self)
    }
}

// MARK: - AddObserver

extension SearchVC {
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: .searchHistoryKey, object: nil, queue: nil) { _ in
            self.viewModel.getSearchHistories()
        }
        NotificationCenter.default.addObserver(forName: .recentlyViewedKey, object: nil, queue: nil) { _ in
            self.viewModel.getRecentlyViewed()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchesCV {
            let count = viewModel.searchResults.count
            return count >= 10 ? 10 : count
            
        } else { //collectionView == viewedCV
            let count = viewModel.viewedProducts.count
            return count >= 10 ? 10 : count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchesCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecentlySearchesCVCell.id, for: indexPath) as! SearchRecentlySearchesCVCell
            viewModel.searchesCVCell(cell, indexPath: indexPath)
            return cell
            
        } else { //collectionView == viewedCV
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
            viewModel.viewedCell(cell, indexPath: indexPath)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if collectionView == searchesCV {
            let keyword = viewModel.searchResults[indexPath.item].keyword
            
            if let index = viewModel.searchResults.firstIndex(where: {
                $0.keyword.lowercased() == keyword.lowercased()
            }) {
                let id = viewModel.searchResults[index].id
                CoreDataStack.updateKeywordSearchHistory(with: keyword, id: id)
            }
            
            goToSearchResultVC(viewController: self, keyword: keyword)
            
        } else { //collectionView == viewedCV
            let product = viewModel.viewedProducts[indexPath.item]
            goToProductVC(viewController: self, product: product)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchVC: UICollectionViewDelegateFlowLayout {}

// MARK: - UISearchControllerDelegate

extension SearchVC: UISearchControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchesCV {
            return CGSize(width: 150.0, height: 40.0)
            
        } else { //collectionView == viewedCV
            return CGSize(width: viewedView.itemWidth, height: collectionView.bounds.height)
        }
    }
}

// MARK: - CustomLayoutDelegate

extension SearchVC: CustomLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath, cv: UICollectionView) -> CGSize {
        let keyword = viewModel.searchResults[indexPath.item].keyword
        let height: CGFloat = 35.0
        let width = keyword.estimatedTextRect(fontN: FontName.ppRegular, fontS: 16.0).width
        return CGSize(width: width + 30 + height, height: height)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTxt = searchController.searchBar.text,
              !searchTxt.trimmingCharacters(in: .whitespaces).isEmpty else {
                  viewModel.searchResultsFilter = viewModel.searchResults.map({ $0.keyword })
                  tvReloadData()
                  return
              }
        
        viewModel.searchResultsFilter.removeAll()
        viewModel.searchResultsFilter = getSearchResultsFilter(searchResults: viewModel.searchResults, searchTxt: searchTxt)

        tvReloadData()
    }
    
    private func searchActive() -> Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
}

// MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeSearchTableView(tv: searchTableView, searchC: searchController) {
            self.searchTableView = nil
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        createTV()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        var txt = ""
        if let searchTxt = searchBar.text, !searchTxt.trimmingCharacters(in: .whitespaces).isEmpty {
            var id = UUID().uuidString
            
            if let index = viewModel.searchResults.firstIndex(where: {
                $0.keyword.lowercased() == searchTxt.lowercased()
            }) {
                id = viewModel.searchResults[index].id
            }
            
            txt = searchTxt
            CoreDataStack.updateKeywordSearchHistory(with: searchTxt, id: id)
        }
        
        removeSearchTableView(tv: searchTableView, searchC: searchController) {
            self.searchTableView = nil
            
            if txt != "" {
                goToSearchResultVC(viewController: self, keyword: txt)
            }
        }
    }
}

// MARK: - Create UITableView

extension SearchVC {
    
    private func createTV() {
        guard searchTableView == nil else { return }
        searchTableView = setupSearchTableView(parentView: view, dl: self, isHidden: viewModel.searchResultsFilter.count == 0)
        viewModel.getSearchHistories()
    }
    
    func tvReloadData() {
        DispatchQueue.main.async {
            self.searchTableView?.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            let count = viewModel.searchResultsFilter.count
            return count >= 20 ? 20 : count
            
        } else if tableView == categoriesTV {
            return viewModel.subcategories.count
        }
        
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTVCell.id, for: indexPath) as! SearchHistoryTVCell
            viewModel.searchHistoryTVCell(cell, indexPath: indexPath)
            return cell
            
        } else if tableView == categoriesTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoriesTVCell.id, for: indexPath) as! SearchCategoriesTVCell
            viewModel.subcategoriesTVCell(cell, indexPath: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if tableView == searchTableView {
            let keyword = viewModel.searchResultsFilter[indexPath.row]
            
            if let index = viewModel.searchResults.firstIndex(where: {
                $0.keyword.lowercased() == keyword.lowercased()
            }) {
                let id = viewModel.searchResults[index].id
                CoreDataStack.updateKeywordSearchHistory(with: keyword, id: id)
            }
            
            removeSearchTableView(tv: searchTableView, searchC: searchController) {
                self.searchTableView = nil
                goToSearchResultVC(viewController: self, keyword: keyword)
            }
            
        } else if tableView == categoriesTV {
            let subcat = viewModel.subcategories[indexPath.row]
            let products = viewModel.getProductsFromSubcategory(subcat)
            
            let vc = SubcategoryViewAllVC()
            
            vc.products = products
            vc.filterProducts = products
            vc.kTitle = subcat
            vc.selectedSubcategory = subcat
            
            let acc = CategoryKey.Accessories.rawValue
            
            if subcat == acc {
                vc.category = appDL.allCategories.first(where: { $0.category == acc })
            }
            
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - ButtonAnimationDelegate

extension SearchVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Remove All (Recently Searches)
            CoreDataStack.deleteAllItem(entityName: .SearchHistory)
            NotificationCenter.default.post(name: .searchHistoryKey, object: nil)
            
        } else if sender.tag == 1 { //View All (Recently Viewed)
            let vc = SubcategoryViewAllVC()
            
            vc.products = viewModel.viewedProducts
            vc.filterProducts = viewModel.viewedProducts
            vc.kTitle = "Recently Viewed".localized()
            
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - SearchRecentlySearchesCVCell

extension SearchVC: SearchRecentlySearchesCVCellDelegate {
    
    func removeKeywordDidTap(_ cell: SearchRecentlySearchesCVCell) {
        if let indexPath = searchesCV.indexPath(for: cell) {
            let item = viewModel.searchResults.remove(at: indexPath.item)
            
            CoreDataStack.deleteItem(by: item.id, entityName: .SearchHistory)
            NotificationCenter.default.post(name: .searchHistoryKey, object: nil)
        }
    }
}
