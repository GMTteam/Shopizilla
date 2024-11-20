//
//  HomeCategoriesTopView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 17/04/2022.
//

import UIKit

class HomeCategoriesTopView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = SubcategoryLayout()
    
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

extension HomeCategoriesTopView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.register(HomeCategoriesTopCVCell.self, forCellWithReuseIdentifier: HomeCategoriesTopCVCell.id)
        addSubview(collectionView)
        
        //TODO: - Layout
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 0.0
        layout.cellPadding = 20.0
        collectionView.collectionViewLayout = layout
        
        //TODO: - NSLayoutConstraint
        collectionView.setupConstraint(superView: self)
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
}
