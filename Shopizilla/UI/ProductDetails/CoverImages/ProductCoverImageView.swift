//
//  ProductCoverImageView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 24/04/2022.
//

import UIKit

class ProductCoverImageView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let pageControl = UIPageControl()
    
    let itemWidth: CGFloat = screenWidth//-60
    private var itemHeight: CGFloat {
        return itemWidth*imageHeightRatio + 10
    }
    private var cvHeight: CGFloat {
        return itemHeight
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

extension ProductCoverImageView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: cvHeight).isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.register(ProductCoverImageCVCell.self, forCellWithReuseIdentifier: ProductCoverImageCVCell.id)
        addSubview(collectionView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        
        //TODO: - PageControl
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionView.heightAnchor.constraint(equalToConstant: itemHeight),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -30.0),
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
        isHidden = product.imageURLs.count == 0
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            vc.view.layoutIfNeeded()
        }
    }
}
