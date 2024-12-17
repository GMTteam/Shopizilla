//
//  HomeVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - Properties
    private let menuBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTableView: UITableView!
    
    let separatorView = UIView()
    private let scrollView = HomeScrollView()
    private let ref = UIRefreshControl()
    private var containerView: HomeContainerView { return scrollView.containerView }
    
    var bannerView: HomeBannerView { return containerView.bannerView }
    var bannerCV: UICollectionView { return bannerView.collectionView }
    
    var newArrivalView: HomeNewArrivalView { return containerView.newArrivalView }
    private var newArrivalTopView: HomeNewArrivalTopView { return newArrivalView.topView }
    private var newArrivalCV: UICollectionView { return newArrivalView.collectionView }
    
    var featuredView: HomeFeaturedView { return containerView.featuredView }
    private var featuredTopView: HomeNewArrivalTopView { return featuredView.topView }
    private var featuredCV: UICollectionView { return featuredView.collectionView }
    
    var categoriesTopView: HomeCategoriesTopView { return categoriesView.topView }
    private var categoriesTopCV: UICollectionView { return categoriesTopView.collectionView }
    
    var categoriesView: HomeCategoriesView { return containerView.categoriesView }
    private var categoriesCV: UICollectionView { return categoriesView.collectionView }
    
    //Dành cho Search
    lazy var searchResults: [SearchHistory] = [] //Các từ khóa bên trong CoreData
    lazy var searchResultsFilter: [String] = [] //Các từ khóa đã lọc
    
    var hud: HUD?
    
    private var menuContainerVC: LeftMenuContainerVC?
    private var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
        
        viewModel.getBanners()
        viewModel.getCategories()
        
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.banners.count == 0 {
            hud = HUD.hud(view)
        }
        
        if appDL.currentUser == nil {
            viewModel.getCurrentUser()
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

extension HomeVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Home".localized()
        
        viewModel = HomeViewModel(vc: self)
        
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
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self, ref: ref)
        ref.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        
        bannerView.setupDataSourceAndDelegate(dl: self)
        
        newArrivalTopView.viewAllBtn.tag = 2
        newArrivalTopView.viewAllBtn.delegate = self
        
        newArrivalView.setupDataSourceAndDelegate(dl: self)
        newArrivalView.viewAllBtn.tag = 2
        newArrivalView.viewAllBtn.delegate = self
        newArrivalView.viewAllBtn.isHidden = true
        
        categoriesTopView.setupDataSourceAndDelegate(dl: self)
        categoriesTopView.layout.delegate = self
        
        categoriesView.setupDataSourceAndDelegate(dl: self)
        categoriesView.viewAllBtn.tag = 3
        categoriesView.viewAllBtn.delegate = self
        
        featuredTopView.viewAllBtn.tag = 4
        featuredTopView.viewAllBtn.delegate = self
        
        featuredView.setupDataSourceAndDelegate(dl: self)
        featuredView.viewAllBtn.tag = 4
        featuredView.viewAllBtn.delegate = self
        featuredView.viewAllBtn.isHidden = true
    }
    
    @objc private func refreshHandler() {
        ref.beginRefreshing()
        
        viewModel.getBanners()
        viewModel.getCategories()
        
        delay(duration: 1.0) {
            self.ref.endRefreshing()
        }
    }
}

// MARK: - NavigationBar

extension HomeVC {
    
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

// MARK: - AddObserver

extension HomeVC {
    
    private func addObserver() {
        //Cập nhật Pos cho LeftMenu mỗi khi app hoạt động trong nền
        NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if let vc = self.menuContainerVC {
                vc.centerVC.view.frame.origin.x = vc.xPos
            }
        }
        NotificationCenter.default.addObserver(forName: .signInKey, object: nil, queue: nil) { _ in
            self.viewModel.getBadge()
        }
        NotificationCenter.default.addObserver(forName: .signOutKey, object: nil, queue: nil) { _ in
            appDL.whenSignOut()
            
            self.updateBadge(appDL.badge)
        }
    }
}

// MARK: - ButtonAnimationDelegate

extension HomeVC: ButtonAnimationDelegate {
    
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
            
        } else if sender.tag == 2 { //NewArrivals SeeAll
            let vc = NewArrivalViewAllVC()
            
            vc.products = viewModel.newArrivalPrs
            vc.filterProducts = viewModel.newArrivalPrs
            
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 3 { //Categories SeeAll
            let subcat = viewModel.selectSubcategory
            let products = viewModel.selectProducts
            
            let vc = SubcategoryViewAllVC()
            
            vc.products = products
            vc.filterProducts = products
            vc.kTitle = subcat
            vc.selectedSubcategory = subcat
            
            if subcat == CategoryKey.Accessories.rawValue {
                vc.category = appDL.allCategories.first(where: {
                    $0.category == CategoryKey.Accessories.rawValue
                })
            }
            
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 4 { //Featured SeeAll
            let vc = SubcategoryViewAllVC()
            
            vc.products = viewModel.featuredPrs
            vc.filterProducts = viewModel.featuredPrs
            vc.kTitle = "Featured".localized()
            
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - MenuContainerVCDelegate

extension HomeVC: LeftMenuContainerVCDelegate {
    
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

extension HomeVC: LeftMenuTVCDelegate {
    
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

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCV {
            return InfiniteDataSource.numberOfItemsInSection(numberOfItemsInSection: viewModel.banners.count, numberOfSection: section, multiplier: bannerView.isMultiplier)
            
        } else if collectionView == newArrivalCV {
            return InfiniteDataSource.numberOfItemsInSection(
                numberOfItemsInSection: viewModel.newArrivalPrs.count,
                numberOfSection: section,
                multiplier: newArrivalView.isMultiplier)
            
        } else if collectionView == categoriesTopCV {
            return viewModel.categories.count
            
        } else if collectionView == categoriesCV {
            let count = viewModel.selectProducts.count
            return count >= 10 ? 10 : count
            
        } else { //collectionView == featuredCV
            let count = viewModel.featuredPrs.count
            return count >= 10 ? 10 : count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCVCell.id, for: indexPath) as! HomeBannerCVCell
            viewModel.bannerCell(cell, indexPath: bannerView.indexPath(indexPath, count: viewModel.banners.count))
            return cell
            
        } else if collectionView == newArrivalCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
            viewModel.newArrivalCell(cell, indexPath: newArrivalView.indexPath(indexPath, count: viewModel.newArrivalPrs.count))
            return cell
            
        } else if collectionView == categoriesTopCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoriesTopCVCell.id, for: indexPath) as! HomeCategoriesTopCVCell
            viewModel.categoriesTopCell(cell, indexPath: indexPath)
            return cell
            
        } else if collectionView == categoriesCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
            viewModel.categoriesCell(cell, indexPath: indexPath)
            return cell
            
        } else { //collectionView == featuredCV
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
            viewModel.featuredCell(cell, indexPath: indexPath)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if collectionView == bannerCV {
            let kIndexPath = bannerView.indexPath(indexPath, count: viewModel.banners.count)
            let banner = viewModel.banners[kIndexPath.item]
            
            goToCategoryDetail(viewController: self, category: banner.category, sub: banner.subcategory)
            
        } else if collectionView == newArrivalCV {
            let kIndexPath = newArrivalView.indexPath(indexPath, count: viewModel.newArrivalPrs.count)
            let product = viewModel.newArrivalPrs[kIndexPath.item]
            goToProductVC(viewController: self, product: product)
            
        } else if collectionView == categoriesTopCV {
            viewModel.selectSubcategory = viewModel.categories[indexPath.item].name
            viewModel.getProductsFromSubcategory()
            
            DispatchQueue.main.async {
                self.categoriesTopCV.reloadData()
                self.categoriesTopCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
                self.categoriesCV.reloadData()
                self.categoriesCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
            
        } else if collectionView == categoriesCV {
            let product = viewModel.selectProducts[indexPath.item]
            goToProductVC(viewController: self, product: product)
            
        } else { //collectionView == featuredCV
            let product = viewModel.featuredPrs[indexPath.item]
            goToProductVC(viewController: self, product: product)
        }
    }
}

// MARK: - HomeBannerCVCellDelegate

extension HomeVC: HomeBannerCVCellDelegate {
    
    func shopNowDidTap(_ cell: HomeBannerCVCell) {
        if let indexPath = bannerCV.indexPath(for: cell) {
            let kIndexPath = bannerView.indexPath(indexPath, count: viewModel.banners.count)
            let banner = viewModel.banners[kIndexPath.item]
            
            goToCategoryDetail(viewController: self, category: banner.category, sub: banner.subcategory)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCV {
            return CGSize(width: bannerView.itemWidth, height: collectionView.bounds.height)
            
        } else if collectionView == newArrivalCV {
            return CGSize(width: newArrivalView.itemWidth, height: collectionView.bounds.height)
            
        } else if collectionView == categoriesTopCV {
            return CGSize(width: 150.0, height: 60.0)
            
        } else if collectionView == categoriesCV {
            return CGSize(width: categoriesView.itemWidth, height: collectionView.bounds.height)
            
        } else if collectionView == featuredCV {
            return CGSize(width: featuredView.itemWidth, height: collectionView.bounds.height)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == newArrivalCV || collectionView == bannerCV {
            return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        }

        return .zero
    }
}

// MARK: - CustomLayoutDelegate

extension HomeVC: CustomLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath, cv: UICollectionView) -> CGSize {
        let cat = viewModel.categories[indexPath.item]
        let titleW = cat.name.estimatedTextRect(fontN: FontName.ppSemiBold, fontS: 22).width + 5
        let subW = "\(cat.count)".estimatedTextRect(fontN: FontName.ppRegular, fontS: 22).width + 5
        return CGSize(width: 40 + 20 + titleW + subW + 5, height: 60.0)
    }
}

// MARK: - UIScrollViewDelegate

extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCV {
            bannerView.layout.loopCollectionViewIfNeeded()
            
        } else if scrollView == newArrivalCV {
            newArrivalView.layout.loopCollectionViewIfNeeded()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == bannerCV {
            bannerView.layout.centerCollectionView(withVelocity: velocity, targetContentOffset: targetContentOffset)
            
        } else if scrollView == newArrivalCV {
            newArrivalView.layout.centerCollectionView(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}

// MARK: - UISearchControllerDelegate

extension HomeVC: UISearchControllerDelegate {}

// MARK: - UISearchResultsUpdating

extension HomeVC: UISearchResultsUpdating {
    
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

extension HomeVC: UISearchBarDelegate {
    
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

extension HomeVC {
    
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

extension HomeVC: UITableViewDataSource {
    
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

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
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

//MARK: - PushTo

func goToAboutUsVC(_ viewController: UIViewController) {
    let vc = AboutUsVC()
    vc.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(vc, animated: true)
}

func goToInformationVC(_ viewController: UIViewController) {
    let vc = InformationVC()
    vc.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(vc, animated: true)
}

func goToWelcomeVC(_ viewController: UIViewController) {
    let vc = WelcomeVC()
    let navi = NavigationController(rootViewController: vc)
    navi.modalPresentationStyle = .fullScreen
    viewController.present(navi, animated: true)
}

//MARK: - Search TableView

///Tạo UITableView cho SearchController
func setupSearchTableView(parentView: UIView, dl: UITableViewDataSource & UITableViewDelegate, isHidden: Bool) -> UITableView {
    let tvR = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
    
    let tv = UITableView(frame: tvR, style: .plain)
    tv.backgroundColor = .black.withAlphaComponent(0.9)
    tv.rowHeight = 44.0
    tv.isHidden = isHidden
    tv.sectionHeaderHeight = 0.0
    tv.sectionFooterHeight = 0.0
    tv.separatorInset = UIEdgeInsets(top: 0.0, left: 69.0, bottom: 0.0, right: 20.0)
    tv.showsVerticalScrollIndicator = false
    tv.showsHorizontalScrollIndicator = false
    tv.register(SearchHistoryTVCell.self, forCellReuseIdentifier: SearchHistoryTVCell.id)
    tv.dataSource = dl
    tv.delegate = dl
    parentView.addSubview(tv)
    
    return tv
}

///Đi đến trang SearchResultVC
func goToSearchResultVC(viewController: UIViewController, keyword: String) {
    let vc = SearchResultVC()
    vc.keyword = keyword
    vc.allProducts = appDL.allProducts
    vc.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(vc, animated: true)
}

func removeSearchTableView(tv: UITableView!, searchC: UISearchController, completion: @escaping () -> Void) {
    tv?.removeFromSuperview()
    
    searchC.searchBar.text = nil
    searchC.isActive = false
    searchC.dismiss(animated: true, completion: completion)
}

///Từ CoreData
func getSearchResultsFilter(searchResults: [SearchHistory], searchTxt: String) -> [String] {
    return searchResults.map({ $0.keyword }).filter({
        $0.lowercased().range(
            of: searchTxt.lowercased(),
            options: [.caseInsensitive, .diacriticInsensitive],
            range: nil,
            locale: .current) != nil
    })
}

func goToCategoryDetail(viewController: UIViewController, category: String, sub: String? = nil) {
    if category == "Wishlist" {
        goToWishlist(viewController: viewController)
        
    } else {
        switch category {
        case CategoryKey.NewArrivals.rawValue:
            let vc = NewArrivalViewAllVC()
            
            vc.products = appDL.allProducts.filter({ $0.newArrival })
            vc.filterProducts = appDL.allProducts.filter({ $0.newArrival })
            
            vc.hidesBottomBarWhenPushed = true
            viewController.navigationController?.pushViewController(vc, animated: true)
            
        default:
            guard let cat = appDL.allCategories.first(where: { $0.category == category }) else {
                return
            }
            
            let vc = CategoryViewAllVC()
            
            vc.category = cat
            vc.selectedSubcategory = sub ?? cat.subcategories.first ?? ""
            
            vc.hidesBottomBarWhenPushed = true
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

func goToWishlist(viewController: UIViewController) {
    let vc = SubcategoryViewAllVC()
    vc.kTitle = "My Wishlist".localized()
    vc.fromWishlist = true
    
    vc.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(vc, animated: true)
}

///Cho truy cập các tab
func setupSeparatorView(view: UIView, separatorView: UIView) {
    //TODO: - SeparatorView
    separatorView.clipsToBounds = true
    separatorView.backgroundColor = .clear
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(separatorView)
    
    separatorView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    separatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
}

func goToProductVC(viewController: UIViewController, product: Product) {
    let vc = ProductVC()
    vc.product = product
    vc.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(vc, animated: true)
}
