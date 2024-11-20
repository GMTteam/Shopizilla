//
//  CategoryViewAllSubcatView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/04/2022.
//

import UIKit

class CategoryViewAllSubcatView: UIView {
    
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

extension CategoryViewAllSubcatView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.register(CategoryViewAllSubcatCVCell.self, forCellWithReuseIdentifier: CategoryViewAllSubcatCVCell.id)
        addSubview(collectionView)
        
        //TODO: - Layout
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 0.0
        layout.cellPadding = 10.0
        
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
