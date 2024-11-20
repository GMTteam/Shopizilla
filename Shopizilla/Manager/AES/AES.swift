//
//  AES.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 29/03/2022.
//

import Foundation
import CommonCrypto

public struct AES {
    
    private let key: Data
    private let iv: Data
    
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256,
              let keyData = key.data(using: .utf8) else {
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            return nil
        }
        
        self.key = keyData
        self.iv = ivData
    }
    
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    func decrypt(data: Data?) -> String? {
        guard let enData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: enData, encoding: .utf8)
    }
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        
        let keyLength = key.count
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = 0
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option,
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes.baseAddress,
                                keyLength,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress,
                                data.count,
                                cryptBytes.baseAddress,
                                cryptLength,
                                &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            print("Error: Failed to crypt data \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
    
    ///Nhận một String đã mã hoá và chuyển thành giá trị Data đã mã hoá
    static func decodeFromNetworkTransport(string: String?) -> Data? {
        if let string = string {
            return Data(base64Encoded: string)
        }
        
        return nil
    }
    
    static func getAES() -> String {
        let dict = WebService.shared.getDictFrom("AES.plist")
        let key256 = dict["key"] as? String ?? "" //32 bytes
        let iv = dict["iv"] as? String ?? "" //16 bytes
        let en = dict["en"] as? String ?? ""
        let data = AES.decodeFromNetworkTransport(string: en)
        let aes256 = AES(key: key256, iv: iv)
        return aes256?.decrypt(data: data) ?? ""
    }
    
    static func getAESFromAirTable(_ dict: NSDictionary) -> String {
        let key256 = dict["key"] as? String ?? "" //32 bytes
        let iv = dict["iv"] as? String ?? "" //16 bytes
        let en = dict["en"] as? String ?? ""
        let data = AES.decodeFromNetworkTransport(string: en)
        let aes256 = AES(key: key256, iv: iv)
        return aes256?.decrypt(data: data) ?? ""
    }
}
