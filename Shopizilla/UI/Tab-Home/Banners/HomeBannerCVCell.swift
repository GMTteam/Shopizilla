//
//  HomeBannerCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 14/04/2022.
//

import UIKit

protocol HomeBannerCVCellDelegate: AnyObject {
    func shopNowDidTap(_ cell: HomeBannerCVCell)
}

class HomeBannerCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "HomeBannerCVCell"
    weak var delegate: HomeBannerCVCellDelegate?
    
    let bannerImageView = UIImageView()
    let nameLbl = UILabel()
    let desLbl = UILabel()
    let shopNowBtn = ButtonAnimation()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch, alpha: 0.8)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isTouch { isTouch = true }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = superview {
            isTouch = frame.contains(touch.location(in: parent))
        }
    }
}

//MARK: - Configures

extension HomeBannerCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - BannerImageView
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 20.0
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bannerImageView)
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        nameLbl.textColor = .white
        nameLbl.numberOfLines = 2
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.widthAnchor.constraint(equalToConstant: (screenWidth-80)*0.6).isActive = true
        
        //TODO: - DesLbl
        desLbl.font = UIFont(name: FontName.ppRegular, size: 13.0)
        desLbl.textColor = .white
        desLbl.numberOfLines = 2
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        desLbl.widthAnchor.constraint(equalToConstant: (screenWidth-80)*0.6).isActive = true
        
        //TODO: - BannerImageView
        let shopTxt = "Show Now".localized()
        let shopW = shopTxt.estimatedTextRect(fontN: FontName.ppBold, fontS: 16.0).width + 10
        let shopH: CGFloat = 35.0
        
        let shopAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 13.0)!,
            .foregroundColor: UIColor.black
        ]
        let shopAttr = NSMutableAttributedString(string: shopTxt, attributes: shopAtt)
        
        shopNowBtn.setAttributedTitle(shopAttr, for: .normal)
        shopNowBtn.clipsToBounds = true
        shopNowBtn.layer.cornerRadius = shopH/2
        shopNowBtn.backgroundColor = .white
        shopNowBtn.delegate = self
        shopNowBtn.translatesAutoresizingMaskIntoConstraints = false
        shopNowBtn.widthAnchor.constraint(equalToConstant: shopW).isActive = true
        shopNowBtn.heightAnchor.constraint(equalToConstant: shopH).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 3.0, distribution: .fill, axis: .vertical, alignment: .leading)
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(desLbl)
        stackView.setCustomSpacing(15.0, after: desLbl)
        stackView.addArrangedSubview(shopNowBtn)
        contentView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        bannerImageView.setupConstraint(superView: contentView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension HomeBannerCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.shopNowDidTap(self)
    }
}
