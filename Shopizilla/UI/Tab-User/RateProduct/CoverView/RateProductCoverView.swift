//
//  RateProductCoverView.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

class RateProductCoverView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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

extension RateProductCoverView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.register(RateCoverImageCVCell.self, forCellWithReuseIdentifier: RateCoverImageCVCell.id)
        collectionView.register(RateAddCoverImageCVCell.self, forCellWithReuseIdentifier: RateAddCoverImageCVCell.id)
        addSubview(collectionView)
        
        collectionView.setupLayout(scrollDirection: .horizontal)
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
