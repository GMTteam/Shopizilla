//
//  HomeBannerView.swift
//  Shopizilla
//
//  Created by Anh Tu on 13/04/2022.
//

import UIKit

class HomeBannerView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = InfiniteLayout()
    
    var heightConstraint: NSLayoutConstraint!
    
    //Chiều cao UICollectionView
    var itemWidth: CGFloat = screenWidth-40
    var cvHeight: CGFloat = (screenWidth-40)*(252/790)
    
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

extension HomeBannerView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: cvHeight + 40)
        heightConstraint.isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.register(HomeBannerCVCell.self, forCellWithReuseIdentifier: HomeBannerCVCell.id)
        addSubview(collectionView)
        
        //TODO: - Layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 0.0
        layout.isScale = false
        
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = .fast
        
        //TODO: - NSLayoutConstraint
        collectionView.setupConstraint(superView: self, topC: 20.0, bottomC: -20.0)
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
    
    var isMultiplier: Int {
        return InfiniteDataSource.multiplier(estimatedItemSize: collectionView.bounds.size, enabled: layout.isEnabled)
    }
    
    func indexPath(_ indexPath: IndexPath, count: Int) -> IndexPath {
        return InfiniteDataSource.indexPath(from: indexPath, numberOfSections: 1, numberOfItems: count)
    }
    
    ///constant: chiều cao của HomeBannerView
    func setupHeightConstraint(vc: UIViewController, count: Int) {
        heightConstraint.constant = cvHeight + 40
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.isHidden = count == 0
            vc.view.layoutIfNeeded()
        }
    }
}
