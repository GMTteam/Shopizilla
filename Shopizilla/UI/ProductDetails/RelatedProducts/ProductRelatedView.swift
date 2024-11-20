//
//  ProductRelatedView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/04/2022.
//

import UIKit

class ProductRelatedView: UIView {
    
    //MARK: - Properties
    let topView = UIView()
    let titleLbl = UILabel()
    let separatorView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let itemWidth: CGFloat = (screenWidth-70) / 2.2
    private var itemHeight: CGFloat {
        let heightTxt = HomeProductCVCell.nameHeight + HomeProductCVCell.priceHeight + 20
        return itemWidth*imageHeightRatio + heightTxt + 10
    }
    private var cvHeight: CGFloat {
        return itemHeight + 60
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

extension ProductRelatedView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: cvHeight).isActive = true
        
        //TODO: - TopView
        topView.clipsToBounds = true
        topView.backgroundColor = .clear
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        //TODO: - DesTitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 20.0)
        titleLbl.text = "Related Products".localized()
        titleLbl.textColor = .black
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(titleLbl)
        
        titleLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20.0).isActive = true
        
        //TODO: - SeparatorTopView
        setupSeparatorView(parentView: topView, separatorView: separatorView)
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.register(HomeProductCVCell.self, forCellWithReuseIdentifier: HomeProductCVCell.id)
        
        let layout = CenterScrollLayout()
        layout.isRelated = true
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 0.0
        
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = .fast
        
        //TODO: - NSLayoutConstraint
        collectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(collectionView)
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
    
    func updateHeight(_ vc: UIViewController, count: Int) {
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.isHidden = count == 0
            vc.view.layoutIfNeeded()
        }
    }
}
