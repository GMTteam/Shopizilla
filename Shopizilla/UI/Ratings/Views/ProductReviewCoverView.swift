//
//  ProductReviewCoverView.swift
//  Shopizilla
//
//  Created by Anh Tu on 18/05/2022.
//

import UIKit

class ProductReviewCoverView: UIView {
    
    //MARK: - Properties
    let coverImageView_1 = UIImageView()
    let coverImageView_2 = UIImageView()
    let moreBtn = ButtonAnimation()
    
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

extension ProductReviewCoverView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        let coverW: CGFloat = 50.0
        let cornerR: CGFloat = 10.0
        
        widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        heightAnchor.constraint(equalToConstant: coverW).isActive = true
        
        //TODO: - CoverImageView_1
        coverImageView_1.clipsToBounds = true
        coverImageView_1.contentMode = .scaleAspectFill
        coverImageView_1.layer.cornerRadius = cornerR
        coverImageView_1.translatesAutoresizingMaskIntoConstraints = false
        coverImageView_1.widthAnchor.constraint(equalToConstant: coverW).isActive = true
        coverImageView_1.heightAnchor.constraint(equalToConstant: coverW).isActive = true
        
        //TODO: - CoverImageView_2
        coverImageView_2.clipsToBounds = true
        coverImageView_2.contentMode = .scaleAspectFill
        coverImageView_2.layer.cornerRadius = cornerR
        coverImageView_2.translatesAutoresizingMaskIntoConstraints = false
        coverImageView_2.widthAnchor.constraint(equalToConstant: coverW).isActive = true
        coverImageView_2.heightAnchor.constraint(equalToConstant: coverW).isActive = true
        
        //TODO: - MoreBtn
        let txt = "Load more".localized()
        let moreW = txt.estimatedTextRect(fontN: FontName.ppBold, fontS: 12.0).width+20
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 13.0)!,
            .foregroundColor: UIColor.black
        ]
        let attr = NSMutableAttributedString(string: txt, attributes: att)
        attr.addAttribute(.underlineStyle, value: 2.0, range: NSRange(location: 0, length: attr.length))
        
        moreBtn.setAttributedTitle(attr, for: .normal)
        moreBtn.clipsToBounds = true
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.widthAnchor.constraint(equalToConstant: moreW).isActive = true
        moreBtn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(coverImageView_1)
        stackView.addArrangedSubview(coverImageView_2)
        stackView.addArrangedSubview(moreBtn)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
