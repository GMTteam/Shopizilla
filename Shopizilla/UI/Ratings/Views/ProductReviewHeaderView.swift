//
//  ProductReviewHeaderView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/05/2022.
//

import UIKit

class ProductReviewHeaderView: UIView {
    
    //MARK: - Properties
    let avgLbl = UILabel()
    let starImageView = UIImageView()
    let reviewLbl = UILabel()
    
    let prView_1 = ProductReviewProgressView()
    let prView_2 = ProductReviewProgressView()
    let prView_3 = ProductReviewProgressView()
    let prView_4 = ProductReviewProgressView()
    let prView_5 = ProductReviewProgressView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension ProductReviewHeaderView {
    
    func setupViews() {
        //TODO: - AvgLbl
        avgLbl.font = UIFont(name: FontName.ppSemiBold, size: 30.0)
        avgLbl.textColor = .black
        
        //TODO: - StarImageView
        starImageView.clipsToBounds = true
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: 30*(380/72)).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //TODO: - UIStackView
        let starSV = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        starSV.addArrangedSubview(avgLbl)
        starSV.addArrangedSubview(starImageView)
        
        //TODO: - ReviewLbl
        reviewLbl.font = UIFont(name: FontName.ppRegular, size: 18.0)
        reviewLbl.textColor = .black
        reviewLbl.textAlignment = .center
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(starSV)
        stackView.setCustomSpacing(0.0, after: starSV)
        stackView.addArrangedSubview(reviewLbl)
        stackView.setCustomSpacing(20.0, after: reviewLbl)
        stackView.addArrangedSubview(prView_5)
        stackView.addArrangedSubview(prView_4)
        stackView.addArrangedSubview(prView_3)
        stackView.addArrangedSubview(prView_2)
        stackView.addArrangedSubview(prView_1)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func updateUI(avg: Double,
                  ratingImg: UIImage?,
                  review: Int,
                  rating1: Int,
                  rating2: Int,
                  rating3: Int,
                  rating4: Int,
                  rating5: Int) {
        avgLbl.text = "\(avg)"
        starImageView.image = ratingImg
        reviewLbl.text = "\(kText(Double(review))) " + "reviews".localized().lowercased()
        
        prView_1.updateUI(imgName: "icon-rating1", rating: rating1)
        prView_2.updateUI(imgName: "icon-rating2", rating: rating2)
        prView_3.updateUI(imgName: "icon-rating3", rating: rating3)
        prView_4.updateUI(imgName: "icon-rating4", rating: rating4)
        prView_5.updateUI(imgName: "icon-rating5", rating: rating5)
    }
}
