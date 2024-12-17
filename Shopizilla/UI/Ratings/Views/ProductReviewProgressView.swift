//
//  ProductReviewProgressView.swift
//  Shopizilla
//
//  Created by Anh Tu on 18/05/2022.
//

import UIKit

class ProductReviewProgressView: UIView {
    
    //MARK: - Properties
    let starImageView = UIImageView()
    let progressBGView = UIView()
    let progressFillView = UIView()
    let numLbl = UILabel()
    
    var prWidthAnchor: NSLayoutConstraint!
    
    private let starH: CGFloat = 13.0
    private var starW: CGFloat {
        return starH*(380/72)
    }
    private let numW = "1000".estimatedTextRect(fontN: FontName.ppRegular, fontS: 13.0).width
    private let prH: CGFloat = 15.0
    var prW: CGFloat {
        return screenWidth-40-20-starW-numW
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

extension ProductReviewProgressView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        //TODO: - StarImageView
        starImageView.clipsToBounds = true
        starImageView.contentMode = .scaleAspectFit
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: starW).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: starH).isActive = true
        
        //TODO: - ProgressBGView
        progressBGView.clipsToBounds = true
        progressBGView.backgroundColor = separatorColor
        progressBGView.layer.cornerRadius = prH/2
        progressBGView.translatesAutoresizingMaskIntoConstraints = false
        progressBGView.heightAnchor.constraint(equalToConstant: prH).isActive = true
        progressBGView.widthAnchor.constraint(equalToConstant: prW).isActive = true
        
        //TODO: - NumLbl
        numLbl.font = UIFont(name: FontName.ppRegular, size: 13.0)
        numLbl.textColor = .black
        numLbl.textAlignment = .right
        numLbl.translatesAutoresizingMaskIntoConstraints = false
        numLbl.widthAnchor.constraint(equalToConstant: numW).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(starImageView)
        stackView.addArrangedSubview(progressBGView)
        stackView.addArrangedSubview(numLbl)
        addSubview(stackView)
        
        //TODO: - ProgressFillView
        progressFillView.clipsToBounds = true
        progressFillView.backgroundColor = defaultColor
        progressFillView.translatesAutoresizingMaskIntoConstraints = false
        progressBGView.addSubview(progressFillView)
        
        prWidthAnchor = progressFillView.widthAnchor.constraint(equalToConstant: 0.0)
        prWidthAnchor.isActive = true
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            progressFillView.topAnchor.constraint(equalTo: progressBGView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressBGView.leadingAnchor),
            progressFillView.heightAnchor.constraint(equalToConstant: prH),
        ])
    }
    
    func updateUI(imgName: String, rating: Int) {
        starImageView.image = UIImage(named: imgName)
        numLbl.text = "\(rating)"
        prWidthAnchor.constant = Double(rating) * (prW/1000)
    }
}
