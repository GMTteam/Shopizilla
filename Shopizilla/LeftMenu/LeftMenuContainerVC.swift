//
//  LeftLeftMenuContainerVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 20/04/2022.
//

import UIKit

protocol LeftMenuContainerVCDelegate: AnyObject {
    func completionAnim(_ isComplete: Bool)
}

let menuWidth: CGFloat = screenWidth*0.8

class LeftMenuContainerVC: UIViewController {

    //MARK: - Properties
    weak var delegate: LeftMenuContainerVCDelegate?
    
    let naviView = UIView()
    
    let leftMenuTVC: LeftMenuTVC
    let centerVC: UINavigationController
    
    let profileImageView = UIImageView()
    let nameLbl = UILabel()
    let cancelBtn = ButtonAnimation()
    
    var xPos: CGFloat = 0.0
    var isOpen = false
    let animDuration: TimeInterval = 0.5
    
    private var signInObs: Any?
    
    //MARK: - Initialize
    init(leftMenuTVC: LeftMenuTVC, centerVC: UINavigationController) {
        self.leftMenuTVC = leftMenuTVC
        self.centerVC = centerVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setMenu(0.0)
        
        signInObs = NotificationCenter.default.addObserver(forName: .signInKey, object: nil, queue: nil) { _ in
            self.updateProfile()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: signInObs)
    }
}

//MARK: - Setups

extension LeftMenuContainerVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        setNeedsStatusBarAppearanceUpdate()
        
        addChild(leftMenuTVC)
        view.addSubview(leftMenuTVC.view)
        leftMenuTVC.didMove(toParent: self)
        
        var naviH = centerVC.navigationBar.frame.height
        naviH = naviH == 44 ? 44+52 : naviH
        
        let height: CGFloat = naviH + statusH
        leftMenuTVC.headerHeight = height + 50
        
        naviView.frame = CGRect(x: -menuWidth, y: 0.0, width: menuWidth, height: height)
        naviView.backgroundColor = .clear
        naviView.clipsToBounds = true
        view.addSubview(naviView)
        
        //TODO: - ProfileImageView
        let prH: CGFloat = 60.0
        profileImageView.frame = CGRect(x: 20.0, y: height-prH-5, width: prH, height: prH)
        profileImageView.isHidden = !User.logged()
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "icon-profile")
        profileImageView.layer.cornerRadius = 60/2
        naviView.addSubview(profileImageView)
        
        //TODO: - NameLbl
        let nameW: CGFloat = menuWidth-40-50-(User.logged() ? prH : 0)-10
        let nameX: CGFloat = 20 + (User.logged() ? prH : 0) + 10
        nameLbl.frame = CGRect(x: nameX, y: height-50-5, width: nameW, height: 50)
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16)
        nameLbl.textColor = .black
        nameLbl.numberOfLines = 2
        naviView.addSubview(nameLbl)
        
        //TODO: - CancelLbl
        cancelBtn.frame = CGRect(x: menuWidth-20-40, y: height-5-40, width: 40, height: 40)
        cancelBtn.clipsToBounds = true
        cancelBtn.setImage(UIImage(named: "icon-backRight"), for: .normal)
        cancelBtn.delegate = self
        naviView.addSubview(cancelBtn)
        
        //TODO: - LeftMenuTVC
        leftMenuTVC.view.layer.anchorPoint.x = 1.0
        leftMenuTVC.view.frame = CGRect(x: -menuWidth, y: height, width: menuWidth, height: screenHeight)
        
        //let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //view.addGestureRecognizer(pan)
        
        updateProfile()
    }
    
    private func updateProfile() {
        profileImageView.image = UIImage(named: "icon-profile")
        
        let link = appDL.currentUser?.avatarLink ?? ""
        if link != "" {
            DownloadImage.shared.downloadImage(link: link) { image in
                let targetSize = CGSize(width: 60, height: 60)
                let newImg = SquareImage.shared.squareImage(image, targetSize: targetSize)
                self.profileImageView.image = newImg
            }
        }
        
        //TODO: - NameLbl
        let nameTxt = User.logged() ? (appDL.currentUser?.fullName ?? "Unamed") : ("Welcome to" + "\n" + "Shopizilla")
        nameLbl.text = nameTxt
    }
    
    @objc private func handlerRemoveMenu(_ sender: UITapGestureRecognizer) {
        toggleSideMenu()
        removeEffect()
    }
    
    func toggleSideMenu() {
        let isOpen = floor(centerVC.view.frame.origin.x/menuWidth)
        let targetProgress: CGFloat = isOpen == 1.0 ? 0.0 : 1.0
        setAnim(targetProgress)
    }
    
    private func setAnim(_ percent: CGFloat) {
        UIView.animate(withDuration: animDuration, animations: {
            self.setMenu(percent)
            
        }) { (_) in
            self.naviView.layer.shouldRasterize = false
            self.leftMenuTVC.view.layer.shouldRasterize = false
            self.delegate?.completionAnim(percent == 1)
        }
    }
    
    private func setMenu(_ percent: CGFloat) {
        centerVC.view.frame.origin.x = menuWidth * percent
        xPos = centerVC.view.frame.origin.x
        
        setAlpha(percent, view: leftMenuTVC.view, isTrans: true)
        setAlpha(percent, view: naviView, isTrans: true)
        setAlpha(percent, view: nameLbl, isTrans: false)
        setAlpha(percent, view: cancelBtn, isTrans: false)
    }
    
    private func setAlpha(_ percent: CGFloat, view: UIView, isTrans: Bool) {
        if isTrans {
            view.layer.transform = menuTransform(percent: percent)
        }
        
        view.alpha = max(0.2, percent)
    }
    
    @objc private func handlePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!.superview!)
        var progress = translation.x/menuWidth * (isOpen ? 1.0 : -1.0)
        progress = min(max(progress, 0.0), 1.0)
        
        switch sender.state {
        case .began:
            let isOpen = floor(centerVC.view.frame.origin.x/menuWidth)
            self.isOpen = isOpen == 1.0 ? false : true
            
            leftMenuTVC.view.layer.shouldRasterize = true
            leftMenuTVC.view.layer.rasterizationScale = UIScreen.main.scale
            
            naviView.layer.shouldRasterize = true
            naviView.layer.rasterizationScale = UIScreen.main.scale
            
        case .changed: setMenu(self.isOpen ? progress : (1 - progress))
        case .ended: fallthrough
        case .cancelled: fallthrough
        case .failed:
            var targetProgress: CGFloat
            if isOpen {
                targetProgress = progress < 0.5 ? 0.0 : 1.0
                
            } else {
                targetProgress = progress < 0.5 ? 1.0 : 0.0
            }
            
            setAnim(targetProgress)
        default: break
        }
    }
    
    private func menuTransform(percent: CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1/1000
        
        let remainingPercent = 1.0 - percent
        let angle = remainingPercent * .pi * -0.5
        
        let rotation = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
        let translation = CATransform3DMakeTranslation(menuWidth*percent, 0.0, 0.0)
        return CATransform3DConcat(rotation, translation)
    }
}

//MARK: - ButtonAnimationDelegate

extension LeftMenuContainerVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        toggleSideMenu()
        removeEffect()
    }
}

//MARK: - Create && Remove

func createMenuContainerView(_ tabBarController: UITabBarController?,
                             _ navigationC: UINavigationController?,
                             _ menuDL: LeftMenuContainerVCDelegate,
                             _ sideDL: LeftMenuTVCDelegate) -> LeftMenuContainerVC {
    let side = LeftMenuTVC()
    let leftMenuContainerVC = LeftMenuContainerVC(leftMenuTVC: side, centerVC: navigationC!)
    
    leftMenuContainerVC.view.frame = kWindow.bounds
    leftMenuContainerVC.leftMenuTVC.tabbarC = tabBarController as? TabBarController
    leftMenuContainerVC.leftMenuTVC.delegate = sideDL
    leftMenuContainerVC.delegate = menuDL
    leftMenuContainerVC.toggleSideMenu()
    kWindow.addSubview(leftMenuContainerVC.view)
    
    return leftMenuContainerVC
}

func removeMenuContainerView(_ leftMenuContainerVC: LeftMenuContainerVC?) {
    leftMenuContainerVC?.removeFromParent()
    leftMenuContainerVC?.view.removeFromSuperview()
}

func createEffect(_ isComplete: Bool, vc: UIViewController, selector: Selector) {
    kWindow.viewWithTag(777999)?.removeFromSuperview()

    /*
    let dimsView = UIView()
    dimsView.frame = CGRect(x: menuWidth, y: 0.0, width: menuWidth, height: screenHeight)
    dimsView.backgroundColor = .black.withAlphaComponent(0.1)
    dimsView.alpha = 0.0
    dimsView.tag = 777999
    kWindow.addSubview(dimsView)

    if isComplete {
        let tap = UITapGestureRecognizer(target: vc, action: selector)
        dimsView.isUserInteractionEnabled = true
        dimsView.addGestureRecognizer(tap)

        UIView.animate(withDuration: 0.15) {
            dimsView.alpha = 1.0
        }
    }
    */
    
    let effect = UIVisualEffectView()
    effect.effect = UIBlurEffect(style: .dark)
    effect.frame = CGRect(x: menuWidth, y: 0.0, width: menuWidth, height: screenHeight)
    effect.alpha = 0.0
    effect.tag = 777999
    kWindow.addSubview(effect)
    
    if isComplete {
        let tap = UITapGestureRecognizer(target: vc, action: selector)
        effect.isUserInteractionEnabled = true
        effect.addGestureRecognizer(tap)
        
        UIView.animate(withDuration: 0.15) {
            effect.alpha = 0.9
        }
    }
}

func removeEffect() {
    if let subview = kWindow.viewWithTag(777999) {
        UIView.animate(withDuration: 0.5, animations: {
            subview.frame.origin.x = 0.0
            subview.frame.size.width = kWindow.bounds.width
            subview.alpha = 0.0
            
        }) { (_) in
            subview.removeFromSuperview()
        }
    }
}
