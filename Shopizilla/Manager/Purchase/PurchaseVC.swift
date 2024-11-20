//
//  PurchaseVC.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/06/2022.
//

import UIKit

class PurchaseVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var purchaseTF: PurchaseTF!
    @IBOutlet weak var verifyBtn: ButtonAnimation!
    @IBOutlet weak var whereBtn: ButtonAnimation!
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK: - Properties
    private var purchaseCode = ""

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: - Setups

extension PurchaseVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        //TODO: - Btn
        if #available(iOS 15, *) {
            verifyBtn.configuration = .plain()
            whereBtn.configuration = .plain()
        }
        
        verifyBtn.tag = 1
        whereBtn.tag = 2
        
        verifyBtn.delegate = self
        whereBtn.delegate = self
        
        verifyBtn.isUserInteractionEnabled = false
        verifyBtn.alpha = 0.3
        
        stackView.setCustomSpacing(10, after: titleLbl)
        purchaseTF.delegate = self
        purchaseTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        titleLbl.textColor = .black
        purchaseTF.textColor = .black
        verifyBtn.backgroundColor = UIColor(hex: 0x42433E)
        
        let verifyAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 16.0)!,
            .foregroundColor: UIColor.white
        ]
        let verifyAttr = NSMutableAttributedString(string: "Verify", attributes: verifyAtt)
        verifyBtn.setAttributedTitle(verifyAttr, for: .normal)
        
        let whereAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 14.0)!,
            .foregroundColor: UIColor.link
        ]
        let whereAttr = NSMutableAttributedString(string: "Where Is My Purchase Code?", attributes: whereAtt)
        whereBtn.setAttributedTitle(whereAttr, for: .normal)
    }
    
    @objc private func editingChanged(_ tf: UITextField) {
        var isBool = false
        
        if let text = tf.text,
           !text.trimmingCharacters(in: .whitespaces).isEmpty,
           text.count >= 36 {
            isBool = true
        }
        
        verifyBtn.isUserInteractionEnabled = isBool
        verifyBtn.alpha = isBool ? 1.0 : 0.3
    }
}

//MARK: - ButtonAnimationDelegate

extension PurchaseVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        let shared = WebService.shared
        
        if sender.tag == 1 { //Verify
            purchaseTF.resignFirstResponder()
            
            guard purchaseCode != "" else { return }
            
            let hudSave = HUDSave.hud(kWindow)
            hudSave.belowTxt = NSString(string: "Verifying".localized() + "...")
            hudSave.backgroundColor = .black.withAlphaComponent(0.7)
            
            shared.fetchAESFrom { dict in
                let token = AES.getAESFromAirTable(dict)
                
                shared.fetchPurchaseInfo(purchaseCode: self.purchaseCode, token: token) { purchase, error in
                    appDL.purchase = purchase
                    hudSave.removeHUD {}
                    
                    if let error = error {
                        self.showAlert(title: "Error!!!", mes: error.localizedDescription) {}
                        
                    } else {
                        let name = shared.getDictFrom("AES.plist")["name"] as? String ?? ""
                        
                        if let purchase = appDL.purchase, purchase.name == name {
                            defaults.set(true, forKey: shared.purchaseKey)
                            shared.saveJSONFile(shared.purchaseName, dataAny: purchase.dict)
                            self.dismiss(animated: true)
                            
                        } else {
                            self.showAlert(title: "Purchase Code Is incorrect", mes: " \nCan't verify with this purchase code.\nPlease try again.\nThanks!") {}
                        }
                    }
                }
            }
            
        } else if sender.tag == 2 { //Where
            shared.goToLink(shared.getDictFrom("AES.plist")["myCode"] as? String ?? "")
        }
    }
}

//MARK: - UITextFieldDelegate

extension PurchaseVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text,
           !text.trimmingCharacters(in: .whitespaces).isEmpty,
           text.count >= 36 {
            purchaseCode = text
            
        } else {
            purchaseCode = ""
        }
    }
}

public func goToPurchaseVC(viewController: UIViewController, completion: @escaping () -> Void) {
    let vc = PurchaseVC()
    vc.modalPresentationStyle = .fullScreen
    
    DispatchQueue.main.async {
        viewController.present(vc, animated: true) {
            completion()
        }
    }
}

public func checkPurchase() -> Bool {
    if let purchase = appDL.purchase,
        purchase.name == WebService.shared.getDictFrom("AES.plist")["name"] as? String {
        return true
    }
    
    return false
}
