//
//  ChatSentView.swift
//  Shopizilla
//
//  Created by Anh Tu on 26/05/2022.
//

import UIKit

class ChatSentView: UIView {
    
    //MARK: - Properties
    let sentBtn = ButtonAnimation()
    let attachBtn = ButtonAnimation()
    
    let textView = UITextView()
    let countLbl = UILabel()
    
    var heightConstraint: NSLayoutConstraint!
    var tvHeightConstraint: NSLayoutConstraint!
    
    var newSize: CGSize = .zero
    let placeholderTxt = "May I help you?".localized()
    
    let btHeight: CGFloat = 74.0
    let tvHeight: CGFloat = 34.0
    
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

extension ChatSentView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: btHeight)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        //TODO: - SentBtn
        setupBtn(sentBtn, imgName: "icon-sent")
        
        //TODO: - AttachBtn
        setupBtn(attachBtn, imgName: "icon-attach")
        
        //TODO: - TextView
        textView.font = UIFont(name: FontName.ppRegular, size: 16.0)
        textView.backgroundColor = UIColor(hex: 0xEFEFF4)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = tvHeight/2
        textView.dataDetectorTypes = .link
        textView.textContainerInset = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 0.0, right: 5.0)
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        tvHeightConstraint = textView.heightAnchor.constraint(equalToConstant: tvHeight)
        tvHeightConstraint.isActive = true
        
        //TODO: - CountLbl
        countLbl.font = UIFont(name: FontName.ppSemiBold, size: 12.0)
        countLbl.text = "0/160"
        countLbl.textColor = .darkGray
        countLbl.textAlignment = .right
        addSubview(countLbl)
        countLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            sentBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11.5),
            sentBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35.0),
            
            attachBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.5),
            attachBtn.bottomAnchor.constraint(equalTo: sentBtn.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: attachBtn.trailingAnchor, constant: 8.0),
            textView.trailingAnchor.constraint(equalTo: sentBtn.leadingAnchor, constant: -8.0),
            textView.bottomAnchor.constraint(equalTo: sentBtn.bottomAnchor),
            
            countLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            countLbl.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
        
        setPlaceholderFor()
    }
    
    private func setupBtn(_ btn: UIButton, imgName: String) {
        btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = defaultColor
        btn.clipsToBounds = true
        addSubview(btn)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: tvHeight).isActive = true
        btn.heightAnchor.constraint(equalToConstant: tvHeight).isActive = true
    }
    
    func setPlaceholderFor() {
        textView.text = placeholderTxt
        textView.textColor = .placeholderText
    }
    
    func reset() {
        newSize = .zero
        textView.text = nil
    }
    
    func setupHeightFor(_ vc: UIViewController, isAnim: Bool) {
        if isAnim {
            vc.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.setHeightFor()
                vc.view.layoutIfNeeded()
                
            } completion: { _ in
                self.scrollTo()
            }
            
        } else {
            setHeightFor()
            scrollTo()
            vc.view.layoutIfNeeded()
        }
    }
    
    private func setHeightFor() {
        tvHeightConstraint.constant = newSize.height
        heightConstraint.constant = newSize.height + 40
    }
    
    private func scrollTo() {
        if textView.text.count > 0 {
            textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1, 1))
            textView.isScrollEnabled = false
            textView.isScrollEnabled = true
        }
    }
    
    func resetHeightFor(_ vc: ChatVC) {
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25) {
            self.tvHeightConstraint.constant = self.tvHeight
            self.heightConstraint.constant = self.btHeight
            vc.view.layoutIfNeeded()
            
        } completion: { _ in
            if vc.chatTxt != "" {
                self.scrollTo()
                vc.view.layoutIfNeeded()
            }
        }
    }
}
