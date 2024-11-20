//
//  FirebaseStorage.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/04/2022.
//

import UIKit
import Firebase
import AVFoundation

class FirebaseStorage {
    
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
    }
}

//MARK: - Save Avatar

extension FirebaseStorage {
    
    func saveAvatar(userUID: String, completion: @escaping (String?) -> Void) {
        if let image = image {
            let imgSize = image.size
            let height = imgSize.width > imgSize.height ? imgSize.height : imgSize.width
            let setSize = CGSize(width: height, height: height)
            
            guard let squareImage = SquareImage.shared.squareImage(image, targetSize: setSize),
                  let data = squareImage.jpegData(compressionQuality: 1.0) else {
                      completion(nil)
                      return
                  }
            
            let ref = Storage.storage().reference(withPath: "Avatars").child(userUID)
            ref.putData(data, metadata: nil) { metadata, error in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                ref.downloadURL { url, error in
                    guard let url = url, error == nil else {
                        completion(nil)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(url.absoluteString)
                    }
                }
            }
        }
    }
    
    func deleteAvatar(userUID: String, completion: @escaping (Error?) -> Void) {
        let ref = Storage.storage().reference(withPath: "Avatar").child(userUID)
        ref.delete(completion: completion)
    }
}

//MARK: - GetBanner

extension FirebaseStorage {
    
    /*
    ///Lấy tất cả đường dẫn bên trong thư mục Banners
    static func getBanner(completion: @escaping ([String]) -> Void) {
        let group = DispatchGroup()
        var array: [String] = []
        
        group.enter()
        
        let ref = Storage.storage().reference(withPath: "Banners")
        ref.listAll { result, error in
            if let error = error {
                group.leave()
                print("listAll error: \(error.localizedDescription)")
                
            } else if let result = result {
                result.items.forEach({
                    ref.child($0.name).downloadURL { url, error in
                        if let error = error {
                            group.leave()
                            print("getBanner error: \(error.localizedDescription)")

                        } else if let url = url {
                            array.append(url.absoluteString)
                            
                            if result.items.count == array.count {
                                group.leave()
                            }
                        }
                    }
                })
            }
        }
        
        group.notify(queue: .main) {
            array = array.shuffled()
            completion(array)
        }
    }
    */
}

//MARK: - Save Review

extension FirebaseStorage {
    
    func saveReview(completion: @escaping (String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        guard let data = image?.resizeImage().pngData() ?? image?.resizeImage().jpegData(compressionQuality: 1.0) else {
            completion(nil)
            return
        }
        let uuid = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "Reviews")
            .child(userID)
            .child(uuid)

        ref.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                print("putData error: \(error.localizedDescription)")
                completion(nil)

            } else {
                ref.downloadURL { url, error in
                    var link: String?

                    if let error = error {
                        print("downloadURL error: \(error.localizedDescription)")

                    } else if let url = url {
                        link = url.absoluteString
                    }
                    
                    completion(link)
                }
            }
        }
    }
    
    class func deleteReview(imgUID: String, completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let ref = Storage.storage().reference(withPath: "Reviews")
            .child(userID)
            .child(imgUID)
        
        ref.delete { error in
            if let error = error {
                print("deleteReview error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}

//MARK: - Chat

extension FirebaseStorage {
    
    func saveChat(chatUID: String, completion: @escaping (String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        guard let data = image?.resizeImage().pngData() ?? image?.resizeImage().jpegData(compressionQuality: 1.0) else {
            completion(nil)
            return
        }
        
        let ref = Storage.storage().reference(withPath: "Chats")
            .child(userID)
            .child(chatUID)

        ref.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                print("putData error: \(error.localizedDescription)")
                completion(nil)

            } else {
                ref.downloadURL { url, error in
                    var link: String?

                    if let error = error {
                        print("downloadURL error: \(error.localizedDescription)")

                    } else if let url = url {
                        link = url.absoluteString
                    }
                    
                    completion(link)
                }
            }
        }
    }
    
    class func deleteChat(imgUID: String, completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        let ref = Storage.storage().reference(withPath: "Chats")
            .child(userID)
            .child(imgUID)
        
        ref.delete { error in
            if let error = error {
                print("deleteReview error: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}
