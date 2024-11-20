//
//  SearchResultVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 19/04/2022.
//

import UIKit

class SearchResultVC: UIViewController {

    // MARK: - Properties
    private let filterBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    private let sortBtn = ButtonAnimation()
    var noItemsLbl: UILabel!
    
    private let removeBtn = ButtonAnimation()
    private let searchTF = UITextField()
    private var searchTableView: UITableView!
    
    let separatorView = UIView()
    
    private var headerView = NewArrivalViewAllHeaderView()
    var titleView: NewArrivalViewAllTitleView { return headerView.titleView }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var itemWidth: CGFloat = (screenWidth-60) / 2
    private var itemHeight: CGFloat {
        let heightTxt = HomeProductCVCell.nameHeight + HomeProductCVCell.priceHeight + 20
        return itemWidth*imageHeightRatio + heightTxt + 10
    }
    
    var column = 2 //Số cột hiện tại
    
    var keyword = "" //Từ khóa được chọn để lọc sản phẩm
    lazy var allProducts: [Product] = [] //Tất cả sản phẩm
    lazy var products: [Product] = [] //Sản phẩm đã lọc từ 'keyword'
    lazy var filterProducts: [Product] = [] //Đã lọc Products thông qua mảng products
    
    //Dành cho Search
    lazy var searchResults: [SearchHistory] = [] //Các từ khóa bên trong CoreData
    lazy var searchResultsFilter: [String] = [] //Các từ khóa đã lọc
    
    private var isLoad = false //Tải lần đầu tiên
    private var hud: HUD?
    
    private var sortVC: SortVC?
    private var filterVC: FilterVC?
    
    var minPrice: Double = 0.0 //Lọc Theo giá
    var maxPrice: Double = 0.0 //Lọc Theo giá
    var selectedCat = "" //Lọc theo Category
    var selectedSort: SortModel? //Sắp xếp Products
    
    private var viewModel: SearchResultViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        updateBadge(appDL.badge)
        
        if hud == nil && !isLoad {
            isLoad = true
            hud = HUD.hud(view)
            
            viewModel.loadData()
            
            delay(duration: 1.0) {
                self.updateUI()
                self.hud?.removeHUD {}
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSearchTV()
    }
}

// MARK: - Setups

extension SearchResultVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = ""
        
        viewModel = SearchResultViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - CollectionView
        collectionView.isHidden = true
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.register(HomeProductCVCell.self, forCellWithReuseIdentifier: HomeProductCVCell.id)
        collectionView.register(NewArrivalViewAllHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewArrivalViewAllHeaderView.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        //TODO: - Layout
        collectionView.setupLayout(scrollDirection: .vertical, lineSpacing: 20.0, itemSpacing: 20.0)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        //TODO: - NoItemsLbl
        noItemsLbl = createNoItems(view: view)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - NavigationBar

extension SearchResultVC {
    
    private func setupNavi() {
        //TODO: - BagView
        let bagView = createRightView(bagBtn, badgeLbl)
        bagBtn.delegate = self
        
        //TODO: - FilterView
        let filterR = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        let filterView = UIView(frame: filterR)
        filterView.clipsToBounds = true
        filterView.backgroundColor = .clear
        
        //Nếu bagBtn lấy hình ảnh là 'center' thì filterBtn tương tự hoặc 'right'
        filterBtn.frame = filterR
        filterBtn.tag = 2
        filterBtn.delegate = self
        filterBtn.clipsToBounds = true
        filterView.addSubview(filterBtn)
        
        //TODO: - SortView
        let sortView = UIView(frame: filterR)
        sortView.clipsToBounds = true
        sortView.backgroundColor = .clear
        
        //Nếu bagBtn lấy hình ảnh là 'center' thì sortBtn tương tự hoặc 'right'
        sortBtn.frame = filterR
        sortBtn.tag = 0
        sortBtn.delegate = self
        sortBtn.clipsToBounds = true
        sortView.addSubview(sortBtn)
        
        //TODO: - SearchView
        let searchW: CGFloat = screenWidth-(40*5)
        let searchView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: searchW, height: 40.0))
        searchView.clipsToBounds = true
        searchView.backgroundColor = .clear
        
        removeBtn.tag = 5
        removeBtn.delegate = self
        removeBtn.isHidden = true
        
        searchTF.searchTF(searchView, width: searchW, dl: self, bgColor: UIColor(hex: 0xEAEAF0), removeBtn: removeBtn)
        searchTF.returnKeyType = .search
        searchTF.addTarget(self, action: #selector(searchEditingChanged), for: .editingChanged)
        
        //TODO: - UINavigationItem
        let bagBar = UIBarButtonItem(customView: bagView)
        let flex1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let filterBar = UIBarButtonItem(customView: filterView)
        let flex2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let sortBar = UIBarButtonItem(customView: sortView)
        let flex3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let searchBar = UIBarButtonItem(customView: searchView)
        let items = [bagBar, flex1, filterBar, flex2, sortBar, flex3, searchBar]
        
        navigationItem.setRightBarButtonItems(items, animated: true)
    }
    
    func updateBadge(_ badge: Int) {
        let bagImg = UIImage(named: badge == 0 ? "icon-bagRight" : "icon-bagCenter")
        let filterImg = UIImage(named: badge == 0 ? "icon-filterRight" : "icon-filterCenter")
        let sortImg = UIImage(named: badge == 0 ? "icon-sortRight" : "icon-sortCenter")
        
        bagBtn.setImage(bagImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        filterBtn.setImage(filterImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        sortBtn.setImage(sortImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        bagBtn.tintColor = defaultColor
        filterBtn.tintColor = defaultColor
        sortBtn.tintColor = defaultColor
        
        badgeLbl.isHidden = badge == 0
        badgeLbl.text = "\(badge)"
    }
    
    @objc private func searchEditingChanged(_ tf: UITextField) {
        guard let searchTxt = tf.text, !searchTxt.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResultsFilter = searchResults.map({ $0.keyword })
            tvReloadData()
            return
        }
        
        searchResultsFilter.removeAll()
        searchResultsFilter = getSearchResultsFilter(searchResults: searchResults, searchTxt: searchTxt)
        
        tvReloadData()
    }
    
    private func removeHidden(_ isHidden: Bool) {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.removeBtn.isHidden = isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    private func removeSearchTV() {
        searchTableView?.removeFromSuperview()
        searchTableView = nil
        
        searchTF.text = nil
        searchTF.resignFirstResponder()
        
        removeHidden(true)
    }
}

// MARK: - UpdateUI

extension SearchResultVC {
    
    private func updateUI() {
        searchTF.text = keyword
        removeHidden(false)
        
        collectionView.isHidden = false
        
        titleView.isHidden = false
        titleView.titleLbl.text = "Found \(filterProducts.count) Results"
        titleView.updateTintColorForBtn(column)
    }
}

// MARK: - ButtonAnimationDelegate

extension SearchResultVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Sort
            removeSearchTV()
            
            sortVC?.removeFromParent()
            sortVC = nil

            sortVC = SortVC()
            sortVC?.view.frame = kWindow.bounds
            sortVC?.delegate = self
            sortVC?.selected = selectedSort
            kWindow.addSubview(sortVC!.view)

            let rect = sortBtn.superview!.convert(sortBtn.frame, to: nil)
            sortVC?.setupViews(rect.origin.y + 50)
            
        } else if sender.tag == 1 { //Bag
            tabBarController?.selectedIndex = 2
            
        } else if sender.tag == 2 { //Filter
            removeSearchTV()
            
            filterVC?.removeFromParent()
            filterVC = nil
            
            filterVC = FilterVC()
            filterVC?.view.frame = kWindow.bounds
            filterVC?.products = products
            filterVC?.delegate = self
            filterVC?.minPrice = minPrice
            filterVC?.maxPrice = maxPrice
            filterVC?.selectedCat = selectedCat
            
            kWindow.addSubview(filterVC!.view)
            
        } else if sender.tag == 3 { //ThreeColumns
            column = 3
            titleView.updateTintColorForBtn(column)
            setupLayoutProductCV()
            
        } else if sender.tag == 4 { //TwoColumns
            column = 2
            titleView.updateTintColorForBtn(column)
            setupLayoutProductCV()
            
        } else if sender.tag == 5 { //Remove
            removeSearchTV()
        }
    }
    
    func setupLayoutProductCV() {
        itemWidth = (screenWidth - (column == 3 ? 80 : 60)) / CGFloat(column)
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
        viewModel.productCell(cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NewArrivalViewAllHeaderView.id, for: indexPath) as! NewArrivalViewAllHeaderView
            
            self.headerView = headerView
            
            titleView.threeColumnsBtn.tag = 3
            titleView.threeColumnsBtn.delegate = self

            titleView.twoColumnsBtn.tag = 4
            titleView.twoColumnsBtn.delegate = self
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = filterProducts[indexPath.item]
        goToProductVC(viewController: self, product: product)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50.0)
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var txt = ""
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            txt = text
        }
        
        removeHidden(textField.text?.count == 0 || txt == "")
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        removeHidden(false)
        createTV()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var txt = ""
        if let searchTxt = textField.text, !searchTxt.trimmingCharacters(in: .whitespaces).isEmpty {
            var id = UUID().uuidString
            
            if let index = searchResults.firstIndex(where: {
                $0.keyword.lowercased() == searchTxt.lowercased()
            }) {
                id = searchResults[index].id
            }
            
            txt = searchTxt
            CoreDataStack.updateKeywordSearchHistory(with: searchTxt, id: id)
        }
        
        removeSearchTV()
        
        if txt != "" {
            goToSearchResultVC(viewController: self, keyword: txt)
        }
    }
}

// MARK: - FilterVCDelegate

extension SearchResultVC: FilterVCDelegate {
    
    func applyDidTap(vc: FilterVC, minPrice: Double, maxPrice: Double, selectedCat: String) {
        vc.removeHandler {
            self.minPrice = minPrice
            self.maxPrice = maxPrice
            self.selectedCat = selectedCat
            
            var newProducts = self.products
            
            if self.minPrice != 0.0 && self.maxPrice != 0.0 {
                if self.minPrice == self.maxPrice {
                    newProducts = self.products.filter({ $0.price == self.minPrice })
                    
                } else if self.minPrice < self.maxPrice {
                    //Products nằm trong phạm vi giá được lọc
                    let range = self.minPrice...self.maxPrice
                    newProducts = self.products.filter({ range.contains($0.price) })
                }
            }
            
            guard self.selectedCat != "" else {
                self.filterProducts = newProducts
                self.viewModel.setupLayout()
                return
            }
            
            self.filterProducts = newProducts.filter({
                return $0.category == self.selectedCat || $0.subcategory == self.selectedCat
            })
            
            self.viewModel.setupLayout()
        }
    }
}

// MARK: - SortVCDelegate

extension SearchResultVC: SortVCDelegate {
    
    func selectedFilter(_ vc: SortVC, selected: SortModel) {
        vc.removeHandler {
            self.selectedSort = selected
            self.viewModel.sortBy()
            self.reloadData()
        }
    }
}

// MARK: - Create UITableView

extension SearchResultVC {
    
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

extension SearchResultVC: UITableViewDataSource {
    
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

extension SearchResultVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keyword = searchResultsFilter[indexPath.row]
        
        if let index = searchResults.firstIndex(where: {
            $0.keyword.lowercased() == keyword.lowercased()
        }) {
            let id = searchResults[index].id
            CoreDataStack.updateKeywordSearchHistory(with: keyword, id: id)
        }
        
        removeSearchTV()
        goToSearchResultVC(viewController: self, keyword: keyword)
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
