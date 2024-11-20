//
//  BagCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 27/04/2022.
//

import UIKit

protocol BagCVCellDelegate: AnyObject {
    func plusDidTap(_ cell: BagCVCell)
    func minusDidTap(_ cell: BagCVCell)
    func deleteDidTap(_ cell: BagCVCell)
}

class BagCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "BagCVCell"
    weak var delegate: BagCVCellDelegate?
    
    let containerView = UIView()
    let coverView = UIView()
    let coverImageView = UIImageView()
    
    let plusView = UIView()
    let plusBtn = ButtonAnimation()
    
    let numLbl = UILabel()
    
    let minusView = UIView()
    let minusBtn = ButtonAnimation()
    var btnSV: UIStackView!
    
    let nameLbl = UILabel()
    
    let newPriceLbl = UILabel()
    let oldPriceLbl = UILabel()
    
    let colorTitleLbl = UILabel()
    let colorView = UIView()
    let colorInnerView = UIView()
    
    let halfLeftBorderImageView = UIImageView()
    let halfRightBorderImageView = UIImageView()
    
    let halfLeftImageView = UIImageView()
    let halfRightImageView = UIImageView()
    
    let sizeTitleLbl = UILabel()
    let sizeView = UIView()
    let sizeLbl = UILabel()
    
    let trashBtn = ButtonAnimation()
    
    static let coverW: CGFloat = screenWidth/3
    static var coverH: CGFloat {
        return coverW*imageHeightRatio
    }
    
    var cvLeadingConstraint: NSLayoutConstraint!
    var cvTrailingConstraint: NSLayoutConstraint!
    var sizeWConstraint: NSLayoutConstraint!
    
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

extension BagCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15.0
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        setupShadow(containerView, radius: 1.0, opacity: 0.1)
        
        cvLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0)
        cvLeadingConstraint.isActive = true
        
        cvTrailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0)
        cvTrailingConstraint.isActive = true
        
        //TODO: - CoverView
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 15.0
        coverView.backgroundColor = .white
        coverView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coverView)
        setupShadow(coverView, radius: 1.0, opacity: 0.1)
        
        //TODO: - coverImageView
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 15.0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(coverImageView)
        
        //TODO: - PlusBtn
        setupBtn(plusView, plusBtn, imgName: "icon-plus", tag: 0)
        
        //TODO: - NumLbl
        numLbl.font = UIFont(name: FontName.ppSemiBold, size: 19.0)
        numLbl.textColor = .darkGray
        numLbl.textAlignment = .center
        numLbl.translatesAutoresizingMaskIntoConstraints = false
        numLbl.widthAnchor.constraint(equalToConstant: 35).isActive = true
        numLbl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //TODO: - MinusBtn
        setupBtn(minusView, minusBtn, imgName: "icon-minus", tag: 1)
        
        //TODO: - UIStackView
        btnSV = createStackView(spacing: 20.0, distribution: .fillEqually, axis: .vertical, alignment: .center)
        btnSV.addArrangedSubview(plusView)
        btnSV.addArrangedSubview(numLbl)
        btnSV.addArrangedSubview(minusView)
        containerView.addSubview(btnSV)
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 18.0)
        nameLbl.textColor = .darkGray
        nameLbl.numberOfLines = appDL.isIPhoneX ? 2 : 1
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLbl)
        
        //TODO: - NewPriceLbl
        newPriceLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        newPriceLbl.textColor = .black
        
        //TODO: - PriceLbl
        oldPriceLbl.font = UIFont(name: FontName.ppSemiBold, size: 17.0)
        oldPriceLbl.textColor = .gray
        
        //TODO: - UIStackView
        let priceSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        priceSV.addArrangedSubview(newPriceLbl)
        priceSV.addArrangedSubview(oldPriceLbl)
        containerView.addSubview(priceSV)
        
        //TODO: - ColorTitleLbl
        setupTitle(lbl: colorTitleLbl, txt: "Color".localized())
        
        //TODO: - ColorView
        setupColorView(colorView, bgColor: .white)
        
        //TODO: - ColorInnerView
        setupColorView(colorInnerView, bgColor: .white, isCons: false)
        
        //TODO: - HalfLeftBorderImageView
        setupHalfBorderImageView(halfLeftBorderImageView, imgName: "icon-halfLeftBorder")
        
        //TODO: - HalfRightBorderImageView
        setupHalfBorderImageView(halfRightBorderImageView, imgName: "icon-halfRightBorder")
        
        //TODO: - HalfLeftImageView
        setupHalfImageView(halfLeftImageView, imgName: "icon-halfLeft")
        
        //TODO: - HalfRightImageView
        setupHalfImageView(halfRightImageView, imgName: "icon-halfRight")
        
        //TODO: - SizeTitleLbl
        setupTitle(lbl: sizeTitleLbl, txt: "Size".localized())
        
        //TODO: - SizeView
        sizeView.clipsToBounds = true
        sizeView.layer.cornerRadius = 6.0
        sizeView.layer.borderWidth = 1.5
        sizeView.layer.borderColor = UIColor.clear.cgColor
        sizeView.backgroundColor = defaultColor
        sizeView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sizeView)
        
        sizeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sizeWConstraint = sizeView.widthAnchor.constraint(equalToConstant: 30)
        sizeWConstraint.isActive = true
        
        setupShadow(sizeView, radius: 1.0, opacity: 0.1)
        
        //TODO: - SizeLbl
        sizeLbl.font = UIFont(name: FontName.ppSemiBold, size: 15.0)
        sizeLbl.textColor = .white
        sizeLbl.textAlignment = .center
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        sizeView.addSubview(sizeLbl)
        
        //TODO: - TrashBtn
        trashBtn.backgroundColor = UIColor(hex: 0xF33D30)
        trashBtn.setImage(UIImage(named: "icon-trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        trashBtn.tintColor = .white
        trashBtn.clipsToBounds = true
        trashBtn.delegate = self
        trashBtn.tag = 2
        trashBtn.layer.cornerRadius = 15.0
        trashBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        trashBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trashBtn)
        
        //TODO: - NSLayoutConstraint
        let sp: CGFloat = 3.0
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            coverView.widthAnchor.constraint(equalToConstant: BagCVCell.coverW),
            coverView.heightAnchor.constraint(equalToConstant: BagCVCell.coverH),
            coverView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
            
            btnSV.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            btnSV.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0),
            
            nameLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            nameLbl.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 10.0),
            nameLbl.trailingAnchor.constraint(lessThanOrEqualTo: btnSV.leadingAnchor, constant: -10.0),
            
            priceSV.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0),
            priceSV.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 10.0),
            priceSV.trailingAnchor.constraint(lessThanOrEqualTo: btnSV.leadingAnchor, constant: -10.0),
            
            colorTitleLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: appDL.isIPhoneX ? 5:0),
            colorTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            
            sizeTitleLbl.topAnchor.constraint(equalTo: colorTitleLbl.bottomAnchor, constant: 5.0),
            sizeTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            
            colorView.leadingAnchor.constraint(equalTo: colorTitleLbl.trailingAnchor, constant: 10.0),
            colorView.centerYAnchor.constraint(equalTo: colorTitleLbl.centerYAnchor),
            
            colorInnerView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: sp),
            colorInnerView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: sp),
            colorInnerView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -sp),
            colorInnerView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -sp),
            
            sizeView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            sizeView.centerYAnchor.constraint(equalTo: sizeTitleLbl.centerYAnchor),
            
            sizeLbl.topAnchor.constraint(equalTo: sizeView.topAnchor),
            sizeLbl.leadingAnchor.constraint(equalTo: sizeView.leadingAnchor),
            sizeLbl.trailingAnchor.constraint(equalTo: sizeView.trailingAnchor),
            sizeLbl.bottomAnchor.constraint(equalTo: sizeView.bottomAnchor),
            
            trashBtn.widthAnchor.constraint(equalToConstant: 40),
            trashBtn.heightAnchor.constraint(equalToConstant: 40),
            trashBtn.topAnchor.constraint(equalTo: containerView.topAnchor),
            trashBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
    }
    
    private func setupBtn(_ parentView: UIView, _ btn: ButtonAnimation, imgName: String, tag: Int) {
        parentView.clipsToBounds = true
        parentView.backgroundColor = .white
        parentView.layer.cornerRadius = 12.0
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        parentView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        setupShadow(parentView, radius: 1.0, opacity: 0.1)
        
        btn.setImage(UIImage(named: imgName), for: .normal)
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 12.0
        btn.delegate = self
        btn.tag = tag
        btn.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(btn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: parentView.topAnchor),
            btn.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
    
    private func setupTitle(lbl: UILabel, txt: String) {
        lbl.font = UIFont(name: FontName.ppMedium, size: 17.0)
        lbl.textColor = .darkGray
        lbl.text = txt
        lbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lbl)
        
        lbl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func setupColorView(_ colorView: UIView, bgColor: UIColor, isCons: Bool = true) {
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 5.0
        colorView.layer.borderWidth = 1.5
        colorView.layer.borderColor = UIColor.clear.cgColor
        colorView.backgroundColor = bgColor
        colorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorView)
        
        if isCons {
            colorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        setupShadow(colorView, radius: 1.0, opacity: 0.1)
    }
    
    private func setupHalfBorderImageView(_ imgView: UIImageView, imgName: String) {
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(imgView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: colorView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor)
        ])
    }
    
    private func setupHalfImageView(_ imgView: UIImageView, imgName: String) {
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        colorInnerView.addSubview(imgView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: colorInnerView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: colorInnerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: colorInnerView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: colorInnerView.bottomAnchor)
        ])
    }
}

//MARK: - UpdateUI

extension BagCVCell {
    
    func bagCVCell(_ shopping: ShoppingCart, indexPath: IndexPath) {
        coverImageView.image = nil
        self.tag = indexPath.item
        
        DownloadImage.shared.downloadImage(link: shopping.imageURL) { image in
            if self.tag == indexPath.item {
                self.coverImageView.image = image
            }
        }
        
        numLbl.text = "\(shopping.quantity)"
        nameLbl.text = shopping.name + " - \(shopping.category)"
        sizeLbl.text = shopping.size
        
        let oneTxt = "ONE SIZE"
        let oneSizeW = oneTxt.estimatedTextRect(fontN: FontName.ppSemiBold, fontS: 15).width + 10
        sizeWConstraint.constant = shopping.size == oneTxt ? oneSizeW : 30
        
        let component = shopping.color.components(separatedBy: ",")
        let first = (component.first ?? "").replacingOccurrences(of: " ", with: "")
        let last = (component.last ?? "").replacingOccurrences(of: " ", with: "")
        
        colorView.layer.borderColor = UIColor.clear.cgColor
        colorInnerView.backgroundColor = .clear
        
        if component.count == 1 {
            if first.count == 6 {
                colorView.layer.borderColor = UIColor(hexStr: first).cgColor
                colorInnerView.backgroundColor = UIColor(hexStr: first)
                
                halfLeftBorderImageView.isHidden = true
                halfRightBorderImageView.isHidden = true
                
                halfLeftImageView.isHidden = true
                halfRightImageView.isHidden = true
            }
            
        } else if component.count == 2 {
            if first.count == 6 {
                halfLeftBorderImageView.isHidden = false
                halfLeftBorderImageView.tintColor = UIColor(hexStr: first)
                
                halfLeftImageView.isHidden = false
                halfLeftImageView.tintColor = UIColor(hexStr: first)
            }
            
            if last.count == 6 {
                halfRightBorderImageView.isHidden = false
                halfRightBorderImageView.tintColor = UIColor(hexStr: last)
                
                halfRightImageView.isHidden = false
                halfRightImageView.tintColor = UIColor(hexStr: last)
            }
        }
    }
    
    func updatePrice(_ shopping: ShoppingCart) {
        let oldPrice = shopping.total
        let perc = (100 - shopping.saleOff)/100
        let newPrice = (oldPrice*perc)
        
        oldPriceLbl.text = ""
        oldPriceLbl.attributedText = nil

        if shopping.saleOff != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppSemiBold, size: 17.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldPrice.formattedCurrency, attributes: att)

            oldPriceLbl.attributedText = attr
        }

        oldPriceLbl.isHidden = shopping.saleOff == 0.0
        newPriceLbl.text = newPrice.formattedCurrency
    }
}

//MARK: - ButtonAnimationDelegate

extension BagCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Plus
            delegate?.plusDidTap(self)
            
        } else if sender.tag == 1 { //Minus
            delegate?.minusDidTap(self)
            
        } else if sender.tag == 2 { //Delete
            delegate?.deleteDidTap(self)   
        }
    }
}
