//
//  HomeProductCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/04/2022.
//

import UIKit

protocol HomeProductCVCellDelegate: AnyObject {
    func heartDidTap(_ cell: HomeProductCVCell)
}

class HomeProductCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "HomeProductCVCell"
    weak var delegate: HomeProductCVCellDelegate?
    
    let containerView = UIView()
    let coverView = UIView()
    let coverImageView = UIImageView()
    let nameLbl = UILabel()
    
    let newPriceLbl = UILabel() //Giá đã giảm
    let oldPriceLbl = UILabel() //Giá cũ
    
    let favBtn = ButtonAnimation()
    
    let saleView = UIView()
    let saleLbl = UILabel()
    
    var favWConstraint: NSLayoutConstraint!
    var favHConstraint: NSLayoutConstraint!
    
    var saleWConstraint: NSLayoutConstraint!
    var saleHConstraint: NSLayoutConstraint!
    
    static var nameHeight: CGFloat {
        return "WgH".estimatedTextRect(fontN: FontName.ppRegular, fontS: 14).height
    }
    static var priceHeight: CGFloat {
        return "WgH".estimatedTextRect(fontN: FontName.ppSemiBold, fontS: 15).height
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
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

extension HomeProductCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        //TODO: - CoverView
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 15.0
        coverView.backgroundColor = .white
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        setupShadow(coverView)
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 15.0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(coverImageView)
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        nameLbl.textColor = .gray
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NewPriceLbl
        newPriceLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        newPriceLbl.textColor = .black
        
        //TODO: - OldPriceLbl
        oldPriceLbl.font = UIFont(name: FontName.ppMedium, size: 13.0)
        oldPriceLbl.textColor = .gray
        
        //TODO: - UIStackView
        let priceSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        priceSV.addArrangedSubview(newPriceLbl)
        priceSV.addArrangedSubview(oldPriceLbl)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .vertical, alignment: .leading)
        stackView.addArrangedSubview(coverView)
        stackView.addArrangedSubview(nameLbl)
        stackView.setCustomSpacing(5.0, after: nameLbl)
        stackView.addArrangedSubview(priceSV)
        containerView.addSubview(stackView)
        
        //TODO: - FavoriteBtn
        favBtn.isHidden = true
        favBtn.setImage(UIImage(named: "icon-heartFilled"), for: .normal)
        favBtn.clipsToBounds = true
        favBtn.backgroundColor = UIColor(hex: 0xBABABA, alpha: 0.1)
        favBtn.layer.cornerRadius = 15.0
        favBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        favBtn.delegate = self
        favBtn.tag = 0
        favBtn.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(favBtn)
        
        favWConstraint = favBtn.widthAnchor.constraint(equalToConstant: 35.0)
        favWConstraint.isActive = true
        
        favHConstraint = favBtn.heightAnchor.constraint(equalToConstant: 35.0)
        favHConstraint.isActive = true
        
        //TODO: - SaleView
        saleView.isHidden = true
        saleView.clipsToBounds = true
        saleView.backgroundColor = UIColor(hex: 0xF33D30)
        saleView.layer.cornerRadius = 15.0
        saleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        saleView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(saleView)
        
        saleWConstraint = saleView.widthAnchor.constraint(equalToConstant: 35*1.5)
        saleWConstraint.isActive = true
        
        saleHConstraint = saleView.heightAnchor.constraint(equalToConstant: 35.0)
        saleHConstraint.isActive = true
        
        //TODO: - SaleLbl
        saleLbl.font = UIFont(name: FontName.ppSemiBold, size: 11.0)
        saleLbl.textColor = .white
        saleLbl.textAlignment = .center
        saleLbl.translatesAutoresizingMaskIntoConstraints = false
        saleView.addSubview(saleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            coverView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: imageHeightRatio),
            nameLbl.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
            
            favBtn.topAnchor.constraint(equalTo: coverView.topAnchor),
            favBtn.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            
            saleView.topAnchor.constraint(equalTo: coverView.topAnchor),
            saleView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            
            saleLbl.centerXAnchor.constraint(equalTo: saleView.centerXAnchor),
            saleLbl.centerYAnchor.constraint(equalTo: saleView.centerYAnchor),
        ])
    }
}

//MARK: - UpdateUI

extension HomeProductCVCell {
    
    func setupCell(_ product: Product, indexPath: IndexPath) {
        coverImageView.image = nil
        self.tag = indexPath.item

        DownloadImage.shared.downloadImage(link: product.imageURL) { image in
            if self.tag == indexPath.item {
                self.coverImageView.image = image
            }
        }
        
        nameLbl.text = product.name
        updatePrice(product)
        
        //Mặt hàng có giảm giá hay ko
        let saleOff = product.saleOff
        saleView.isHidden = saleOff == 0
        saleLbl.isHidden = saleOff == 0
        saleLbl.text = "-\(saleOff == 0 ? "" : "\(saleOff)")%"
    }
    
    func setupConstraintForIcon(_ column: Int) {
        let height: CGFloat = column == 3 ? 32 : 35
        
        favWConstraint.constant = height
        favHConstraint.constant = height
        
        saleWConstraint.constant = height*1.5
        saleHConstraint.constant = height
    }
    
    private func updatePrice(_ product: Product) {
        let oldPrice = product.price
        let perc = (100 - product.saleOff)/100
        let newPrice = (oldPrice*perc)
        
        oldPriceLbl.text = ""
        oldPriceLbl.attributedText = nil

        if product.saleOff != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppMedium, size: 13.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldPrice.formattedCurrency, attributes: att)

            oldPriceLbl.attributedText = attr
        }

        oldPriceLbl.isHidden = product.saleOff == 0.0
        newPriceLbl.text = newPrice.formattedCurrency
    }
}

//MARK: - ButtonAnimationDelegate

extension HomeProductCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Heart
            delegate?.heartDidTap(self)
        }
    }
}
