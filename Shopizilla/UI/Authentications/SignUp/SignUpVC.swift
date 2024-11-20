//
//  SignUpVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit

protocol SignUpVCDelegate: AnyObject {
    func signUpHandler(_ vc: SignUpVC)
}

class SignUpVC: UIViewController {

    // MARK: - Properties
    weak var delegate: SignUpVCDelegate?
    
    private let naviView = UIView()
    private let backBtn = ButtonAnimation()
    private let containerView = UIView()
    private let bgImageView = UIImageView()
    private let contentView = SignUpContentView()
    private let titleLbl = UILabel()
    
    private var passwordTF: EmailTF { return contentView.passwordTF }
    private var nameTF: EmailTF { return contentView.nameTF }
    private var eyeImageView: UIImageView { return contentView.eyeImageView }
    private var termsLbl: UILabel { return contentView.termsLbl }
    
    var emailTxt = ""
    
    private var nameTxt = ""
    private var passwordTxt = ""
    private var eyeShow = false
    
    private var verify = false
    private var agree = false
    
    private var cvHeightConstraint: NSLayoutConstraint!
    private var didBecomeActiveObs: Any?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        (navigationController as? NavigationController)?.darkBarStyle = true
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        contentView.setupTitleLbl(emailTxt)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: didBecomeActiveObs)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Setups

extension SignUpVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        //TODO: - BGImageView
        bgImageView.frame = view.bounds
        bgImageView.clipsToBounds = true
        bgImageView.image = UIImage(named: "welcome")
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        containerView.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(containerView)
        
        //TODO: - NaviView
        naviView.frame = CGRect(x: 0.0, y: statusH, width: screenWidth, height: 44.0)
        naviView.clipsToBounds = true
        naviView.backgroundColor = .clear
        view.addSubview(naviView)
        
        //TODO: - BackBtn
        backBtn.frame = CGRect(x: 20.0, y: 0.0, width: 44.0, height: 44.0)
        backBtn.setImage(UIImage(named: "icon-back"), for: .normal)
        backBtn.delegate = self
        backBtn.tag = 0
        backBtn.clipsToBounds = true
        naviView.addSubview(backBtn)
        
        //TODO: - ContentView
        let conW: CGFloat = screenWidth*0.95
        view.addSubview(contentView)
        
        cvHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightConstraint.priority = .defaultLow
        cvHeightConstraint.isActive = true
        
        nameTF.delegate = self
        passwordTF.delegate = self
        
        contentView.continueBtn.delegate = self
        
        let eyeTap = UITapGestureRecognizer(target: self, action: #selector(eyeDidTap))
        eyeImageView.isUserInteractionEnabled = true
        eyeImageView.addGestureRecognizer(eyeTap)
        
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(termsDidTap))
        termsTap.numberOfTouchesRequired = 1
        contentView.termsLbl.isUserInteractionEnabled = true
        contentView.termsLbl.addGestureRecognizer(termsTap)
        
        //TODO: - TitleLbl
        let posX: CGFloat = (screenWidth - conW)/2 + 20
        titleLbl.font = UIFont(name: FontName.ppBold, size: 30.0)
        titleLbl.text = "Sign Up".localized()
        titleLbl.textColor = .white
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: conW),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: posX),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -20.0),
        ])
    }
    
    @objc private func eyeDidTap() {
        eyeShow = !eyeShow
        eyeImageView.image = UIImage(named: eyeShow ? "icon-eyeOff" : "icon-eyeOn")
        passwordTF.isSecureTextEntry = !eyeShow
    }
    
    @objc private func termsDidTap(_ sender: UITapGestureRecognizer) {
        let termsRange = NSString(string: termsLbl.text!).range(of: contentView.termsOfService)
        
        if sender.didTapAttributedTextInLabel(label: termsLbl, inRange: termsRange) {
            let vc = TermsConditionsVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - Observer

extension SignUpVC {
    
    private func setupObserver() {
        didBecomeActiveObs = NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if self.verify {
                let hud = HUD.hud(kWindow)
                
                User.reloadUser {
                    if User.emailVerified() {
                        User.signIn(email: self.emailTxt, password: self.passwordTxt) { auth, error in
                            if let error = error {
                                hud.removeHUD {}
                                self.showError(mes: error.localizedDescription)
                                
                            } else if let _ = auth {
                                User.reloadUser {
                                    self.verify = false
                                    
                                    Connect.connected(online: .online)
                                    self.delegate?.signUpHandler(self)
                                    hud.removeHUD {}
                                }
                            }
                        }
                        
                    } else {
                        hud.removeHUD {}
                        self.errorAlert()
                    }
                }
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension SignUpVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
            
        } else if sender.tag == 1 { //Continue
            nameTF.resignFirstResponder()
            passwordTF.resignFirstResponder()
            
            guard !agree else { return }
            
            if nameTxt == "" || !nameTxt.containsOnlyLetters {
                setupAnimBorderView(nameTF)
                return
            }
            
            if passwordTxt.count < 8 {
                setupAnimBorderView(passwordTF)
                return
            }
            
            borderView(nameTF)
            borderView(passwordTF)
            
            print("nameTxt: \(nameTxt)")
            print("emailTxt: \(emailTxt)")
            print("passwordTxt: \(passwordTxt)")
            
            let hud = HUD.hud(kWindow)
            agree = true
            
            User.createAccount(email: emailTxt, password: passwordTxt) { auth, error in
                if let error = error {
                    hud.removeHUD {}
                    self.agree = false
                    self.showError(mes: error.localizedDescription)
                    
                } else if let auth = auth {
                    defaults.set(auth.user.uid, forKey: User.userUID)
                    
                    let model = UserModel(uid: auth.user.uid,
                                          email: self.emailTxt,
                                          fullName: self.nameTxt,
                                          phoneNumber: "",
                                          avatarLink: nil,
                                          createdTime: longFormatter().string(from: Date()),
                                          type: TypeModel.email,
                                          tokenKey: appDL.tokenKey,
                                          didUpdate: true)
                    let user = User(model: model)
                    
                    user.saveUser { error in
                        hud.removeHUD {}
                        
                        if let error = error {
                            self.agree = false
                            self.showError(mes: error.localizedDescription)
                            
                        } else {
                            User.emailVerification {
                                self.errorAlert()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func errorAlert() {
        showAlert(title: "Email Verification".localized(), mes: "Please visit your email address for verification".localized()) {
            self.verify = true
            
            if let url = URL(string: "message://"),
                let otherURL = URL(string: "https://mail.google.com/")
            {
                WebService.shared.goToURL(url, otherURL: otherURL)
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTF {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               text.count >= 8 {
                passwordTxt = text
                
            } else {
                passwordTxt = ""
            }
            
        } else if textField == nameTF {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                text.containsOnlyLetters {
                nameTxt = text
                
            } else {
                nameTxt = ""
            }
        }
    }
}
