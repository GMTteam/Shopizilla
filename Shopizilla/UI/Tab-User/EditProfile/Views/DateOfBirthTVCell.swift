//
//  DateOfBirthTVCell.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

protocol DateOfBirthTVCellDelegate: AnyObject {
    func birthDidTap(_ cell: DateOfBirthTVCell)
}

class DateOfBirthTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "DateOfBirthTVCell"
    weak var delegate: DateOfBirthTVCellDelegate?
    
    let containerView = UIView()
    let dateLbl = UILabel()
    let arrowImgView = UIImageView()
    let btn = ButtonAnimation()
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configures

extension DateOfBirthTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - ContainerView
        let height: CGFloat = 60.0
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = height/2
        containerView.layer.borderWidth = 1.0
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Arrow
        arrowImgView.clipsToBounds = true
        arrowImgView.image = UIImage(named: "icon-arrowDown")?.withRenderingMode(.alwaysTemplate)
        arrowImgView.tintColor = .gray
        arrowImgView.contentMode = .scaleAspectFit
        containerView.addSubview(arrowImgView)
        arrowImgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - DateLbl
        dateLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        containerView.addSubview(dateLbl)
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Btn
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 30.0
        btn.backgroundColor = .clear
        btn.delegate = self
        containerView.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImgView.widthAnchor.constraint(equalToConstant: 30.0),
            arrowImgView.heightAnchor.constraint(equalToConstant: 30.0),
            arrowImgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.0),
            arrowImgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            dateLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dateLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.0),
            dateLbl.trailingAnchor.constraint(lessThanOrEqualTo: arrowImgView.leadingAnchor, constant: -10.0),
            
            btn.topAnchor.constraint(equalTo: containerView.topAnchor),
            btn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    func dateFormatter(_ date: Date?) {
        if let date = date {
            let formatter = createDateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            dateLbl.text = formatter.string(from: date)
            
        } else {
            dateLbl.text = "-- -- ----"
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension DateOfBirthTVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.birthDidTap(self)
    }
}
