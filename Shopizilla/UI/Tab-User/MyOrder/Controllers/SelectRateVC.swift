//
//  SelectRateVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/05/2022.
//

import UIKit

protocol SelectRateVCDelegate: AnyObject {
    func selectRate(_ vc: SelectRateVC, shopping: ShoppingCart)
}

class SelectRateVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: SelectRateVCDelegate?
    
    let containerView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var shoppings: [ShoppingCart] = []
    
    private var cvHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let itemH = OrderHistoryCVCell.centerH + 10
        var cvHeight = CGFloat(shoppings.count) * itemH
        cvHeight = cvHeight >= screenWidth ? screenWidth : cvHeight
        
        cvHeightConstraint.constant = cvHeight
    }
}

//MARK: - Setups

extension SelectRateVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        containerView.backgroundColor = .black.withAlphaComponent(0.0)
        view.addSubview(containerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
        
        //TODO: - CollectionView
        collectionView.setupCollectionView(.white)
        collectionView.register(SelectRateCVCell.self, forCellWithReuseIdentifier: SelectRateCVCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.setupLayout(scrollDirection: .vertical)
        
        cvHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: screenWidth)
        cvHeightConstraint.isActive = true
        
        collectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //TODO: - Animate
        collectionView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        
        UIView.animate(withDuration: 0.5) {
            self.containerView.backgroundColor = .black.withAlphaComponent(0.8)
            self.collectionView.transform = .identity
        }
    }
    
    @objc private func removeDidTap(_ sender: UIGestureRecognizer) {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.collectionView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            
        } completion: { (_) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension SelectRateVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectRateCVCell.id, for: indexPath) as! SelectRateCVCell
        let shopping = shoppings[indexPath.item]
        
        cell.coverImageView.image = nil
        cell.tag = indexPath.item
        
        DownloadImage.shared.downloadImage(link: shopping.imageURL) { image in
            if cell.tag == indexPath.item {
                cell.coverImageView.image = image
            }
        }
        
        cell.nameLbl.text = shopping.name + " - \(shopping.category.uppercased()) - \(shopping.prID)"
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SelectRateVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopping = shoppings[indexPath.item]
        delegate?.selectRate(self, shopping: shopping)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SelectRateVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: OrderHistoryCVCell.centerH + 10)
    }
}
