//
//  SuccessVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 01/05/2022.
//

import UIKit

class SuccessVC: UIViewController {
    
    //MARK: - Properties
    let titleLbl = UILabel()
    let iconImageView = UIImageView()
    let desLbl = UILabel()
    let backBtn = ButtonAnimation()
    
    var orderID: String = ""
    var naviC: UINavigationController?
    var tabBarC: UITabBarController?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: - Setups

extension SuccessVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = ""
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppBold, size: 30.0)
        titleLbl.text = "Order Completed".localized()
        titleLbl.textColor = .black
        titleLbl.numberOfLines = 2
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLbl)
        
        //TODO: - IconImageView
        let iconW: CGFloat = screenWidth*(appDL.isIPhoneX ? 0.7 : 0.6)
        iconImageView.image = UIImage(named: "icon-orderCompleted")
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - DesLbl
        let desAtt1: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppRegular, size: 17.0)!,
            .foregroundColor: UIColor.black
        ]
        let desAtt2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 17.0)!,
            .foregroundColor: UIColor.black
        ]
        let desAttr1 = NSAttributedString(string: "Order".localized() + " #", attributes: desAtt1)
        let desAttr2 = NSAttributedString(string: orderID, attributes: desAtt2)
        let desAttr3 = NSAttributedString(string: " " + "successfully placed. You will receive the item in about 5 -7 days.".localized(), attributes: desAtt1)
        
        let desAttr = NSMutableAttributedString()
        desAttr.append(desAttr1)
        desAttr.append(desAttr2)
        desAttr.append(desAttr3)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let desAtt3: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraph
        ]
        desAttr.addAttributes(desAtt3, range: NSRange(location: 0, length: desAttr.length))
        
        desLbl.attributedText = desAttr
        desLbl.numberOfLines = 0
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        desLbl.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 20.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(desLbl)
        view.addSubview(stackView)
        
        //TODO: - BackBtn
        let backAttr = createMutableAttributedString(fgColor: .white, txt: "Back to Home".localized())
        backBtn.setAttributedTitle(backAttr, for: .normal)
        backBtn.clipsToBounds = true
        backBtn.layer.cornerRadius = 25.0
        backBtn.backgroundColor = defaultColor
        backBtn.tag = 0
        backBtn.delegate = self
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44.0),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backBtn.widthAnchor.constraint(equalToConstant: screenWidth-40),
            backBtn.heightAnchor.constraint(equalToConstant: 50.0),
            backBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0),
            backBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(orderDidTap))
        desLbl.isUserInteractionEnabled = true
        desLbl.addGestureRecognizer(tap)
    }
    
    @objc private func orderDidTap(_ sender: UITapGestureRecognizer) {
        let txt = desLbl.text ?? ""
        let range = (txt as NSString).range(of: orderID)
        
        if sender.didTapAttributedTextInLabel(label: desLbl, inRange: range) {
            backTo(3)
            NotificationCenter.default.post(name: .orderCompletedKey, object: nil)
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension SuccessVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back to Home
            backTo(0)
        }
    }
    
    private func backTo(_ index: Int) {
        dismiss(animated: true)
        naviC?.popToRootViewController(animated: true)
        tabBarC?.selectedIndex = index
    }
}
