//
//  MyOrderInfoCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

protocol MyOrderInfoCVCellDelegate: AnyObject {
    func orderNumberDidTap(_ cell: MyOrderInfoCVCell)
}

class MyOrderInfoCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "MyOrderInfoCVCell"
    weak var delegate: MyOrderInfoCVCellDelegate?
    
    let notifView = UIView()
    let payImageView = UIImageView()
    let notifTitleLbl = UILabel()
    let notifSubtitleLbl = UILabel()
    
    let orderNumberTitleLbl = UILabel()
    let orderNumberLbl = UILabel()
    
    let orderDateTitleLbl = UILabel()
    let orderDateLbl = UILabel()
    
    let addressTitleLbl = UILabel()
    let addressLbl = UILabel()
    
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

extension MyOrderInfoCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - NotifView
        notifView.clipsToBounds = true
        notifView.layer.cornerRadius = 15.0
        notifView.backgroundColor = UIColor(hex: 0x474340)
        notifView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notifView)
        
        //TODO: - PayImageView
        payImageView.clipsToBounds = true
        payImageView.contentMode = .scaleAspectFill
        notifView.addSubview(payImageView)
        payImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - OrderTitleLbl
        setupTitleLbl(orderNumberTitleLbl)
        
        //TODO: - AddressTitleLbl
        setupTitleLbl(addressTitleLbl)
        
        //TODO: - OrderDateTitleLbl
        setupTitleLbl(orderDateTitleLbl)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .vertical, alignment: .leading)
        stackView.addArrangedSubview(orderNumberTitleLbl)
        stackView.addArrangedSubview(orderDateTitleLbl)
        stackView.addArrangedSubview(addressTitleLbl)
        contentView.addSubview(stackView)
        
        //TODO: - NotifTitleLbl
        notifTitleLbl.font = UIFont(name: FontName.ppSemiBold, size: 18.0)
        notifTitleLbl.textColor = .white
        
        //TODO: - NotifSubtitleLbl
        notifSubtitleLbl.font = UIFont(name: FontName.ppMedium, size: 14.0)
        notifSubtitleLbl.textColor = .lightGray
        notifSubtitleLbl.numberOfLines = 2
        
        //TODO: - UIStackView
        let notifSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .leading)
        notifSV.addArrangedSubview(notifTitleLbl)
        notifSV.addArrangedSubview(notifSubtitleLbl)
        notifView.addSubview(notifSV)
        
        //TODO: - OrderNumberLbl
        setupSubtitleLbl(orderNumberLbl, line: 1)
        
        //TODO: - OrderDateLbl
        setupSubtitleLbl(orderDateLbl, line: 1)
        
        //TODO: - AddressNumberLbl
        setupSubtitleLbl(addressLbl, line: 0)
        
        //TODO: - UIStackView
        let subSV = createStackView(spacing: 10.0, distribution: .fill, axis: .vertical, alignment: .trailing)
        subSV.addArrangedSubview(orderNumberLbl)
        subSV.addArrangedSubview(orderDateLbl)
        subSV.addArrangedSubview(addressLbl)
        contentView.addSubview(subSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            notifView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            notifView.heightAnchor.constraint(equalToConstant: 100.0),
            notifView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            notifView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            
            stackView.topAnchor.constraint(equalTo: notifView.bottomAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            
            payImageView.topAnchor.constraint(equalTo: notifView.topAnchor),
            payImageView.bottomAnchor.constraint(equalTo: notifView.bottomAnchor),
            payImageView.widthAnchor.constraint(equalTo: payImageView.heightAnchor, multiplier: 1.0),
            payImageView.trailingAnchor.constraint(equalTo: notifView.trailingAnchor),
            
            notifSV.centerYAnchor.constraint(equalTo: notifView.centerYAnchor),
            notifSV.leadingAnchor.constraint(equalTo: notifView.leadingAnchor, constant: 10.0),
            notifSV.trailingAnchor.constraint(lessThanOrEqualTo: payImageView.leadingAnchor),
            
            subSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            subSV.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(orderNumberDidTap))
        orderNumberLbl.addGestureRecognizer(tap)
        orderNumberLbl.isUserInteractionEnabled = true
    }
    
    private func setupTitleLbl(_ lbl: UILabel) {
        lbl.font = UIFont(name: FontName.ppMedium, size: 15.0)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.widthAnchor.constraint(equalToConstant: (screenWidth/2)-25).isActive = true
    }
    
    private func setupSubtitleLbl(_ lbl: UILabel, line: Int) {
        lbl.font = UIFont(name: FontName.ppMedium, size: 15.0)
        lbl.textColor = .darkGray
        lbl.textAlignment = .right
        lbl.numberOfLines = line
    }
    
    @objc private func orderNumberDidTap() {
        delegate?.orderNumberDidTap(self)
    }
}
