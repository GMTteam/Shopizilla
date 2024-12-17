//
//  ProductReviewsView.swift
//  Shopizilla
//
//  Created by Anh Tu on 24/04/2022.
//

import UIKit

class ProductReviewsView: ViewAnimation {
    
    //MARK: - Properties
    let separatorView = UIView()
    let titleLbl = UILabel()
    let iconImageView = UIImageView()
    
    let starImageView = UIImageView()
    let avgLbl = UILabel()
    
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

extension ProductReviewsView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        //TODO: - SeparatorTopView
        setupSeparatorView(parentView: self, separatorView: separatorView)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 20.0)
        titleLbl.textColor = .black
        titleLbl.text = "Reviews".localized()
        
        //TODO: - StarImageView
        let starH: CGFloat = 13.0
        starImageView.clipsToBounds = true
        starImageView.contentMode = .scaleAspectFit
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: starH*(380/72)).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: starH).isActive = true
        
        //TODO: - AvgLbl
        avgLbl.font = UIFont(name: FontName.ppMedium, size: 13.0)
        avgLbl.textColor = .black
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(titleLbl)
        stackView.setCustomSpacing(10, after: titleLbl)
        stackView.addArrangedSubview(starImageView)
        stackView.addArrangedSubview(avgLbl)
        addSubview(stackView)
        
        //TODO: - IconImageView
        let imgW: CGFloat = 15.0
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(named: "icon-rightArrow")?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .black
        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            
            iconImageView.widthAnchor.constraint(equalToConstant: imgW),
            iconImageView.heightAnchor.constraint(equalToConstant: imgW),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
        ])
    }
    
    func updateUI(vc: UIViewController, setHidden: Bool, img: UIImage?, avgTxt: String) {
        isHidden = setHidden
        vc.view.layoutIfNeeded()
        
        starImageView.image = img
        avgLbl.text = "(" + "\(avgTxt) " + "reviews".localized() + ")"
        
        UIView.animate(withDuration: 0.5) {
            vc.view.layoutIfNeeded()
        }
    }
}

