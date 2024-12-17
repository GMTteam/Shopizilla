//
//  AddressTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 29/04/2022.
//

import UIKit

protocol AddressTVCellDelegate: AnyObject {
    func delDidTap(cell: AddressTVCell)
    func editDidTap(cell: AddressTVCell)
}

class AddressTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "AddressTVCell"
    weak var delegate: AddressTVCellDelegate?
    
    let checkView = UIView()
    let innerView = UIView()
    let separatorView = UIView()
    
    let addressLbl = UILabel()
    let editBtn = ButtonAnimation()
    let deleteBtn = ButtonAnimation()
    
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

extension AddressTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - CheckView
        let checkW: CGFloat = 30.0
        checkView.clipsToBounds = true
        checkView.layer.cornerRadius = checkW/2
        checkView.layer.borderWidth = 1.0
        checkView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.widthAnchor.constraint(equalToConstant: checkW).isActive = true
        checkView.heightAnchor.constraint(equalToConstant: checkW).isActive = true
        
        //TODO: - InnerView
        let innerW: CGFloat = checkW*0.70
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = innerW/2
        innerView.backgroundColor = defaultColor
        innerView.translatesAutoresizingMaskIntoConstraints = false
        checkView.addSubview(innerView)
        
        //TODO: - AddressLbl
        let btnW = "Delete".lowercased().estimatedTextRect(fontN: FontName.ppBold, fontS: 16).width + 20
        let addrW: CGFloat = screenWidth-40-40-btnW-10
        addressLbl.textColor = .black
        addressLbl.numberOfLines = 0
        addressLbl.translatesAutoresizingMaskIntoConstraints = false
        addressLbl.widthAnchor.constraint(equalToConstant: addrW).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .top)
        stackView.addArrangedSubview(checkView)
        stackView.addArrangedSubview(addressLbl)
        contentView.addSubview(stackView)
        
        //TODO: - DeleteBtn
        let delAttr = createMutableAttributedString(fgColor: .white, txt: "Delete".localized())
        deleteBtn.setAttributedTitle(delAttr, for: .normal)
        deleteBtn.clipsToBounds = true
        deleteBtn.tag = 0
        deleteBtn.delegate = self
        deleteBtn.layer.cornerRadius = 8.0
        deleteBtn.backgroundColor = UIColor(hex: 0xF33D30)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.widthAnchor.constraint(equalToConstant: btnW).isActive = true
        deleteBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //TODO: - EditBtn
        let editAttr = createMutableAttributedString(fgColor: .white, txt: "Edit".localized())
        editBtn.setAttributedTitle(editAttr, for: .normal)
        editBtn.clipsToBounds = true
        editBtn.tag = 1
        editBtn.delegate = self
        editBtn.layer.cornerRadius = 8.0
        editBtn.backgroundColor = defaultColor
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.widthAnchor.constraint(equalToConstant: btnW).isActive = true
        editBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //TODO: - UIStackView
        let btnSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .trailing)
        btnSV.addArrangedSubview(deleteBtn)
        btnSV.addArrangedSubview(editBtn)
        contentView.addSubview(btnSV)
        
        //TODO: - SeparatorView
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = separatorColor
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            
            btnSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            btnSV.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            innerView.widthAnchor.constraint(equalToConstant: innerW),
            innerView.heightAnchor.constraint(equalToConstant: innerW),
            innerView.centerXAnchor.constraint(equalTo: checkView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: checkView.centerYAnchor),
            
            separatorView.widthAnchor.constraint(equalToConstant: screenWidth-40),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension AddressTVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Delete
            delegate?.delDidTap(cell: self)
            
        } else if sender.tag == 1 { //Edit
            delegate?.editDidTap(cell: self)
        }
    }
}
