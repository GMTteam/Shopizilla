//
//  WebService.swift
//  Shopizilla
//
//  Created by Anh Tu on 04/04/2022.
//

import UIKit

class WebService: NSObject {
    
    //MARK: - Properties
    static let shared = WebService()
    let purchaseName = "PurchaseName"
    let purchaseKey = "PurchaseKey"
    
    //MARK: - Initializes
    override init() {
        super.init()
    }
}

//MARK: - Setups

extension WebService {
    
    func getDictFrom(_ fileName: String) -> NSDictionary {
        var dict: NSDictionary = [:]
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: nil),
            let dictionary = try? NSDictionary(contentsOf: url, error: ()) {
            dict = dictionary
        }
        
        return dict
    }
    
    ///Lấy API Key từ tệp .plist
    func getAPIKey(_ fileName: String = "APIKey.plist") -> APIKey {
        return APIKey(dict: getDictFrom(fileName))
    }
    
    ///Đi tới một trang Web
    func goToLink(_ link: String) {
        if let url = URL(string: link) {
            goToURL(url)
        }
    }
    
    func goToURL(_ url: URL, otherURL: URL? = nil) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            if let otherURL = otherURL {
                UIApplication.shared.open(otherURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func goToInstagram() {
        let username = getAPIKey().instagram
        guard let url = URL(string: "instagram://user?username=\(username)") else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        } else {
            let url = URL(string: "http://instagram.com/\(username)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - Purchase Information

extension WebService {
    
    func fetchAESFrom(completion: @escaping (NSDictionary) -> Void) {
        let str = (getDictFrom("AES.plist")["airLink"] as? String ?? "")
        
        guard let url = URL(string: str) else {
            completion([:])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(getDictFrom("AES.plist")["airKey"] as? String ?? "")", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var newDict: NSDictionary = [:]

            if let error = error {
                print("fetchPurchaseInfo error: \(error.localizedDescription)")

            } else {
                if let data = data,
                   let value = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary,
                   let records = value["records"] as? [NSDictionary],
                    let dict = records.first,
                   let fields = dict["fields"] as? NSDictionary
                {
                    newDict = [
                        "key": fields["key"] as? String ?? "",
                        "en": fields["en"] as? String ?? "",
                        "iv": fields["iv"] as? String ?? ""
                    ]
                }
            }

            DispatchQueue.main.async {
                completion(newDict)
            }
        }
        
        task.resume()
    }
    
    ///Get purchase information
    func fetchPurchaseInfo(purchaseCode: String, token: String, completion: @escaping (Purchase?, NSError?) -> Void) {
        let str = (getDictFrom("AES.plist")["link"] as? String ?? "") + purchaseCode
        
        guard let url = URL(string: str) else {
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(purchaseCode, forHTTPHeaderField: "User-Agent")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var purchase: Purchase?
            var purchaseError: NSError?

            if let error = error as? NSError {
                purchaseError = error

            } else {
                if let data = data,
                   let value = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                    purchase = Purchase(dict: value)
                }
            }

            DispatchQueue.main.async {
                completion(purchase, purchaseError)
            }
        }
        
        task.resume()
    }
}

//MARK: - JSON

extension WebService {
    
    func saveJSONFile(_ fileName: String, dataAny: Any) {
        let defaults = FileManager.default
        
        if let url = defaults.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let getURL = url.appendingPathComponent("Shopizilla")
            
            do {
                try defaults.createDirectory(at: getURL, withIntermediateDirectories: true, attributes: nil)
                
                let toURL = getURL.appendingPathComponent("\(fileName).json")
                let saved = try JSONSerialization.data(withJSONObject: dataAny, options: .prettyPrinted)
                try saved.write(to: toURL)
                print("*** saveJSONFile: \(toURL)")
                
            } catch {}
        }
    }
    
    func getJSONFile(_ fileName: String) -> Any? {
        var downloadData: Any?
        let defaults = FileManager.default
        
        if let url = defaults.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let jsonFile = "\(fileName).json"
            let getURL = url.appendingPathComponent("Shopizilla/\(jsonFile)")
            
            if defaults.fileExists(atPath: getURL.path) {
                do {
                    let data = try Data(contentsOf: getURL)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    downloadData = json
                    
                } catch {}
            }
        }
        
        return downloadData
    }
}
