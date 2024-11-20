//
//  PayPalAPIClient.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 22/06/2022.
//

import UIKit

class PayPalAPIClient: NSObject {
    
    //MARK: - Properties
    static let shared = PayPalAPIClient()
    
    private let baseLink = "https://api-m.sandbox.paypal.com"
    
    //MARK: - Authentication
    func authentication(completion: @escaping (String?) -> Void) {
        let shared = WebService.shared.getAPIKey()
        guard let authData = "\(shared.payPalClientID):\(shared.payPalSecretKey)".data(using: .utf8) else {
            completion(nil)
            return
        }
        
        let basic = authData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let authStr = "Basic \(basic)"
        
        let parameters = "grant_type=client_credentials"
        
        let link = baseLink + "/v1/oauth2/token"
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(authStr, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var headerValue: String?
            
            if let error = error {
                print("authentication error: \(error.localizedDescription)")
                
            } else {
                if let data = data,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                {
                    let tokenType = dict["token_type"] as? String ?? ""
                    let accessToken = dict["access_token"] as? String ?? ""
                    headerValue = "\(tokenType) \(accessToken)"
                }
            }
            
            DispatchQueue.main.async {
                completion(headerValue)
            }
        }
        
        task.resume()
    }
    
    //MARK: - CreateOrder
    func createOrder(headerValue: String, total: String, completion: @escaping (String?, String?) -> Void) {
        //Tạo liên kết Success
        let successLink = DynamicLinkModel.shared().link + "paypal?state=success"
        DynamicLinkModel.shared().shortLinks(successLink, title: "", imgURL: nil) { successShortURL in
            guard let successShortURL = successShortURL else {
                completion(nil, nil)
                return
            }
            let successShortLink = successShortURL.absoluteString
            
            //Tạo liên kết Failed
            let failedLink = DynamicLinkModel.shared().link + "paypal?state=failed"
            DynamicLinkModel.shared().shortLinks(failedLink, title: "", imgURL: nil) { failedShortURL in
                guard let failedShortURL = failedShortURL else {
                    completion(nil, nil)
                    return
                }
                let failedShortLink = failedShortURL.absoluteString
                
                //Tạo Order cho PayPal
                let parameters: [String: Any] = [
                    "intent": "CAPTURE",
                    "purchase_units": [
                        [
                            "amount": [
                                "currency_code": "USD",
                                "value": total
                            ]
                        ]
                    ],
                    "application_context": [
                        "return_url": successShortLink,
                        "cancel_url": failedShortLink
                    ]
                ]
                
                let link = self.baseLink + "/v2/checkout/orders"
                guard let url = URL(string: link) else {
                    completion(nil, nil)
                    return
                }
                
                var request = URLRequest(url: url)
                request.setValue(headerValue, forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    var orderID: String?
                    var approveLink: String?
                    
                    if let error = error {
                        print("createOrder error: \(error.localizedDescription)")
                        
                    } else {
                        if let data = data,
                           let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
                           dict["status"] as? String == "CREATED"
                        {
                            orderID = dict["id"] as? String
                            
                            if let links = dict["links"] as? [NSDictionary],
                                let approveDict = links.first(where: { $0["rel"] as? String == "approve" })
                            {
                                approveLink = approveDict["href"] as? String
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(orderID, approveLink)
                    }
                }
                
                task.resume()
            }
        }
    }
    
    //MARK: - Capture Payment For Order
    func capturePaymentForOrder(headerValue: String, orderID: String, completion: @escaping (Bool) -> Void) {
        let link = baseLink + "/v2/checkout/orders/\(orderID)/capture"
        guard let url = URL(string: link) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(headerValue, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("7b92603e-77ed-4896-8e78-5dea2050476a", forHTTPHeaderField: "PayPal-Request-Id")
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var success: Bool = false
            
            if let error = error {
                print("capturePaymentForOrder error: \(error.localizedDescription)")
                
            } else {
                if let data = data,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                {
                    success = dict["status"] as? String == "COMPLETED"
                }
            }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
        
        task.resume()
    }
}
