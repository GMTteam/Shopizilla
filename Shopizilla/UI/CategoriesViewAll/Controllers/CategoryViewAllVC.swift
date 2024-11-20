//
//  CategoryViewAllVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 22/04/2022.
//

import UIKit

class CategoryViewAllVC: UIViewController {

    // MARK: - Properties
    private let filterBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    private let sortBtn = ButtonAnimation()
    private let removeBtn = ButtonAnimation()
    private let searchTF = UITextField()
    
    var noItemsLbl: UILabel!
    
    let separatorView = UIView()
    
    private var headerView = CategoryViewAllHeaderView()
    
    private var bannerView: CategoryViewAllBannerView { return headerView.bannerView }
    private var titleView: NewArrivalViewAllTitleView { return headerView.titleView }
    
    var subcatView: CategoryViewAllSubcatView { return headerView.subcatView }
    var subcatCV: UICollectionView { return subcatView.collectionView }
    
    let productCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var itemWidth: CGFloat = (screenWidth-60) / 2
    private var itemHeight: CGFloat {
        let heightTxt = HomeProductCVCell.nameHeight + HomeProductCVCell.priceHeight + 20
        return itemWidth*imageHeightRatio + heightTxt + 10
    }
    private var isFirst = true
    
    var column = 2 //Số cột hiện tại
    
    var category: Category? //Danh mục hiện tại
    var selectedSubcategory = "" //Chọn danh mục phụ
    
    lazy var products: [Product] = [] //Tất cả sản phẩm đã lọc
    lazy var filterProducts: [Product] = [] //Đã lọc từ 'keyword'
    
    var isLoad = false //Tải lần đầu tiên
    var hud: HUD?
    private var searchTimer: Timer? //Tự động tìm kiếm theo từ khóa
    var keyword = "" //Từ khóa để tìm kiếm
    
    private var sortVC: SortVC?
    private var filterVC: FilterVC?
    
    var minPrice: Double = 0.0 //Lọc Theo giá
    var maxPrice: Double = 0.0 //Lọc Theo giá
    var selectedCat = "" //Lọc theo Category
    var selectedSort: SortModel? //Sắp xếp Products
    
    private var viewModel: CategoryViewAllViewModel!
    
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
            hud = HUD.hud(view)
            
            guard products.count == 0 else {
                return
            }
            
            delay(duration: 1.0) {
                self.viewModel.getProductsFromSubcategory()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTF.resignFirstResponder()
    }
}

// MARK: - Setups

extension CategoryViewAllVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = ""
        
        viewModel = CategoryViewAllViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - CollectionView
        productCV.setupCollectionView()
        productCV.contentInset = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        productCV.register(HomeProductCVCell.self, forCellWithReuseIdentifier: HomeProductCVCell.id)
        productCV.register(CategoryViewAllHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryViewAllHeaderView.id)
        productCV.dataSource = self
        productCV.delegate = self
        view.addSubview(productCV)
        
        //TODO: - Layout
        productCV.setupLayout(scrollDirection: .vertical, lineSpacing: 20.0, itemSpacing: 20.0)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            productCV.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            productCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productCV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        //TODO: - NoItemsLbl
        noItemsLbl = createNoItems(view: view)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.productCV.reloadData()
        }
    }
}

// MARK: - NavigationBar

extension CategoryViewAllVC {
    
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
        sortBtn.tag = 5
        sortBtn.delegate = self
        sortBtn.clipsToBounds = true
        sortView.addSubview(sortBtn)
        
        //TODO: - SearchView
        let searchW: CGFloat = screenWidth-(40*5)
        let searchView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: searchW, height: 40.0))
        searchView.clipsToBounds = true
        searchView.backgroundColor = .clear
        
        removeBtn.tag = 0
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
        if let text = tf.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }
            
            searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchWithKeyword), userInfo: text, repeats: false)
        }
        
        removeBtn.isHidden = tf.text?.count == 0
    }
    
    @objc private func searchWithKeyword(_ notif: Timer) {
        if let text = notif.userInfo as? String {
            keyword = text
        }
        
        searchByKeywork()
    }
    
    private func removeHidden(_ isHidden: Bool) {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.removeBtn.isHidden = isHidden
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Search By Keyword

extension CategoryViewAllVC {
    
    private func searchByKeywork() {
        //Lấy 'filterProducts' từ 'Filter' hoặc 'Sort'
        viewModel.setupFilterProducts()
        
        if keyword != "" {
            filterProducts = filterProductsByKeyword()
            viewModel.setupLayoutProductCV()
        }
    }
    
    func filterProductsByKeyword() -> [Product] {
        let searchPrs = filterProducts.filter({
            $0.name.lowercased().range(
                of: keyword.lowercased(),
                options: [.caseInsensitive, .diacriticInsensitive],
                range: nil,
                locale: .current) != nil ||
            $0.tags.contains(keyword.lowercased().folding(
                options: [.caseInsensitive, .diacriticInsensitive],
                locale: .current))
        })
        
        return searchPrs
    }
}

// MARK: - UpdateUI

extension CategoryViewAllVC {
    
    func updateUI() {
        if let category = category {
            bannerView.isHidden = false
            subcatView.isHidden = false
            titleView.isHidden = false
            
            DownloadImage.shared.downloadImage(link: category.bannerURL) { image in
                self.bannerView.bannerImageView.image = image
            }
            
            titleView.titleLbl.text = category.category
            titleView.subtitleLbl.text = "\(appDL.allProducts.filter({ $0.category == category.category }).count) items"
            titleView.updateTintColorForBtn(column)
        }
    }
}

// MARK: - ButtonAnimationDelegate

extension CategoryViewAllVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //SearchRemove
            searchTimer?.invalidate()
            searchTimer = nil
            
            searchTF.text = ""
            searchTF.resignFirstResponder()
            
            keyword = ""
            removeHidden(true)
            searchByKeywork()
            
        } else if sender.tag == 1 { //Bag
            tabBarController?.selectedIndex = 2
            
        } else if sender.tag == 2 { //Filter
            searchTF.resignFirstResponder()
            
            filterVC?.removeFromParent()
            filterVC = nil
            
            filterVC = FilterVC()
            filterVC?.view.frame = kWindow.bounds
            filterVC?.products = products
            filterVC?.category = category
            filterVC?.delegate = self
            filterVC?.subcategory = selectedSubcategory
            filterVC?.minPrice = minPrice
            filterVC?.maxPrice = maxPrice
            filterVC?.selectedCat = selectedCat
            
            kWindow.addSubview(filterVC!.view)
            
        } else if sender.tag == 3 { //ThreeColumns
            column = 3
            titleView.updateTintColorForBtn(column)
            viewModel.setupLayoutProductCV()
            
        } else if sender.tag == 4 { //TwoColumns
            column = 2
            titleView.updateTintColorForBtn(column)
            viewModel.setupLayoutProductCV()
            
        } else if sender.tag == 5 { //Sort
            searchTF.resignFirstResponder()
            
            sortVC?.removeFromParent()
            sortVC = nil

            sortVC = SortVC()
            sortVC?.view.frame = kWindow.bounds
            sortVC?.delegate = self
            sortVC?.selected = selectedSort
            kWindow.addSubview(sortVC!.view)

            let rect = sortBtn.superview!.convert(sortBtn.frame, to: nil)
            sortVC?.setupViews(rect.origin.y + 50)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryViewAllVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subcatCV {
            return category?.subcategories.count ?? 0
            
        } else { //collectionView == productCV
            return filterProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subcatCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewAllSubcatCVCell.id, for: indexPath) as! CategoryViewAllSubcatCVCell
            viewModel.subcategoryCell(cell, indexPath: indexPath)
            return cell
            
        } else { //collectionView == productCV
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCVCell.id, for: indexPath) as! HomeProductCVCell
            viewModel.productCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == productCV && kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryViewAllHeaderView.id, for: indexPath) as! CategoryViewAllHeaderView
            
            self.headerView = headerView
            
            titleView.threeColumnsBtn.tag = 3
            titleView.threeColumnsBtn.delegate = self
            
            titleView.twoColumnsBtn.tag = 4
            titleView.twoColumnsBtn.delegate = self
            
            if isFirst {
                isFirst = false
                
                subcatView.setupDataSourceAndDelegate(dl: self)
                subcatView.layout.delegate = self
                
                if let category = category, selectedSubcategory != "",
                   let index = category.subcategories.firstIndex(where: { $0 == selectedSubcategory })
                {
                    DispatchQueue.main.async {
                        self.subcatCV.reloadData()
                        
                        let indexPath = IndexPath(item: index, section: 0)
                        self.subcatCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    }
                }
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryViewAllVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subcatCV {
            if let category = category {
                selectedSubcategory = category.subcategories[indexPath.item]
                subcatView.reloadData()
                
                DispatchQueue.main.async {
                    self.subcatCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
                
                minPrice = 0.0
                maxPrice = 0.0
                selectedCat = ""
                
                viewModel.getProductsFromSubcategory()
            }
            
        } else { //collectionView == productCV
            let product = filterProducts[indexPath.item]
            goToProductVC(viewController: self, product: product)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryViewAllVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subcatCV {
            return CGSize(width: 150.0, height: 50.0)
            
        } else { //collectionView == productCV
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionView {
            let bannerH: CGFloat = (screenWidth-40)*0.5 + 10
            let titleH: CGFloat = 50.0
            let subH: CGFloat = 50.0
            
            return CGSize(width: screenWidth, height: bannerH + titleH + subH)
        }
        
        return .zero
    }
}

// MARK: - UIScrollViewDelegate

extension CategoryViewAllVC: UIScrollViewDelegate {
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let defaultTop: CGFloat = 0.0
        var currentTop = defaultTop

        if offsetY < 0.0 {
            currentTop = offsetY
            bannerView.bannerHConstraint.constant = bannerView.bannerHeight - offsetY

        } else {
            bannerView.bannerHConstraint.constant = bannerView.bannerHeight
        }

        self.scrollView.cvTopConstraint.constant = currentTop + 20
    }
    */
}

// MARK: - CustomLayoutDelegate

extension CategoryViewAllVC: CustomLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath, cv: UICollectionView) -> CGSize {
        guard let category = category else {
            return .zero
        }
        
        let subcat = category.subcategories[indexPath.item]
        let width = subcat.estimatedTextRect(fontN: FontName.ppMedium, fontS: 18).width + 10
        return CGSize(width: width, height: 50.0)
    }
}

// MARK: - UITextFieldDelegate

extension CategoryViewAllVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTimer?.invalidate()
        searchTimer = nil
        
        var txt = ""
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            txt = text
        }
        
        removeHidden(textField.text?.count == 0 || txt == "")
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            keyword = text
            
        } else {
            keyword = ""
            textField.text = ""
        }
        
        searchByKeywork()
    }
}

// MARK: - FilterVCDelegate

extension CategoryViewAllVC: FilterVCDelegate {
    
    func applyDidTap(vc: FilterVC, minPrice: Double, maxPrice: Double, selectedCat: String) {
        vc.removeHandler {
            self.minPrice = minPrice
            self.maxPrice = maxPrice
            self.selectedCat = selectedCat
            
            self.viewModel.setupFilterProducts()
        }
    }
}

// MARK: - SortVCDelegate

extension CategoryViewAllVC: SortVCDelegate {
    
    func selectedFilter(_ vc: SortVC, selected: SortModel) {
        vc.removeHandler {
            self.selectedSort = selected
            self.viewModel.sortBy()
            self.reloadData()
        }
    }
}
