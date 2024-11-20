//
//  OrderHistoryCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 03/05/2022.
//

import UIKit

protocol OrderHistoryCVCellDelegate: AnyObject {
    func cancelDidTap(_ cell: OrderHistoryCVCell)
}

class OrderHistoryCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "HomeBannerCVCell"
    weak var delegate: OrderHistoryCVCellDelegate?
    
    let containerView = UIView()
    
    let topView = UIView()
    let coverImageView = UIImageView()
    let dimsView = UIView()
    let statusLbl = UILabel()
    let orderDateLbl = UILabel()
    let itemLbl = UILabel()
    let redView = UIView()
    
    let centerView = UIView()
    let item_1View = OrderHistoryItemView()
    let item_2View = OrderHistoryItemView()
    
    let bottomView = UIView()
    let totalLbl = UILabel()
    let cancelBtn = ButtonAnimation()
    
    let paidImageView = UIImageView()
    
    static let topH: CGFloat = 120.0
    static let bottomH: CGFloat = 70.0
    static let centerH = (screenWidth*0.2)*imageHeightRatio + 20
    
    var centerHConstraint: NSLayoutConstraint!
    var cancelWConstraint: NSLayoutConstraint!
    
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
        item_1View.coverImageView.image = nil
        item_2View.coverImageView.image = nil
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

extension OrderHistoryCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        setupShadow(containerView)
        
        //TODO: - TopView
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 15.0
        topView.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        topView.heightAnchor.constraint(equalToConstant: OrderHistoryCVCell.topH).isActive = true
        
        //TODO: - CenterView
        centerView.clipsToBounds = true
        centerView.backgroundColor = .white
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        centerHConstraint = centerView.heightAnchor.constraint(equalToConstant: OrderHistoryCVCell.centerH)
        centerHConstraint.isActive = true
        
        //TODO: - BottomView
        bottomView.clipsToBounds = true
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 15.0
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: OrderHistoryCVCell.bottomH).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(centerView)
        stackView.addArrangedSubview(bottomView)
        containerView.addSubview(stackView)
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 15.0
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(coverImageView)
        
        //TODO: - DimsView
        dimsView.clipsToBounds = true
        dimsView.layer.cornerRadius = 15.0
        dimsView.backgroundColor = .black.withAlphaComponent(0.8)
        dimsView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(dimsView)
        
        //TODO: - StatusLbl
        statusLbl.font = UIFont(name: FontName.ppBold, size: 20.0)
        statusLbl.textColor = .white
        statusLbl.textAlignment = .center
        statusLbl.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(statusLbl)
        
        //TODO: - ItemLbl
        itemLbl.font = UIFont(name: FontName.ppSemiBold, size: 12.0)
        itemLbl.textColor = .white
        itemLbl.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(itemLbl)
        
        //TODO: - OrderDateLbl
        orderDateLbl.font = UIFont(name: FontName.ppMedium, size: 16.0)
        orderDateLbl.textColor = .lightGray
        orderDateLbl.textAlignment = .right
        orderDateLbl.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(orderDateLbl)
        
        //TODO: - OrderDateLbl
        totalLbl.font = UIFont(name: FontName.ppBold, size: 18.0)
        totalLbl.textColor = .black
        totalLbl.numberOfLines = 2
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(totalLbl)
        
        //TODO: - OrderDateLbl
        let cancelW = "Cancelled".estimatedTextRect(fontN: FontName.ppBold, fontS: 16.0).width + 30
        let cancelAttr = createMutableAttributedString(fgColor: .white, txt: "Cancel".localized())
        cancelBtn.setAttributedTitle(cancelAttr, for: .normal)
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 8.0
        cancelBtn.backgroundColor = defaultColor
        cancelBtn.delegate = self
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(cancelBtn)
        
        cancelWConstraint = cancelBtn.widthAnchor.constraint(equalToConstant: cancelW)
        cancelWConstraint.isActive = true
        
        //TODO: - Item_1View
        setupItemView(itemView: item_1View)
        
        //TODO: - Item_2View
        setupItemView(itemView: item_2View)
        
        //TODO: - UIStackView
        let itemSV = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        itemSV.addArrangedSubview(item_1View)
        itemSV.addArrangedSubview(item_2View)
        centerView.addSubview(itemSV)
        
        //TODO: - RedView
        redView.isHidden = true
        redView.clipsToBounds = true
        redView.backgroundColor = UIColor(hex: 0xF33D30)
        redView.layer.cornerRadius = 4.0
        redView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(redView)
        
        //TODO: - PaidImageView
        paidImageView.clipsToBounds = true
        paidImageView.layer.cornerRadius = 8.0
        paidImageView.contentMode = .scaleAspectFit
        bottomView.addSubview(paidImageView)
        paidImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: topView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            dimsView.topAnchor.constraint(equalTo: topView.topAnchor),
            dimsView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            dimsView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            dimsView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            statusLbl.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            statusLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -10.0),
            
            itemLbl.leadingAnchor.constraint(equalTo: statusLbl.trailingAnchor, constant: 5.0),
            itemLbl.topAnchor.constraint(equalTo: statusLbl.topAnchor),
            
            orderDateLbl.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20.0),
            orderDateLbl.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10.0),
            
            totalLbl.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20.0),
            totalLbl.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            cancelBtn.heightAnchor.constraint(equalToConstant: 45.0),
            cancelBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20.0),
            cancelBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            itemSV.centerXAnchor.constraint(equalTo: centerView.centerXAnchor),
            itemSV.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            
            redView.widthAnchor.constraint(equalToConstant: 8.0),
            redView.heightAnchor.constraint(equalToConstant: 8.0),
            redView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 3.75),
            redView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 3.75),
            
            paidImageView.widthAnchor.constraint(equalToConstant: cancelW),
            paidImageView.heightAnchor.constraint(equalToConstant: 45.0),
            paidImageView.centerXAnchor.constraint(equalTo: cancelBtn.centerXAnchor),
            paidImageView.centerYAnchor.constraint(equalTo: cancelBtn.centerYAnchor),
        ])
    }
    
    private func setupItemView(itemView: UIView) {
        //TODO: - ItemView
        itemView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        itemView.heightAnchor.constraint(equalToConstant: OrderHistoryCVCell.centerH).isActive = true
    }
}

//MARK: - ButtonAnimationDelegate

extension OrderHistoryCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.cancelDidTap(self)
    }
}
