//
//  HomeCategoriesView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 17/04/2022.
//

import UIKit

class HomeCategoriesView: UIView {
    
    //MARK: - Properties
    let topView = HomeCategoriesTopView()
    let viewAllBtn = ButtonAnimation()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let itemWidth: CGFloat = (screenWidth-70) / 2.2
    private var itemHeight: CGFloat {
        let heightTxt = HomeProductCVCell.nameHeight + HomeProductCVCell.priceHeight + 20
        return itemWidth*imageHeightRatio + heightTxt + 10
    }
    private var cvHeight: CGFloat {
        return itemHeight + 60 + 30 + 50 + 20
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension HomeCategoriesView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: cvHeight).isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.register(HomeProductCVCell.self, forCellWithReuseIdentifier: HomeProductCVCell.id)
        
        let layout = CenterScrollLayout()
        layout.isCategories = true
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 0.0
        
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = .fast
        
        //TODO: - NSLayoutConstraint
        collectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        //TODO: - ViewAllBtn
        setupTitleForBtn(viewAllBtn, txt: "View All".localized(), bgColor: defaultColor, fgColor: .white)
        viewAllBtn.clipsToBounds = true
        viewAllBtn.layer.cornerRadius = 25.0
        viewAllBtn.translatesAutoresizingMaskIntoConstraints = false
        viewAllBtn.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        viewAllBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(topView)
        stackView.setCustomSpacing(30.0, after: topView)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(viewAllBtn)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        stackView.setupConstraint(superView: self)
    }
    
    func setupDataSourceAndDelegate(dl: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.dataSource = dl
        collectionView.delegate = dl
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupHeightConstraint(vc: UIViewController, count: Int) {
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.isHidden = count == 0
            vc.view.layoutIfNeeded()
        }
    }
}
