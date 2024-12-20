//
//  NewArrivalViewAllVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 17/04/2022.
//

import UIKit

class NewArrivalViewAllVC: UIViewController {

    // MARK: - Properties
    private let filterBtn = ButtonAnimation()
    private let bagBtn = ButtonAnimation()
    private let badgeLbl = UILabel()
    private let sortBtn = ButtonAnimation()
    private let removeBtn = ButtonAnimation()
    private let searchTF = UITextField()
    
    var noItemsLbl: UILabel!
    
    let separatorView = UIView()
    
    private var headerView = NewArrivalViewAllHeaderView()
    private var titleView: NewArrivalViewAllTitleView { return headerView.titleView }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var itemWidth: CGFloat = (screenWidth-60) / 2
    private var itemHeight: CGFloat {
        let heightTxt = HomeProductCVCell.nameHeight + HomeProductCVCell.priceHeight + 20
        return itemWidth*imageHeightRatio + heightTxt + 10
    }
    
    var column = 2 //Số cột hiện tại
    
    lazy var products: [Product] = [] //Tất cả sản phẩm đã lọc
    lazy var filterProducts: [Product] = [] //Đã lọc từ 'keyword'
    
    private var isLoad = false //Tải lần đầu tiên
    var hud: HUD?
    private var searchTimer: Timer? //Tự động tìm kiếm theo từ khóa
    var keyword = "" //Từ khóa để tìm kiếm
    
    private var sortVC: SortVC?
    private var filterVC: FilterVC?
    
    var minPrice: Double = 0.0 //Lọc Theo giá
    var maxPrice: Double = 0.0 //Lọc Theo giá
    var selectedCat = "" //Lọc theo Category
    var selectedSort: SortModel? //Sắp xếp Products
    
    private var viewModel: NewArrivalViewAllViewModel!
    
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

            viewModel.getNewArrivals()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTF.resignFirstResponder()
    }
}

// MARK: - Setups

extension NewArrivalViewAllVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = ""
        
        viewModel = NewArrivalViewAllViewModel(vc: self)
        
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

extension NewArrivalViewAllVC {
    
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

extension NewArrivalViewAllVC {
    
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

extension NewArrivalViewAllVC {
    
    func updateUI() {
        collectionView.isHidden = false
        
        titleView.isHidden = false
        titleView.titleLbl.text = CategoryKey.NewArrivals.rawValue
        titleView.subtitleLbl.text = "\(products.count) items"
        titleView.updateTintColorForBtn(column)
    }
}

// MARK: - ButtonAnimationDelegate

extension NewArrivalViewAllVC: ButtonAnimationDelegate {
    
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
            filterVC?.delegate = self
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

extension NewArrivalViewAllVC: UICollectionViewDataSource {
    
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

extension NewArrivalViewAllVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = filterProducts[indexPath.item]
        goToProductVC(viewController: self, product: product)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewArrivalViewAllVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50.0)
    }
}

// MARK: - UIScrollViewDelegate

extension NewArrivalViewAllVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diffH = scrollView.contentSize.height - scrollView.contentOffset.y
        let pull = abs(diffH - scrollView.bounds.height)
        
        if Int(pull) <= 0 && viewModel.isLoadMore {
            //viewModel.isLoadMore = false
            //viewModel.loadMoreNewArrivals()
        }
    }
}

// MARK: - UITextFieldDelegate

extension NewArrivalViewAllVC: UITextFieldDelegate {
    
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

extension NewArrivalViewAllVC: FilterVCDelegate {
    
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

extension NewArrivalViewAllVC: SortVCDelegate {
    
    func selectedFilter(_ vc: SortVC, selected: SortModel) {
        vc.removeHandler {
            self.selectedSort = selected
            self.viewModel.sortBy()
            self.reloadData()
        }
    }
}
