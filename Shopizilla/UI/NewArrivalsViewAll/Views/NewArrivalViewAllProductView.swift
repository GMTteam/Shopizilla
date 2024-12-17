//
//  NewArrivalViewAllProductView.swift
//  Shopizilla
//
//  Created by Anh Tu on 18/04/2022.
//

import UIKit

class NewArrivalViewAllProductView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var itemWidth: CGFloat = (screenWidth-60) / 2
    var itemHeight: CGFloat {
        let heightTxt = HomeProductCVCell.nameHeight + HomeProductCVCell.priceHeight + 20
        return itemWidth*imageHeightRatio + heightTxt + 10
    }
    var productHConstraint: NSLayoutConstraint!
    
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

extension NewArrivalViewAllProductView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        productHConstraint = heightAnchor.constraint(equalToConstant: 0.0)
        productHConstraint.isActive = true
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.isScrollEnabled = false
        collectionView.register(HomeProductCVCell.self, forCellWithReuseIdentifier: HomeProductCVCell.id)
        addSubview(collectionView)
        
        //TODO: - Layout
        collectionView.setupLayout(scrollDirection: .vertical, lineSpacing: 20.0, itemSpacing: 20.0)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
    
    ///count: Số lượng của tất cả sản phẩm hiện tại
    ///column: Số cột mong muốn
    func setupHeightConstraint(vc: UIViewController, isEffect: Bool = true, count: Int, column: Int) {
        isHidden = false
        vc.view.layoutIfNeeded()
        
        let i = Double(count) / Double(column) //Chia để lấy giá trị sau dấu phẩy
        let j = count / column
        let k = i > Double(j) ? j + 1 : j
        let height = (itemHeight+20) * CGFloat(k)
        
        productHConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        if isEffect {
            UIView.animate(withDuration: 0.33) {
                vc.view.layoutIfNeeded()
            }
        }
    }
}
