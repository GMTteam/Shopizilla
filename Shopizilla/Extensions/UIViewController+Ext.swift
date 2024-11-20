//
//  UIViewController+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 10/12/2021.
//

import UIKit
import MessageUI

extension UIViewController {
    
    ///Thông báo lỗi
    func showError(mes: String) {
        let alert = UIAlertController(title: "Error".localized() + "!!!", message: mes, preferredStyle: .alert)
        let okAct = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        
        alert.addAction(okAct)
        present(alert, animated: true, completion: nil)
    }
    
    ///Cho phép một Act bên trong OK
    func showAlert(title: String?, mes: String?, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: mes, preferredStyle: .alert)
        let okAct = UIAlertAction(title: "OK".localized(), style: .default) { _ in
            completion()
        }
        
        alert.addAction(okAct)
        present(alert, animated: true, completion: nil)
    }
    
    ///Cho phép Act theo yêu cầu
    func showAlert(title: String?, mes: String?, act1: String?, act2: String?, completion1: @escaping () -> Void, completion2: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: mes, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: act1, style: .default) { _ in
            completion1()
        }
        let action2 = UIAlertAction(title: act2, style: .default) { _ in
            completion2()
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    ///UIActivityViewController
    func share(_ shortlink: String) {
        let items: [Any] = [shortlink]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = view
        present(vc, animated: true, completion: nil)
    }
    
    func shareOnMessages(_ link: String) {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = self
        vc.recipients = []
        vc.body = link
        
        if MFMessageComposeViewController.canSendText() {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: - MFMessageComposeViewControllerDelegate

extension UIViewController: MFMessageComposeViewControllerDelegate {
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
