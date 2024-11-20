//
//  ProductSizeView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 25/04/2022.
//

import UIKit

class ProductSizeView: UIView {
    
    //MARK: - Properties
    let separatorView = UIView()
    let titleLbl = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let titleHeight: CGFloat = 80.0
    let desHeight: CGFloat = 50.0
    
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

extension ProductSizeView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        
        //TODO: - DesTitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 20.0)
        titleLbl.textColor = .black
        
        //TODO: - SeparatorTopView
        setupSeparatorView(parentView: self, separatorView: separatorView)
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.register(ProductSizeCVCell.self, forCellWithReuseIdentifier: ProductSizeCVCell.id)
        
        collectionView.setupLayout(scrollDirection: .horizontal)
        collectionView.heightAnchor.constraint(equalToConstant: desHeight).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(collectionView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            
            separatorView.topAnchor.constraint(equalTo: topAnchor),
        ])
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
    
    func updateHeight(_ vc: UIViewController, product: Product) {
        titleLbl.text = product.sizes.count > 1 ? "Sizes".localized() : "Size".localized()
        
        isHidden = product.sizes.count == 0
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            vc.view.layoutIfNeeded()
        }
    }
}
