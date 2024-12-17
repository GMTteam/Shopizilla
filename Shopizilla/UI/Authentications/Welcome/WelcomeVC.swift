//
//  WelcomeVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class WelcomeVC: UIViewController {

    // MARK: - Properties
    private let bgImageView = UIImageView()
    private let containerView = UIView()
    private let contentView = WelContentView()
    private let titleLbl = UILabel()
    
    private var emailTF: EmailTF { return contentView.emailTF }
    
    private var emailTxt = ""
    private var user: User? //Đăng nhập với email
    
    private let fbBtn = FBLoginButton() //Facebook
    private var currentNonce: String?
    
    private var resetPassword = false
    private var didBecomeActiveObs: Any?
    
    private var cvHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !defaults.bool(forKey: WebService.shared.purchaseKey) && !checkPurchase() {
            goToPurchaseVC(viewController: self) {
                self.setupViews()
            }
            
        } else {
            setupViews()
        }
        
        didBecomeActiveObs = NotificationCenter.default.addObserver(forName: .didBecomeActive, object: nil, queue: nil) { _ in
            if self.resetPassword {
                let vc = SignInVC()
                vc.user = self.user
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        (navigationController as? NavigationController)?.darkBarStyle = true
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        emailTF.text = emailTxt
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

extension WelcomeVC {
    
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
        
        //TODO: - ContentView
        let conW: CGFloat = screenWidth*0.95
        view.addSubview(contentView)
        
        cvHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightConstraint.priority = .defaultLow
        cvHeightConstraint.isActive = true
        
        emailTF.delegate = self
        
        contentView.continueBtn.delegate = self
        contentView.guestBtn.delegate = self
        contentView.forgotBtn.delegate = self
        
        contentView.facebookView.delegate = self
        contentView.googleView.delegate = self
        contentView.appleView.delegate = self
        
        //Apple
        contentView.appleBtn.addTarget(self, action: #selector(appleDidTap), for: .touchDown)
        
        //TODO: - TitleLbl
        let posX: CGFloat = (screenWidth - conW)/2 + 20
        titleLbl.font = UIFont(name: FontName.ppBold, size: 30.0)
        titleLbl.text = "Hi!".localized()
        titleLbl.textColor = .white
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: conW),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: posX),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -20.0),
        ])
    }
    
    private func dismissHandler(vc: UIViewController) {
        vc.view.window?.rootViewController?.dismiss(animated: true, completion: {
            appDL.setupNotification(UIApplication.shared)
        })
    }
}

//MARK: - GetData

extension WelcomeVC {
    
    private func getCurrentUser() {
        defaults.set(true, forKey: User.signOutKey)
        
        //Khi người dùng đăng nhập
        User.fetchCurrentUser { user in
            appDL.currentUser = user
            
            //Đẩy một thông báo khi người dùng cập nhật gì đó
            NotificationCenter.default.post(name: .signInKey, object: nil)
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension WelcomeVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        guard checkPurchase() else {
            goToPurchaseVC(viewController: self) {}
            return
        }
        
        if sender.tag == 0 { //Continue
            emailTF.resignFirstResponder()

            if emailTxt.count == 0 || emailTxt == "" || !emailTxt.isValidEmail {
                setupAnimBorderView(emailTF)
                return
            }

            borderView(emailTF)
            print(emailTxt)

            let hud = HUD.hud(kWindow)

            User.fetchUserByEmail(emailTxt) { user in
                hud.removeHUD {}
                
                if let user = user {
                    let vc = SignInVC()
                    vc.user = user
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc = SignUpVC()
                    vc.emailTxt = self.emailTxt
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        } else if sender.tag == 1 { //Guest
            defaults.set(true, forKey: "BrowseAsAGuestKey")
            dismissHandler(vc: self)
            
        } else if sender.tag == 2 { //Forgot
            emailTF.resignFirstResponder()
            
            if emailTxt.count == 0 || emailTxt == "" || !emailTxt.isValidEmail {
                setupAnimBorderView(emailTF)
                return
            }

            borderView(emailTF)
            print(emailTxt)
            
            let hud = HUD.hud(kWindow)
            
            User.fetchUserByEmail(emailTxt) { user in
                if let user = user {
                    self.user = user
                    
                    User.resetPassword(email: self.emailTxt) { error in
                        hud.removeHUD {}
                        
                        if let error = error {
                            self.showError(mes: error.localizedDescription)
                            
                        } else {
                            self.resetPassword = true
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
}

//MARK: - SignInVCDelegate

extension WelcomeVC: SignInVCDelegate {
    
    func signInHander(_ vc: SignInVC) {
        getCurrentUser()
        dismissHandler(vc: vc)
    }
}

//MARK: - SignUpVCDelegate

extension WelcomeVC: SignUpVCDelegate {
    
    func signUpHandler(_ vc: SignUpVC) {
        getCurrentUser()
        dismissHandler(vc: vc)
    }
}

//MARK: - ViewAnimationDelegate

extension WelcomeVC: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if sender.tag == 1 { //Facebook
            let nonce = randomNonceStr()
            currentNonce = nonce
            
            fbBtn.delegate = self
            fbBtn.loginTracking = .limited
            fbBtn.nonce = sha256(nonce)
            
            fbBtn.sendActions(for: .touchUpInside)
            
        } else if sender.tag == 2 { //Google
            googleDidTap()
            
        } else if sender.tag == 3 { //Apple
            contentView.appleBtn.sendActions(for: .touchDown)
        }
    }
}

//MARK: - UITextFieldDelegate

extension WelcomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               text.count != 0,
               text.isValidEmail {
                emailTxt = text
                
            } else {
                emailTxt = ""
            }
        }
    }
}

//MARK: - Sign In With Facebook

extension WelcomeVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        facebookDidTap()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        LoginManager().logOut()
    }
    
    private func facebookDidTap() {
        guard let idToken = AuthenticationToken.current?.tokenString else { return }
        guard let nonce = currentNonce else { fatalError() }
        
        let hud = HUD.hud(kWindow)
        let credential = OAuthProvider.credential(withProviderID: "facebook.com", idToken: idToken, rawNonce: nonce)
        
        User.signInWithCredential(credential) { result, error in
            if let error = error {
                print("signInWithFacebook error: \(error.localizedDescription)")
                
            } else if let result = result {
                print("Facebook Successfully")
                self.signInWith(result, type: TypeModel.fb, hud: hud)
            }
        }
    }
}

//MARK: - Sign In With Google

extension WelcomeVC {
    
    private func googleDidTap() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { ggUser, error in
            if let error = error {
                print("signInWithGoogle error: \(error.localizedDescription)")
                
            } else if let ggUser = ggUser {
                let auth = ggUser.authentication
                guard let idToken = auth.idToken else { return }
                
                let hud = HUD.hud(kWindow)
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
                
                User.signInWithCredential(credential) { result, error in
                    if let error = error {
                        print("signInWithGoogle error: \(error.localizedDescription)")
                        
                    } else if let result = result {
                        print("Google Successfully")
                        self.signInWith(result, type: TypeModel.gg, hud: hud)
                    }
                }
            }
        }
    }
    
    private func signInWith(_ result: AuthDataResult, type: String, hud: HUD) {
        let socialUser = result.user
        defaults.set(socialUser.uid, forKey: User.userUID)
        
        User.reloadUser {
            User.checkUserAddedInfo(userID: socialUser.uid) { didUpdate in
                //Nếu người dùng chưa đăng nhập lần đầu. Thì lưu thông tin
                if !didUpdate {
                    let model = UserModel(uid: socialUser.uid,
                                          email: socialUser.email ?? "",
                                          fullName: socialUser.displayName ?? "",
                                          phoneNumber: socialUser.phoneNumber ?? "",
                                          avatarLink: socialUser.photoURL?.absoluteString ?? nil,
                                          createdTime: longFormatter().string(from: Date()),
                                          type: type,
                                          tokenKey: appDL.tokenKey,
                                          didUpdate: true)
                    let user = User(model: model)
                    
                    user.saveUser { error in
                        hud.removeHUD {}
                        
                        if let error = error {
                            self.showError(mes: error.localizedDescription)
                            
                        } else {
                            Connect.connected(online: .online)
                            
                            self.getCurrentUser()
                            self.dismissHandler(vc: self)
                        }
                    }
                    
                } else {
                    //Người dùng đăng nhập lần 2. Cho phép đăng nhập
                    Connect.connected(online: .online)
                    User.updateTokenKey(userUID: socialUser.uid) { error in
                        if let error = error {
                            print("updateTokenKey error: \(error.localizedDescription)")
                        }
                        
                        hud.removeHUD {}
                        
                        self.getCurrentUser()
                        self.dismissHandler(vc: self)
                    }
                }
            }
        }
    }
}

//MARK: - Sign In With Apple

extension WelcomeVC {
    
    @objc func appleDidTap(_ sender: ASAuthorizationAppleIDButton) {
        let nonce = self.randomNonceStr()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorization = ASAuthorizationController(authorizationRequests: [request])
        authorization.delegate = self
        authorization.presentationContextProvider = self
        authorization.performRequests()
    }
    
    private func randomNonceStr(length: Int = 32) -> String {
        precondition(length > 0)
        
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map({ _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError()
                }
                
                return random
            })
            
            randoms.forEach({
                if remainingLength == 0 {
                    return
                }
                
                if $0 < charset.count {
                    result.append(charset[Int($0)])
                    remainingLength -= 1
                }
            })
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedStr = hashedData.compactMap({ return String(format: "%02x", $0) }).joined()
        return hashedStr
    }
}

//MARK: - ASAuthorizationControllerDelegate

extension WelcomeVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        guard let nonce = currentNonce else { fatalError() }
        guard let appleIDToken = appleIDCredential.identityToken else { return }
        guard let idToken = String(data: appleIDToken, encoding: .utf8) else { return }
        
        let hud = HUD.hud(kWindow)
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        
        User.signInWithCredential(credential) { result, error in
            if let error = error {
                print("signInWithApple error: \(error.localizedDescription)")
                
            } else if let result = result {
                print("Apple Successfully")
                self.signInWith(result, type: TypeModel.apple, hud: hud)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("signInWithApple error: \(error)")
    }
}

//MARK: - ASAuthorizationControllerPresentationContextProviding

extension WelcomeVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
