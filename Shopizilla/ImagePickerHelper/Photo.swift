//
//  Photo.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit
import MobileCoreServices

class Photo: NSObject {
    
    static let shared = Photo()
    
    override init() {
        super.init()
    }
    
    func takePhoto(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let image = kUTTypeImage as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPC.sourceType = .camera
            
            if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image]
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    imgPC.cameraDevice = .front
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    imgPC.cameraDevice = .rear
                }
            }
            
        } else {
            return
        }
        
        imgPC.showsCameraControls = true
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .custom
        vc.present(imgPC, animated: true, completion: nil)
    }

    func photoFromLibrary(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let image = kUTTypeImage as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ||
            !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPC.sourceType = .photoLibrary
            
            if let available = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image]
                }
            }
            
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imgPC.sourceType = .savedPhotosAlbum
            
            if let available = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image]
                }
            }
            
        } else {
            return
        }
        
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .custom
        vc.present(imgPC, animated: true, completion: nil)
    }

    func videoFromLibrary(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let movie = kUTTypeMovie as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ||
            !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPC.sourceType = .photoLibrary
            
            if let available = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if available.contains(movie) {
                    imgPC.mediaTypes = [movie]
                }
            }
            
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imgPC.sourceType = .savedPhotosAlbum
            
            if let available = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if available.contains(movie) {
                    imgPC.mediaTypes = [movie]
                }
            }
            
        } else {
            return
        }
        
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .custom
        vc.present(imgPC, animated: true, completion: nil)
    }

    func video(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let movie = kUTTypeMovie as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPC.sourceType = .camera
            
            if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
                if available.contains(movie) {
                    imgPC.mediaTypes = [movie]
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    imgPC.cameraDevice = .front
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    imgPC.cameraDevice = .rear
                }
            }
            
        } else {
            return
        }
        
        imgPC.showsCameraControls = true
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .custom
        vc.present(imgPC, animated: true, completion: nil)
    }

    func camera(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let image = kUTTypeImage as String
        let movie = kUTTypeMovie as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPC.sourceType = .camera
            
            if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image, movie]
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    imgPC.cameraDevice = .front
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    imgPC.cameraDevice = .rear
                }
            }
            
        } else {
            return
        }
        
        imgPC.showsCameraControls = true
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .custom
        vc.present(imgPC, animated: true, completion: nil)
    }
}
