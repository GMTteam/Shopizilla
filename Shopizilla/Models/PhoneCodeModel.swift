//
//  PhoneCodeModel.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 10/12/2021.
//

import UIKit

class PhoneCodeModel {
    
    var code: String
    var dialCode: String
    var name: String
    
    init(code: String, dialCode: String, name: String) {
        self.code = code
        self.dialCode = dialCode
        self.name = name
    }
    
    static func shared(completion: @escaping ([PhoneCodeModel]) -> Void) {
        var phoneCodes: [PhoneCodeModel] = []
        
        DispatchQueue.global().async {
            if let url = Bundle.main.url(forResource: "PhoneCode.json", withExtension: nil) {
                do {
                    let data = try Data(contentsOf: url)
                    if let array = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                        phoneCodes = array
                            .map({ PhoneCodeModel(dict: $0 as! NSDictionary) })
                            .sorted(by: { $0.name < $1.name })
                    }
                    
                } catch let error as NSError {
                    print("Load phone code error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(phoneCodes)
            }
        }
    }
}

extension PhoneCodeModel {
    
    convenience init(dict: NSDictionary) {
        let code = dict["code"] as? String ?? ""
        let dialCode = dict["dial_code"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        
        self.init(code: code, dialCode: dialCode, name: name)
    }
}
