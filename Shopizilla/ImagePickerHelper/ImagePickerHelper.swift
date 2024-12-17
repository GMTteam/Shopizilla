//
//  ImagePickerHelper.swift
//  Zilla NFTs
//
//  Created by Anh Tu on 11/12/2021.
//

import UIKit

class ImagePickerHelper: NSObject {
    
    var vc: UIViewController
    var completion: ((UIImage?) -> Void)
    let imagePicker = UIImagePickerController()
    
    init(vc: UIViewController, isTakePhoto: Bool, photoEdit: Bool = false, completion: @escaping (UIImage?) -> Void) {
        self.vc = vc
        self.completion = completion
        
        super.init()
        imagePicker.delegate = self
        
        let barNorTitleAttr = createAttributedString(fgColor: .white)
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.titleTextAttributes = barNorTitleAttr
        
        if isTakePhoto {
            Photo.shared.takePhoto(vc, imgPC: imagePicker, edit: photoEdit)
            
        } else {
            Photo.shared.photoFromLibrary(vc, imgPC: imagePicker, edit: photoEdit)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage ?? nil
        
        vc.dismiss(animated: true) {
            self.completion(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
