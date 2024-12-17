//
//  PhotoAlertVC.swift
//  Zilla NFTs
//
//  Created by Anh Tu on 11/12/2021.
//

import UIKit

protocol PhotoAlertVCDelegate: AnyObject {
    func photoFromLibrary()
    func takePhoto()
}

class PhotoAlertVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: PhotoAlertVCDelegate?
    
    private let containerView = UIView()
    
    private let fromLibraryView = UIView()
    private let takePhotoView = UIView()
    private let cancelView = UIView()
    
    private let fromLibraryBtn = ButtonAnimation()
    private let takePhotoBtn = ButtonAnimation()
    private let cancelBtn = ButtonAnimation()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
}

//MARK: - Setups

extension PhotoAlertVC {
    
    private func setupViews() {
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        //TODO: - FromLibraryBtn
        let libAttr = createMutableAttributedString(fgColor: .black, txt: "Photo From Library".localized())
        setupBtn(fromLibraryView, btn: fromLibraryBtn, attr: libAttr, tag: 1)
        
        fromLibraryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        fromLibraryBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //TODO: - TakePhotoBtn
        let takeAttr = createMutableAttributedString(fgColor: .black, txt: "Take Photo".localized())
        setupBtn(takePhotoView, btn: takePhotoBtn, attr: takeAttr, tag: 2)
        
        takePhotoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        takePhotoBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        //TODO: - CancelBtn
        let cancelAttr = createMutableAttributedString(fgColor: .black, txt: "Cancel".localized())
        setupBtn(cancelView, btn: cancelBtn, attr: cancelAttr, tag: 3)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            cancelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            takePhotoView.bottomAnchor.constraint(equalTo: cancelBtn.topAnchor, constant: -10.0),
            fromLibraryView.bottomAnchor.constraint(equalTo: takePhotoBtn.topAnchor, constant: -1.0),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        tap.numberOfTouchesRequired = 1
        containerView.addGestureRecognizer(tap)
        
        setupAnim()
    }
    
    private func setupBtn(_ parentView: UIView, btn: ButtonAnimation, attr: NSMutableAttributedString, tag: Int) {
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = 10.0
        parentView.backgroundColor = .white
        view.addSubview(parentView)
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        btn.setAttributedTitle(attr, for: .normal)
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.delegate = self
        btn.tag = tag
        btn.layer.cornerRadius = 10.0
        parentView.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            parentView.widthAnchor.constraint(equalToConstant: screenWidth*0.9),
            parentView.heightAnchor.constraint(equalToConstant: 50.0),
            parentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            btn.topAnchor.constraint(equalTo: parentView.topAnchor),
            btn.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
    
    private func setTransform(_ trans: CGAffineTransform) {
        fromLibraryView.transform = trans
        takePhotoView.transform = trans
        cancelView.transform = trans
        
        fromLibraryBtn.transform = trans
        takePhotoBtn.transform = trans
        cancelBtn.transform = trans
    }
    
    private func setupAnim() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        setTransform(CGAffineTransform(translationX: 0.0, y: screenHeight))
        
        UIView.animate(withDuration: 0.5) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.setTransform(.identity)
        }
    }
    
    @objc private func removeDidTap() {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.setTransform(CGAffineTransform(translationX: 0.0, y: screenHeight))
            
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension PhotoAlertVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 {
            removeHandler {
                self.delegate?.photoFromLibrary()
            }
            
        } else if sender.tag == 2 {
            removeHandler {
                self.delegate?.takePhoto()
            }
            
        } else if sender.tag == 3 {
            removeDidTap()
        }
    }
}
