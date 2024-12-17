//
//  ProductReviewTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 18/05/2022.
//

import UIKit

protocol ProductReviewTVCellDelegate: AnyObject {
    func coverDidTap(_ cell: ProductReviewTVCell, coverIndex: Int)
    func loadMoreDidTap(_ cell: ProductReviewTVCell)
}

class ProductReviewTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "ProductReviewTVCell"
    weak var delegate: ProductReviewTVCellDelegate?
    
    let timeLbl = UILabel()
    
    let avatarImageView = UIImageView()
    let nameLbl = UILabel()
    let starImageView = UIImageView()
    
    let desLbl = UILabel()
    let coverView = ProductReviewCoverView()
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch, alpha: 0.5)
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

extension ProductReviewTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - AvatarImageView
        let avaW: CGFloat = 50.0
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avaW/2
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: avaW).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: avaW).isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppMedium, size: 15.0)
        nameLbl.textColor = .black
        
        //TODO: - StarImageView
        starImageView.clipsToBounds = true
        starImageView.contentMode = .scaleAspectFit
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: 12*(380/72)).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
        
        //TODO: - UIStackView
        let starSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .leading)
        starSV.addArrangedSubview(nameLbl)
        starSV.addArrangedSubview(starImageView)
        
        //TODO: - UIStackView
        let avarSV = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        avarSV.addArrangedSubview(avatarImageView)
        avarSV.addArrangedSubview(starSV)
        contentView.addSubview(avarSV)
        
        //TODO: - TimeLbl
        timeLbl.font = UIFont(name: FontName.ppRegular, size: 13.0)
        timeLbl.textColor = .gray
        timeLbl.textAlignment = .right
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLbl)
        
        //TODO: - DesLbl
        desLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        desLbl.textColor = .black
        desLbl.numberOfLines = 0
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        desLbl.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        //TODO: - UIStackView
        let desSV = createStackView(spacing: 10.0, distribution: .fill, axis: .vertical, alignment: .leading)
        desSV.addArrangedSubview(desLbl)
        desSV.addArrangedSubview(coverView)
        contentView.addSubview(desSV)
        
        let coverTap_1 = UITapGestureRecognizer(target: self, action: #selector(coverDidTap_1))
        coverView.coverImageView_1.isUserInteractionEnabled = true
        coverView.coverImageView_1.addGestureRecognizer(coverTap_1)
        
        let coverTap_2 = UITapGestureRecognizer(target: self, action: #selector(coverDidTap_2))
        coverView.coverImageView_2.isUserInteractionEnabled = true
        coverView.coverImageView_2.addGestureRecognizer(coverTap_2)
        
        coverView.moreBtn.delegate = self
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            avarSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            avarSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            avarSV.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: 50),
            
            timeLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            timeLbl.centerYAnchor.constraint(equalTo: avarSV.centerYAnchor),
            
            desSV.topAnchor.constraint(equalTo: avarSV.bottomAnchor, constant: 10.0),
            desSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            desSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0)
        ])
    }
    
    @objc private func coverDidTap_1() {
        delegate?.coverDidTap(self, coverIndex: 0)
    }
    
    @objc private func coverDidTap_2() {
        delegate?.coverDidTap(self, coverIndex: 1)
    }
}

//MARK: - ButtonAnimationDelegate

extension ProductReviewTVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.loadMoreDidTap(self)
    }
}
