//
//  MyAPIClient.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 15/06/2022.
//

import Stripe

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    private let baseLink = "https://api.stripe.com"
    private var headerValue: String {
        return "Bearer \(WebService.shared.getAPIKey().stripeSecretKey)"
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {}
    
    ///Tạo và lấy ID của khách hàng để sử dụng cho PaymentIntent
    func createCustomer(user: User, completion: @escaping (String?) -> Void) {
        let parameters: [String: Any] = [
            "email": user.email,
            "name": user.fullName,
            "phone": user.phoneNumber
        ]
        
        let link = baseLink + "/v1/customers"
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(headerValue, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var id: String?
            
            if let error = error {
                print("createCustomer error: \(error.localizedDescription)")
                
            } else {
                if let data = data,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                {
                    id = dict["id"] as? String
                }
            }
            
            DispatchQueue.main.async {
                completion(id)
            }
        }
        
        task.resume()
    }
    
    ///Tạo PaymentIntent và gửi lên máy chủ Stripe
    func createPaymentIntent(total: Double, customerId: String, des: String, email: String, completion: @escaping (String?) -> Void) {
        let amount = "amount=\(Int(total) * 100)"
        let currency = "currency=usd"
        let customer = "customer=\(customerId)"
        let description = "description=\(des)"
        let receiptEmail = "receipt_email=\(email)"
        let parameters = "\(amount)&\(currency)&\(customer)&\(description)&\(receiptEmail)"
        
        let link = baseLink + "/v1/payment_intents"
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(headerValue, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var id: String?
            
            if let error = error {
                print("createPaymentIntent error: \(error.localizedDescription)")
                
            } else {
                if let data = data,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary
                {
                    id = dict["client_secret"] as? String
                }
            }
            
            DispatchQueue.main.async {
                completion(id)
            }
        }
        
        task.resume()
    }
}
