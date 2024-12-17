//
//  SignInVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit

protocol SignInVCDelegate: AnyObject {
    func signInHander(_ vc: SignInVC)
}

class SignInVC: UIViewController {

    // MARK: - Properties
    weak var delegate: SignInVCDelegate?
    
    private let naviView = UIView()
    private let backBtn = ButtonAnimation()
    private let containerView = UIView()
    private let bgImageView = UIImageView()
    private let contentView = SignInContentView()
    private let titleLbl = UILabel()
    
    private var passwordTF: EmailTF { return contentView.passwordTF }
    private var eyeImageView: UIImageView { return contentView.eyeImageView }
    
    var user: User?
    private var emailTxt = ""
    
    private var eyeShow = false
    private var passwordTxt = ""
    private var verify = false
    
    private var cvHeightConstraint: NSLayoutConstraint!
    private var cvCenterYConstraint: NSLayoutConstraint!
    
    private var didBecomeActiveObs: Any?
    private var willShowObs: Any?
    private var willHideObs: Any?
    
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
        
        contentView.avatarImageView.image = nil
        contentView.avatarImageView.backgroundColor = .lightGray
        
        getUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: didBecomeActiveObs)
        removeObserverBy(observer: willShowObs)
        removeObserverBy(observer: willHideObs)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Setups

extension SignInVC {
    
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
        
        cvCenterYConstraint = contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        cvCenterYConstraint.isActive = true
        
        passwordTF.delegate = self
        
        contentView.continueBtn.delegate = self
        contentView.forgotBtn.delegate = self
        
        let eyeTap = UITapGestureRecognizer(target: self, action: #selector(eyeDidTap))
        eyeImageView.isUserInteractionEnabled = true
        eyeImageView.addGestureRecognizer(eyeTap)
        
        //TODO: - TitleLbl
        let posX: CGFloat = (screenWidth - conW)/2 + 20
        titleLbl.font = UIFont(name: FontName.ppBold, size: 30.0)
        titleLbl.text = "Log In".localized()
        titleLbl.textColor = .white
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: conW),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: posX),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -20.0),
        ])
    }
    
    @objc private func eyeDidTap() {
        eyeShow = !eyeShow
        eyeImageView.image = UIImage(named: eyeShow ? "icon-eyeOff" : "icon-eyeOn")
        passwordTF.isSecureTextEntry = !eyeShow
    }
}

//MARK: - Observer

extension SignInVC {
    
    private func setupObserver() {
        didBecomeActiveObs = NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if self.verify {
                let hud = HUD.hud(kWindow)
                
                User.reloadUser {
                    if User.emailVerified() {
                        self.verify = false
                        Connect.connected(online: .online)
                        
                        if let userUID = defaults.string(forKey: User.userUID) {
                            User.updateTokenKey(userUID: userUID) { error in
                                if let error = error {
                                    print("updateTokenKey error: \(error.localizedDescription)")
                                }
                                
                                hud.removeHUD {}
                                self.delegate?.signInHander(self)
                            }
                            
                        } else {
                            hud.removeHUD {}
                            self.delegate?.signInHander(self)
                        }
                        
                    } else {
                        hud.removeHUD {}
                        self.errorAlert()
                    }
                }
                
                return
            }
        }
        willShowObs = NotificationCenter.default.addObserver(forName: .keyboardWillShow, object: nil, queue: nil) { notif in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.33) {
                self.cvCenterYConstraint.constant = -40
                self.view.layoutIfNeeded()
            }
        }
        willHideObs = NotificationCenter.default.addObserver(forName: .keyboardWillHide, object: nil, queue: nil) { notif in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.33) {
                self.cvCenterYConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - GetData

extension SignInVC {
    
    private func getUser() {
        if let user = user {
            if let link = user.avatarLink {
                DownloadImage.shared.downloadImage(link: link) { image in
                    self.contentView.avatarImageView.image = image
                }
            }
            
            contentView.nameLbl.text = user.fullName
            contentView.emailLbl.text = user.email
            emailTxt = user.email
            
            if user.email == "hoangnguyenmtv75@gmail.com" {
                passwordTxt = "11111111"
                contentView.passwordTF.text = passwordTxt
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension SignInVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
            
        } else if sender.tag == 1 { //Continue
            passwordTF.resignFirstResponder()
            
            if passwordTxt.count < 8 {
                setupAnimBorderView(passwordTF)
                return
            }
            
            borderView(passwordTF)
            print(emailTxt, passwordTxt)
            
            let hud = HUD.hud(kWindow)
            
            User.signIn(email: emailTxt, password: passwordTxt) { auth, error in
                if let error = error {
                    hud.removeHUD {}
                    self.showError(mes: error.localizedDescription)
                    
                } else if let auth = auth {
                    defaults.set(auth.user.uid, forKey: User.userUID)
                    
                    User.reloadUser {
                        if User.emailVerified() {
                            Connect.connected(online: .online)
                            
                            User.updateTokenKey(userUID: auth.user.uid) { error in
                                if let error = error {
                                    print("updateTokenKey error: \(error.localizedDescription)")
                                }
                                
                                hud.removeHUD {}
                                self.delegate?.signInHander(self)
                            }
                            
                        } else {
                            hud.removeHUD {}
                            self.errorAlert()
                        }
                    }
                }
            }
            
        } else if sender.tag == 2 { //Forgot
            let hud = HUD.hud(kWindow)
            
            User.fetchUserByEmail(emailTxt) { user in
                if user != nil {
                    User.resetPassword(email: self.emailTxt) { error in
                        hud.removeHUD {}
                        
                        if let error = error {
                            self.showError(mes: error.localizedDescription)
                            
                        } else {
                            self.showAlert(title: "Reset Password".localized(), mes: "Check your mail. Thanks!".localized()) {
                                if let url = URL(string: "message://"),
                                   let otherURL = URL(string: "https://mail.google.com/") {
                                    WebService.shared.goToURL(url, otherURL: otherURL)
                                }
                            }
                        }
                    }
                    
                } else {
                    hud.removeHUD {}
                    self.showError(mes: "Email address does not exist.".localized())
                }
            }
        }
    }
    
    private func errorAlert() {
        let title = "Email Verification".localized()
        let mes = "Please visit your email address for verification.".localized() + "\n" + "If you choose OK, will access your mail.".localized() + "\n" + "If you have not received the verification email, select Verify.".localized()
        
        showAlert(title: title, mes: mes, act1: "OK".localized(), act2: "Verify".localized()) {
            print("OK")
            self.emailVerification()
            
        } completion2: {
            print("Verify")
            let hud = HUD.hud(kWindow)
            
            User.emailVerification {
                hud.removeHUD {}
                self.emailVerification()
            }
        }
    }
    
    private func emailVerification() {
        verify = true
        
        if let url = URL(string: "message://"), let otherURL = URL(string: "https://mail.google.com/") {
            WebService.shared.goToURL(url, otherURL: otherURL)
        }
    }
}

//MARK: - UITextFieldDelegate

extension SignInVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        }
    }
}
