//
//  FilterVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 19/04/2022.
//

import UIKit

protocol FilterVCDelegate: AnyObject {
    func applyDidTap(vc: FilterVC, minPrice: Double, maxPrice: Double, selectedCat: String)
}

class FilterVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceTitleLbl: UILabel!
    @IBOutlet weak var rangeValueLbl: UILabel!
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    @IBOutlet weak var categoryTitleView: UIView!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomView: UIView!
    
    //MARK: - Properties
    weak var delegate: FilterVCDelegate?
    
    private let cancelBtn = ButtonAnimation()
    private let applyBtn = ButtonAnimation()
    private let layout = SubcategoryLayout()
    
    var category: Category? //Truy cập từ Danh mục ko phải 'New Arrivals'
    var subcategory = "" //Subcategory có phải là 'New Arrivals'
    var fromSearch = false
    
    lazy var products: [Product] = []
    lazy var categories: [String] = [
        CategoryKey.Accessories.rawValue,
        CategoryKey.Men.rawValue,
        CategoryKey.Women.rawValue,
        SubcategoryKey.TShirts.rawValue,
        SubcategoryKey.Sweatshirts.rawValue,
        SubcategoryKey.Hoodies.rawValue,
        SubcategoryKey.Shirts.rawValue,
        SubcategoryKey.Jackets.rawValue,
        SubcategoryKey.Jeans.rawValue,
        SubcategoryKey.Pants.rawValue,
        SubcategoryKey.Shorts.rawValue
    ]
    
    var minPrice: Double = 0.0
    var maxPrice: Double = 0.0
    var selectedCat = ""
    
    private let countryCode = CurrencyModel.shared.countryCode
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Đến từ một danh mục phụ. Màn hình Search
        if subcategory != "" && category == nil {
            categories = [subcategory]
            selectedCat = subcategory
            reloadData()
        }
        
        //Truy cập từ Category (Men, Women, Accessories). Màn hình Shop
        if let category = category {
            //Thay đổi Danh Mục
            categories = category.subcategories
            
            //Xóa New Arrivals
            if let index = categories.firstIndex(where: {
                $0 == CategoryKey.NewArrivals.rawValue
            }) {
                categories.remove(at: index)
            }
            
            let subNewArrival = subcategory == CategoryKey.NewArrivals.rawValue
            
            //Nếu ko phải là New Arrivals
            if !subNewArrival {
                if !fromSearch {
                    categories = [subcategory]
                }
                
                selectedCat = subcategory
            }
            
            reloadData()
        }
        
        setupMinMaxValue()
    }
    
    //MARK: - IBAction
    @IBAction func doubleSliderChanged(_ sender: RangeSeekSlider) {
        let min = Double(round(sender.selectedMinValue) * (countryCode == .VN ? 1000 : 1))
        let max = Double(round(sender.selectedMaxValue) * (countryCode == .VN ? 1000 : 1))
        
        minPrice = min
        maxPrice = max
        
        if min == max {
            rangeValueLbl.text = min.formattedCurrency
            
        } else {
            rangeValueLbl.text = "\(min.formattedCurrency) - \(max.formattedCurrency)"
        }
    }
}

//MARK: - Setups

extension FilterVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.backgroundColor = .black.withAlphaComponent(0.0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        containerView.addGestureRecognizer(tap)
        
        //TODO: - ResetBtn
        let cancelW = "Cancel".estimatedTextRect(fontN: FontName.ppBold, fontS: 16).width + 40
        setupBtn(btn: cancelBtn, txt: "Cancel".localized(), fColor: .black, bgColor: .clear, tag: 0)
        cancelBtn.widthAnchor.constraint(equalToConstant: cancelW).isActive = true
        
        //TODO: - ApplyBtn
        setupBtn(btn: applyBtn, txt: "Apply".localized(), fColor: .white, bgColor: .black, tag: 1)
        applyBtn.widthAnchor.constraint(equalToConstant: screenWidth-60-cancelW).isActive = true
        
        //TODO: - UIStackView
        let btnSV = createStackView(spacing: 20.0, distribution: .fill, axis: .horizontal, alignment: .center)
        btnSV.addArrangedSubview(cancelBtn)
        btnSV.addArrangedSubview(applyBtn)
        bottomView.addSubview(btnSV)
        
        //TODO: - PopupView
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 25.0
        popupView.transform = CGAffineTransform(translationX: 0.0, y: screenWidth)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            btnSV.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            btnSV.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
        ])
        
        //TODO: - Animate
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = .black.withAlphaComponent(0.8)
            self.popupView.transform = .identity
        }
        
        //TODO: - UIStackView
        stackView.spacing = 0.0
        stackView.setCustomSpacing(10.0, after: naviView)
        stackView.setCustomSpacing(20.0, after: priceSlider)
        stackView.setCustomSpacing(20.0, after: categoryView)
        
        //TODO: - CollectionView
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.register(FilterCVCell.self, forCellWithReuseIdentifier: FilterCVCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //TODO: - Layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 0.0
        layout.cellPadding = 10.0
        layout.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
    private func setupBtn(btn: ButtonAnimation, txt: String, fColor: UIColor, bgColor: UIColor, tag: Int) {
        setupTitleForBtn(btn, txt: txt, bgColor: bgColor, fgColor: fColor)
        btn.clipsToBounds = true
        btn.delegate = self
        btn.tag = tag
        btn.layer.cornerRadius = 25.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    @objc private func removeDidTap(_ sender: UIGestureRecognizer) {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.popupView.transform = CGAffineTransform(translationX: 0.0, y: screenWidth)
            
        } completion: { (_) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupMinMaxValue() {
        let prices = products.map({ $0.price * ((100 - $0.saleOff)/100) })
        let min = prices.min() ?? 0.0
        let max = prices.max() ?? 0.0
        
        priceSlider.minValue = CGFloat(Int(min / (countryCode == .VN ? 1000 : 1)))
        priceSlider.maxValue = CGFloat(Int(max / (countryCode == .VN ? 1000 : 1)))
        
        let selectedMin = minPrice == 0 ? min : minPrice
        let selectedMax = maxPrice == 0 ? max : maxPrice
        
        priceSlider.selectedMinValue = CGFloat(Int(selectedMin / (countryCode == .VN ? 1000 : 1)))
        priceSlider.selectedMaxValue = CGFloat(Int(selectedMax / (countryCode == .VN ? 1000 : 1)))
        
        if selectedMin == selectedMax {
            rangeValueLbl.text = selectedMin.formattedCurrency
            
        } else {
            rangeValueLbl.text = "\(selectedMin.formattedCurrency) - \(selectedMax.formattedCurrency)"
        }
        
        priceSlider.isHidden = selectedMin == selectedMax
        scrollCVTo()
    }
    
    private func scrollCVTo() {
        if let index = categories.firstIndex(of: selectedCat) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
            }
            
        } else {
            collectionView.reloadData()
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension FilterVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Cancel
            removeHandler {}
            
        } else if sender.tag == 1 { //Apply
            if minPrice == 0.0 {
                minPrice = Double(round(priceSlider.selectedMinValue) * (countryCode == .VN ? 1000 : 1))
            }
            
            if maxPrice == 0.0 {
                maxPrice = Double(round(priceSlider.selectedMaxValue) * (countryCode == .VN ? 1000 : 1))
            }
            
            delegate?.applyDidTap(vc: self, minPrice: minPrice, maxPrice: maxPrice, selectedCat: selectedCat)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension FilterVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCVCell.id, for: indexPath) as! FilterCVCell
        let category = categories[indexPath.item]
        
        cell.titleLbl.text = category
        cell.isSelect = selectedCat == category
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension FilterVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard categories.count > 1 else {
            return
        }
        
        let old = selectedCat
        selectedCat = categories[indexPath.item]
        
        if selectedCat == old {
            selectedCat = ""
            reloadData()
            
            return
        }
        
        if selectedCat != "" {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FilterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 44.0)
    }
}

//MARK: - CustomLayoutDelegate

extension FilterVC: CustomLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath, cv: UICollectionView) -> CGSize {
        let width = categories[indexPath.item].estimatedTextRect(fontN: FontName.ppSemiBold, fontS: 16).width + 40
        return CGSize(width: width, height: 44.0)
    }
}
