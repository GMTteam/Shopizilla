//
//  UserModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/04/2022.
//

import UIKit
import Firebase
import FBSDKLoginKit

struct TypeModel {
    static let email = "Sign In With Email"
    static let fb = "Sign In With Facebook"
    static let gg = "Sign In With Google"
    static let apple = "Sign In With Apple"
}

//MARK: - UserModel

struct UserModel {
    
    let uid: String
    let email: String
    let fullName: String
    let phoneNumber: String
    var avatarLink: String? = nil
    let createdTime: String
    let type: String
    let tokenKey: String
    let didUpdate: Bool
    
    var gender: String?
    var dateOfBirth: String?
    var coin: Double = 0.0
    
    var avatar: UIImage? = nil
    var connect: Connect?
}

//MARK: - User

class User {
    
    var model: UserModel
    
    var uid: String { return model.uid }
    var email: String { return model.email }
    var fullName: String { return model.fullName }
    var phoneNumber: String { return model.phoneNumber }
    var avatarLink: String? { return model.avatarLink }
    var createdTime: String { return model.createdTime }
    var type: String { return model.type }
    var tokenKey: String { return model.tokenKey }
    var didUpdate: Bool { return model.didUpdate }
    
    var gender: String? { return model.gender }
    var dateOfBirth: String? { return model.dateOfBirth }
    var coin: Double { return model.coin }
    
    var avatar: UIImage? { return model.avatar }
    var connects: Connect? { return model.connect }
    
    static let db = Firestore.firestore().collection("Users")
    static var listener: ListenerRegistration? //Người dùng hiện tại
    static var otherListener: ListenerRegistration? //Người dùng hiện tại
    
    ///Đăng xuất TK
    static let signOutKey = "SignOutKey"
    
    ///Xóa userUID khỏi UserDefault khi đăng xuất
    static let userUID = "UserUID"
    
    init(model: UserModel) {
        self.model = model
    }
}

//MARK: - Convenience

extension User {
    
    convenience init(dict: [String: Any]) {
        let uid = dict["uid"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let fullName = dict["fullName"] as? String ?? ""
        let phoneNumber = dict["phoneNumber"] as? String ?? ""
        let avatarLink = dict["avatarLink"] as? String
        let type = dict["type"] as? String ?? ""
        let createdTime = dict["createdTime"] as? String ?? ""
        let tokenKey = dict["tokenKey"] as? String ?? ""
        let didUpdate = dict["didUpdate"] as? Bool ?? false
        let gender = dict["gender"] as? String
        let dateOfBirth = dict["dateOfBirth"] as? String
        let coin = dict["coin"] as? Double ?? 0.0
        
        let model = UserModel(uid: uid,
                              email: email,
                              fullName: fullName,
                              phoneNumber: phoneNumber,
                              avatarLink: avatarLink,
                              createdTime: createdTime,
                              type: type,
                              tokenKey: tokenKey,
                              didUpdate: didUpdate,
                              gender: gender,
                              dateOfBirth: dateOfBirth,
                              coin: coin)
        self.init(model: model)
    }
}

//MARK: - Save

extension User {
    
    func saveUser(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
            .collection("Users")
            .document(uid)
        db.setData(toDictionary(), completion: completion)
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "createdTime": createdTime,
            "type": type,
            "tokenKey": tokenKey,
            "didUpdate": didUpdate,
            "coin": coin,
        ]
    }
}

//MARK: - Update

extension User {
    
    ///Cập nhật tokenKey cho currentUser
    class func updateTokenKey(userUID: String, completion: @escaping (Error?) -> Void) {
        let db = User.db.document(userUID)
        db.updateData(["tokenKey": appDL.tokenKey], completion: completion)
    }
    
    ///Cập nhật thông tin cho currentUser
    func updateInformation(dict: [String: Any], completion: @escaping (Error?) -> Void) {
        let db = User.db.document(uid)
        db.updateData(dict, completion: completion)
    }
    
    ///Cập nhật Point cho currentUser
    func updateCoin(coin: Double, completion: @escaping () -> Void) {
        let ref = User.db.document(uid)
        
        Firestore.firestore().runTransaction { transaction, errorPointer in
            let sfDocument: DocumentSnapshot
            
            do {
                try sfDocument = transaction.getDocument(ref)
                
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            //Quantity
            guard let oldQuantity = sfDocument.data()?["coin"] as? Double else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve quantity from snapshot \(sfDocument)"])
                errorPointer?.pointee = error
                return nil
            }
            
            let newCoin = oldQuantity + coin
            let toDict: [String: Any] = [
                "coin": newCoin
            ]
            
            guard newCoin >= 0.0 else { return nil }
            
            transaction.updateData(toDict, forDocument: ref)
            return nil
            
        } completion: { object, error in
            if let error = error {
                print("Transaction failed: \(error.localizedDescription)")
                
            } else if let object = object {
                print("SUCCESSFULLY: \(object)")
            }
            
            completion()
        }
    }
}

//MARK: - SignIn

extension User {
    
    ///Tạo tài khoản mới
    class func createAccount(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    ///Đăng nhập TK với AuthCredential
    class func signInWithCredential(_ credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential, completion: completion)
    }
    
    ///Đăng nhập vào tài khoản
    class func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    ///Đăng xuất TK
    class func signOut(completion: @escaping () -> Void) {
        defaults.setValue(false, forKey: User.signOutKey)
        LoginManager().logOut()
        
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: .signOutKey, object: nil)
            
            Connect.connected(online: .offline)
            defaults.removeObject(forKey: User.userUID)
            
            completion()
            
        } catch let error as NSError {
            print("signOut error: \(error.localizedDescription)")
        }
    }
    
    ///Tài khoản đã đăng nhập
    class func logged() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    ///Tải lại currentUser. Khi đăng nhập tài khoản khác
    class func reloadUser(completion: @escaping () -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion()
            return
        }
        
        currentUser.reload(completion: { error in
            if let error = error {
                print("reloadUser error: \(error.localizedDescription)")
            }
            
            completion()
        })
    }
    
    ///Xác thực lại người dùng. Trước khi xoá hoặc làm gì đó
    class func reauthentication(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil, nil)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        currentUser.reauthenticate(with: credential, completion: completion)
    }
    
    ///Kiểm tra email đã tồn tại
    class func checkUserAlreadyExists(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { emails, error in
            var exists = false
            if error == nil, let emails = emails {
                exists = emails.count != 0
            }
            
            completion(exists)
        }
    }
    
    ///Xác minh tài khoản
    class func emailVerification(completion: @escaping () -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if let error = error {
                print("emailVerification error: \(error.localizedDescription)")
            }
            
            completion()
        })
    }
    
    class func emailVerified() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        
        return user.isEmailVerified
    }
    
    class func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    class func isAdmin() -> Bool {
        return appDL.currentUser?.uid == WebService.shared.getAPIKey().adminID
    }
}

//MARK: - Fetch

extension User {
    
    ///Lấy tất cả User bên trong Database
    class func fetchAllUser(completion: @escaping ([User]) -> Void) {
        let db = User.db
        db.getDocuments { snapshot, error in
            var users: [User] = []
            
            if let error = error {
                print("fetchAllUser error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                users = snapshot.documents.map({ User(dict: $0.data()) })
            }
            
            DispatchQueue.main.async {
                completion(users)
            }
        }
    }
    
    ///Lấy 1 người dùng cụ thể.  'isListener: giá trị mặc định là true', dùng để lắng nghe các cập nhật của người dùng.
    class func fetchUser(userUID: String, isListener: Bool = true, completion: @escaping (User?) -> Void) {
        let db = User.db.document(userUID)
        
        if isListener {
            //Nếu có bất kỳ đăng ký thì hãy hủy
            otherListener?.remove()
            otherListener = nil
            
            otherListener = db.addSnapshotListener { snapshot, error in
                getUser(snapshot, error: error, completion: completion)
            }
            
        } else {
            db.getDocument { snapshot, error in
                getUser(snapshot, error: error, completion: completion)
            }
        }
    }
    
    ///Lấy người dùng hiện tại.  'isListener: giá trị mặc định là true', dùng để lắng nghe các cập nhật của người dùng.
    class func fetchCurrentUser(isListener: Bool = true, completion: @escaping (User?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let db = User.db.document(userUID)
        
        if isListener {
            //Nếu có bất kỳ đăng ký thì hãy hủy
            listener?.remove()
            listener = nil
            
            listener = db.addSnapshotListener { snapshot, error in
                getUser(snapshot, error: error, completion: completion)
            }
            
        } else {
            db.getDocument { snapshot, error in
                getUser(snapshot, error: error, completion: completion)
            }
        }
    }
    
    class private func getUser(_ snapshot: DocumentSnapshot?, error: Error?, completion: @escaping (User?) -> Void) {
        var user: User?
        
        if let error = error {
            print("fetchCurrentUser error: \(error.localizedDescription)")
            
        } else {
            if let dict = snapshot?.data() {
                user = User(dict: dict)
            }
        }
        
        DispatchQueue.main.async {
            completion(user)
        }
    }
    
    ///Lấy thông tin User từ Email
    class func fetchUserByEmail(_ email: String, completion: @escaping (User?) -> Void) {
        let db = User.db
            .whereField("email", isEqualTo: email)
            .whereField("type", isEqualTo: TypeModel.email)
        
        db.getDocuments { snapshot, error in
            var user: User?
            
            if let error = error {
                print("fetchUserByEmail error: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                if let document = snapshot.documents.first {
                    user = User(dict: document.data())
                }
            }
            
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
    
    ///Khi người dùng đã đăng nhập. Kiểm tra xem người dùng đã cập nhật thông tin hay chưa.
    class func checkUserAddedInfo(userID: String, completion: @escaping (Bool) -> Void) {
        let db = User.db.document(userID)
        db.getDocument { snapshot, error in
            var didUpdate = false
            
            if let error = error {
                print("checkUserAddedInfo error: \(error.localizedDescription)")
                
            } else {
                if let snapshot = snapshot, let dict = snapshot.data() {
                    didUpdate = dict["didUpdate"] as? Bool ?? false
                }
            }
            
            DispatchQueue.main.async {
                completion(didUpdate)
            }
        }
    }
}

//MARK: - Equatable

extension User: Equatable {}

func == (lhs: User, rhs: User) -> Bool {
    return lhs.model.uid == rhs.model.uid
}
