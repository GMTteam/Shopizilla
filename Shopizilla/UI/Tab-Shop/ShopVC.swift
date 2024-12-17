//
//  ShopVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit

class ShopVC: UIViewController {

    // MARK: - Properties
    private let menuBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTableView: UITableView!
    
    let separatorView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let ref = UIRefreshControl()
    
    //Dành cho Search
    lazy var searchResults: [SearchHistory] = [] //Các từ khóa bên trong CoreData
    lazy var searchResultsFilter: [String] = [] //Các từ khóa đã lọc
    
    //Parallax
    let parallaxSpeed: CGFloat = 30.0
    let cellHeight: CGFloat = 170.0
    var parallaxHeight: CGFloat {
        let height = collectionView.frame.height
        let offset = (sqrt(pow(cellHeight, 2) + 4 * height * parallaxSpeed) - cellHeight)/2
        return offset
    }
    
    var hud: HUD?
    
    private var menuContainerVC: LeftMenuContainerVC?
    private var viewModel: ShopViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
        addObserver()
        
        viewModel.getShops()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        updateBadge(appDL.badge)
        
        if hud == nil && viewModel.shops.count == 0 {
            hud = HUD.hud(view)
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

extension ShopVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Shopizilla"
        
        viewModel = ShopViewModel(vc: self)
        
        //TODO: - SearchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.customFontSearchBar()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        collectionView.register(ShopCVCell.self, forCellWithReuseIdentifier: ShopCVCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        
        collectionView.collectionViewLayout = layout
        
        //TODO: - NSLayoutConstraint
        collectionView.setupConstraint(superView: view, subview: separatorView)
    }
    
    @objc private func refreshHandler() {
        ref.beginRefreshing()
        
        viewModel.getShops()
        
        delay(duration: 1.0) {
            self.ref.endRefreshing()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - NavigationBar

extension ShopVC {
    
    private func setupNavi() {
        //TODO: - LeftView
        let leftView = createLeftView(menuBtn)
        menuBtn.delegate = self
        
        //TODO: - RightView
        let rightView = createRightView(bagBtn, badgeLbl)
        bagBtn.delegate = self
        
        //TODO: - UINavigationItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    
    func updateBadge(_ badge: Int) {
        let bagImg = UIImage(named: badge == 0 ? "icon-bagRight" : "icon-bagCenter")
        bagBtn.setImage(bagImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        bagBtn.tintColor = defaultColor
        
        badgeLbl.isHidden = badge == 0
        badgeLbl.text = "\(badge)"
    }
}

// MARK: - Add Observer

extension ShopVC {
    
    private func addObserver() {
        //Cập nhật Pos cho LeftMenu mỗi khi app hoạt động trong nền
        NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if let vc = self.menuContainerVC {
                vc.centerVC.view.frame.origin.x = vc.xPos
            }
        }
        NotificationCenter.default.addObserver(forName: .bagKey, object: nil, queue: nil) { _ in
            self.updateBadge(appDL.badge)
        }
    }
}
    
// MARK: - ButtonAnimationDelegate

extension ShopVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Menu
            removeMenuContainerView(menuContainerVC)
            menuContainerVC = createMenuContainerView(tabBarController, navigationController, self, self)
            
            removeSearchTableView(tv: searchTableView, searchC: searchController) {
                self.searchTableView = nil
            }
            
        } else if sender.tag == 1 { //Bag
            tabBarController?.selectedIndex = 2
        }
    }
}

//MARK: - MenuContainerVCDelegate

extension ShopVC: LeftMenuContainerVCDelegate {
    
    func completionAnim(_ isComplete: Bool) {
        createEffect(isComplete, vc: self, selector: #selector(handlerRemoveMenu))
        
        if !isComplete {
            removeMenuContainerView(menuContainerVC)
        }
    }
    
    @objc private func handlerRemoveMenu() {
        menuContainerVC?.toggleSideMenu()
        removeEffect()
    }
}

//MARK: - SideMenuTVCDelegate

extension ShopVC: LeftMenuTVCDelegate {
    
    func categoryDidTap(_ category: String) {
        goToCategoryDetail(viewController: self, category: category)
    }
    
    func aboutUsDidTap() {
        goToAboutUsVC(self)
    }
    
    func informationDidTap() {
        goToInformationVC(self)
    }
    
    func loginDidTap() {
        goToWelcomeVC(self)
    }
}

// MARK: - UICollectionViewDataSource

extension ShopVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCVCell.id, for: indexPath) as! ShopCVCell
        viewModel.shopCell(cell, indexPath: indexPath, cv: collectionView)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ShopVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        let model = viewModel.shops[indexPath.item]
        let products = appDL.allProducts.filter({ $0.subcategory == model.name })
        
        let vc = SubcategoryViewAllVC()
        
        vc.products = products
        vc.filterProducts = products
        vc.kTitle = model.name
        vc.selectedSubcategory = model.name
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShopVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-40, height: cellHeight)
    }
}

// MARK: - UISearchControllerDelegate

extension ShopVC: UISearchControllerDelegate {}

// MARK: - UISearchResultsUpdating

extension ShopVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTxt = searchController.searchBar.text,
              !searchTxt.trimmingCharacters(in: .whitespaces).isEmpty else {
                  searchResultsFilter = searchResults.map({ $0.keyword })
                  tvReloadData()
                  return
              }
        
        searchResultsFilter.removeAll()
        searchResultsFilter = getSearchResultsFilter(searchResults: searchResults, searchTxt: searchTxt)
        
        tvReloadData()
    }
    
    private func searchActive() -> Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
}

// MARK: - UISearchBarDelegate

extension ShopVC: UISearchBarDelegate {
    
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
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        var txt = ""
        if let searchTxt = searchBar.text, !searchTxt.trimmingCharacters(in: .whitespaces).isEmpty {
            var id = UUID().uuidString
            
            if let index = searchResults.firstIndex(where: {
                $0.keyword.lowercased() == searchTxt.lowercased()
            }) {
                id = searchResults[index].id
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

extension ShopVC {
    
    private func createTV() {
        guard searchTableView == nil else { return }
        searchTableView = setupSearchTableView(parentView: view, dl: self, isHidden: searchResultsFilter.count == 0)
        
        //Lấy dữ liệu từ CoreData
        CoreDataStack.fetchSearchHistories { searchHistories in
            self.searchResults = searchHistories
            self.searchResultsFilter = self.searchResults.map({ $0.keyword })
            self.searchTableView?.isHidden = self.searchResultsFilter.count == 0
            self.tvReloadData()
        }
    }
    
    private func tvReloadData() {
        DispatchQueue.main.async {
            self.searchTableView?.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension ShopVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = searchResultsFilter.count
        return count >= 20 ? 20 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTVCell.id, for: indexPath) as! SearchHistoryTVCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.titleLbl.text = searchResultsFilter[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ShopVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keyword = searchResultsFilter[indexPath.row]
        
        if let index = searchResults.firstIndex(where: {
            $0.keyword.lowercased() == keyword.lowercased()
        }) {
            let id = searchResults[index].id
            CoreDataStack.updateKeywordSearchHistory(with: keyword, id: id)
        }
        
        removeSearchTableView(tv: searchTableView, searchC: searchController) {
            self.searchTableView = nil
            goToSearchResultVC(viewController: self, keyword: keyword)
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
