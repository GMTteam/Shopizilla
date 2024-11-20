//
//  DateOfBirthVC.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

protocol DateOfBirthVCDelegate: AnyObject {
    func doneDidSelect(_ vc: DateOfBirthVC, currentDate: Date)
}

class DateOfBirthVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: DateOfBirthVCDelegate?
    
    private let containerView = UIView()
    private let bottomView = UIView()
    private let titleView = UIView()
    private let titleLbl = UILabel()
    private let separatorView = UIView()
    private let datePicker = UIDatePicker()
    private let doneBtn = ButtonAnimation()
    private let cancelBtn = ButtonAnimation()
    
    var currentDate: Date!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentDate == nil {
            currentDate = Date()
        }
        
        datePicker.date = currentDate
    }
}

//MARK: - Setups

extension DateOfBirthVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        //TODO: - BottomView
        let btH: CGFloat = 220 + 70
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-btH, width: screenWidth, height: btH)
        bottomView.clipsToBounds = true
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        
        //TODO: - TitleView
        titleView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0)
        titleView.clipsToBounds = true
        titleView.backgroundColor = .white
        bottomView.addSubview(titleView)
        
        //TODO: - TitleLbl
        titleLbl.text = NSLocalizedString("Date of Birth", comment: "DateOfBirthVC: Date of Birth")
        titleLbl.font = UIFont(name: FontName.ppBold, size: 19.0)
        titleLbl.textAlignment = .center
        titleLbl.textColor = .black
        titleView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SeparatorView
        separatorView.frame = CGRect(x: 0.0, y: 49.0, width: screenWidth, height: 1.0)
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        titleView.addSubview(separatorView)
        
        //TODO: - DoneBtn
        let doneAttr = createMutableAttributedString(fgColor: .black, txt: "Done".localized())
        let disDoneAttr = createMutableAttributedString(fgColor: .lightGray, txt: "Done".localized())
        
        doneBtn.setAttributedTitle(doneAttr, for: .normal)
        doneBtn.setAttributedTitle(disDoneAttr, for: .disabled)
        doneBtn.isEnabled = false
        doneBtn.tag = 2
        doneBtn.delegate = self
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(doneBtn)
        
        //TODO: - CancelBtn
        let canAttr = createMutableAttributedString(fgColor: .black, txt: "Cancel".localized())
        let disCanAttr = createMutableAttributedString(fgColor: .lightGray, txt: "Cancel".localized())
        
        cancelBtn.setAttributedTitle(canAttr, for: .normal)
        cancelBtn.setAttributedTitle(disCanAttr, for: .disabled)
        cancelBtn.tag = 1
        cancelBtn.delegate = self
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(cancelBtn)
        
        //TODO: - DatePicker
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.backgroundColor = .white
        datePicker.tintColor = .black
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.addTarget(self, action: #selector(dateAct), for: .valueChanged)
        bottomView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 50.0),
            datePicker.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            
            titleLbl.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            cancelBtn.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20.0),
            cancelBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            doneBtn.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20.0),
            doneBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
        ])
        
        //TODO: - Transform
        setupTransform()
        
        //TODO: - UITapGestureRecognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeHandler))
        containerView.addGestureRecognizer(tap)
        containerView.isUserInteractionEnabled = true
    }
    
    @objc private func dateAct(_ sender: UIDatePicker) {
        doneBtn.isEnabled = false
        
        if sender.date > Date() {
            sender.date = Date()
            return
        }
        
        let components_1 = Calendar.current.dateComponents([.year], from: Date())
        let components_2 = Calendar.current.dateComponents([.year], from: sender.date)
        if components_1.year == components_2.year {
            return
        }
        
        currentDate = sender.date
        doneBtn.isEnabled = true
    }
    
    private func setupTransform() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        bottomView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        
        UIView.animate(withDuration: 0.50) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.bottomView.transform = .identity
        }
    }
    
    @objc private func removeHandler() {
        remove {}
    }
    
    func remove(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.33) {
            self.bottomView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
        } completion: { _ in
            self.view.removeFromSuperview()
            completion()
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension DateOfBirthVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Cancel
            remove {}
            
        } else if sender.tag == 2 { //Done
            if self.currentDate != nil {
                self.delegate?.doneDidSelect(self, currentDate: self.currentDate)
            }
        }
    }
}
