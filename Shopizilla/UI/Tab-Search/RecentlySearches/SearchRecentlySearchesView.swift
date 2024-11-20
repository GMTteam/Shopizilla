//
//  SearchRecentlySearchesView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchRecentlySearchesView: UIView {
    
    //MARK: - Properties
    let topView = UIView()
    let titleLbl = UILabel()
    let removeAllBtn = ButtonAnimation()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = SearchLayout()
    
    let topHeight: CGFloat = 60.0
    var heightConstraint: NSLayoutConstraint!
    
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

extension SearchRecentlySearchesView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: topHeight + 50)
        heightConstraint.isActive = true
        
        //TODO: - TopView
        topView.clipsToBounds = true
        topView.backgroundColor = .clear
        topView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topView)
        
        //TODO: - DesTitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 18.0)
        titleLbl.text = "Recently Searches".localized()
        titleLbl.textColor = .black
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(titleLbl)
        
        //TODO: - RemoveAllBtn
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppMedium, size: 16.0)!,
            .foregroundColor: UIColor.black
        ]
        let attr = NSMutableAttributedString(string: "Remove All".localized(), attributes: att)
        removeAllBtn.setAttributedTitle(attr, for: .normal)
        removeAllBtn.clipsToBounds = true
        removeAllBtn.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(removeAllBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.widthAnchor.constraint(equalToConstant: screenWidth),
            topView.heightAnchor.constraint(equalToConstant: topHeight),
            
            titleLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20.0),
            
            removeAllBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            removeAllBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20.0),
        ])
        
        //TODO: - CollectionView
        collectionView.setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        collectionView.isScrollEnabled = false
        collectionView.register(SearchRecentlySearchesCVCell.self, forCellWithReuseIdentifier: SearchRecentlySearchesCVCell.id)
        addSubview(collectionView)
        
        //TODO: - Layout
        layout.scrollDirection = .vertical
        layout.contentPadding = SpacingMode(horizontal: 10.0, vertical: 10.0)
        layout.cellPadding = 10.0
        collectionView.collectionViewLayout = layout
        
        //TODO: - NSLayoutConstraint
        collectionView.setupConstraint(superView: self, topC: topHeight)
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
    
    func updateHeight(_ vc: UIViewController, keywords: [String]) {
        isHidden = keywords.count == 0
        vc.view.layoutIfNeeded()
        
        let maxHeight: CGFloat = 35.0
        let totalSpace = CGFloat(keywords.count-1) * 10
        let totalWidth = keywords.map({
            $0.estimatedTextRect(fontN: FontName.ppRegular, fontS: 16.0).width + 30 + maxHeight
        }).reduce(0, +)
        let sum = totalSpace + totalWidth
        
        var height: CGFloat = maxHeight + 10
        let maxW = screenWidth-40
        
        if sum > maxW {
            let i = (sum/maxW) + 1
            height = (i * maxHeight) + ((i+1) * 10)
        }
        
        UIView.animate(withDuration: 0.33) {
            self.heightConstraint.constant = height + self.topHeight
            vc.view.layoutIfNeeded()
        }
    }
}
