//
//  String+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 25/11/2021.
//

import UIKit

extension String {
    
    ///Tính CGRect của một String
    func estimatedTextRect(width: CGFloat = CGFloat.greatestFiniteMagnitude, fontN: String, fontS: CGFloat) -> CGRect {
        let height = CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes: [NSAttributedString.Key: Any] = [.font : UIFont(name: fontN, size: fontS)!]
        
        return NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    ///Hiển thị khoảng cách cho số điện thoại
    func format(with model: PhoneCodeModel) -> String {
        var result = ""
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        var index = numbers.startIndex
        
        for ch in model.code.getMask() where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        
        let code = model.dialCode
        
        if numbers.count == 1 {
            if ("+" + numbers) != code {
                result = code
            }
        }
        
        //Nếu người dùng gõ 0 đầu tiên
        let r = result
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
        let c = code.replacingOccurrences(of: "+", with: "") + "0"
        
        if result == "+0" || r == c {
            result = code
        }
        
        return result
    }
    
    ///Format số điện thoại
    func getMask() -> String {
        //US
        var mask = "+X (XXX) XXX-XXXX"
        
        if self == "DE" { //Germany
            mask = "+XX XXX XXXXXXXX"
            
        } else if self == "VN" { //Vietnam
            mask = "+XX XX XXXXXXX"
        }
        
        return mask
    }
    
    ///Lấy cờ quốc gia từ String
    func flag() -> String {
        let base: UInt32 = 127397
        var usv = ""
        
        for v in unicodeScalars {
            if let uni = UnicodeScalar(base + v.value) {
                usv.unicodeScalars.append(uni)
            }
        }
        
        return usv
    }
    
    ///Thay đổi ngôn ngữ
    func localized() -> String {
        var str = NSLocalizedString(self, comment: self)
        
        if let path = Bundle.main.path(forResource: getLanguageCode(), ofType: "lproj"),
            let bundle = Bundle(path: path)
        {
            str = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        
        return str
    }
    
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        
        var amountWithPrefix = self
        let expression = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = expression.stringByReplacingMatches(
            in: amountWithPrefix,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: double)
        
        guard number != 0 as NSNumber else { return "" }
        return formatter.string(from: number)!
    }
    
    func removeSpacing() -> String {
        var amountWithPrefix = self
        let expression = try! NSRegularExpression(pattern: "[^a-z]", options: .caseInsensitive)
        amountWithPrefix = expression.stringByReplacingMatches(in: amountWithPrefix, options: [], range: NSRange(), withTemplate: "")
        guard amountWithPrefix != " " else { return "" }
        return amountWithPrefix
    }
    
    func removeFormatAmountInt() -> Int {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.decimalSeparator = ","
        return formatter.number(from: self) as! Int? ?? 0
    }
    
    func removeFormatAmountDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.decimalSeparator = ","
        return formatter.number(from: self) as! Double? ?? 0
    }
    
    func toInt() -> Int {
        return Int(self)!
    }
    
    func toDouble() -> Double {
        return Double(self)!
    }
    
    ///Chỉ chứa số
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: .literal, range: nil) == nil
    }
    
    ///String chỉ chứa chữ cái
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.union(NSCharacterSet.whitespaces).inverted
        return rangeOfCharacter(from: notLetters, options: .literal, range: nil) == nil
    }
    
    ///Letters and digits
    var isAlphanumeric: Bool {
        let notAlphanumeric = NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted
        return rangeOfCharacter(from: notAlphanumeric, options: .literal, range: nil) == nil
    }
    
    //TODO: - Password
    /*
     ● Minimum 8 characters
     ● At least 1 uppercase alphabet
     ● At least 1 lowercased alphabet
     ● At least 1 number
     ● At least 1 special character
     */
    
    var isPassword: Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&._])[A-Za-z\\d$@$!%*?&._]{8,32}"
        let isMatched = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
        return isMatched
    }
    
    ///Check email
    private func matches(_ expression: String) -> Bool {
        if let range = range(of: expression, options: .regularExpression, range: nil, locale: nil) {
            return range.lowerBound == startIndex && range.upperBound == endIndex
            
        } else {
            return false
        }
    }
    
    ///Check email
    var isValidEmail: Bool {
        matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    ///FirstName - LastName
    func fetchFirstLastName(completion: @escaping (String, String) -> Void) {
        var components = self.components(separatedBy: " ")
        if components.count > 0 {
            let fn = components.removeFirst()
            let ln = components.joined(separator: " ")
            completion(fn, ln)
        }
    }
    
    ///Uppercase Alphabet
    var isUppercase: Bool {
        let upperRegEx = ".*[A-Z]+.*"
        let upperTest = NSPredicate(format: "SELF MATCHES %@", upperRegEx)
        let upperResult = upperTest.evaluate(with: self)
        return upperResult
    }
    
    ///Lowercase Alphabet
    var isLowercase: Bool {
        let lowerRegEx = ".*[a-z]+.*"
        let lowerTest = NSPredicate(format: "SELF MATCHES %@", lowerRegEx)
        let lowerResult = lowerTest.evaluate(with: self)
        return lowerResult
    }
    
    ///Number
    var isNumber: Bool {
        let numberRegEx = ".*[0-9]+.*"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberResult = numberTest.evaluate(with: self)
        return numberResult
    }
    
    ///Special Character
    var isSpecialCharacter: Bool {
        let specialCharacterRegEx = ".*[._!&^%$#@()/]+.*"
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        let specialCharacterResult = specialCharacterTest.evaluate(with: self)
        return specialCharacterResult
    }
    
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { (_, range, _, _) in
            byWords.append(self[range])
        }
        
        return byWords
    }
    
    func getHexColor(alpha: CGFloat = 1.0) -> UIColor {
        let scanner = Scanner(string: self)
        var color: UInt64 = 0
        
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000)>>16)/255.0
            let g = CGFloat((color & 0xFF00)>>8)/255.0
            let b = CGFloat(color & 0xFF)/255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
            
        } else {
            return .white
        }
    }
    
    ///Liên kết trong văn bản
    var detectorURLs: [String] {
        var array: [String] = []
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: self) else {
                continue
            }
            let link = String(self[range])
            if !array.contains(link) {
                array.append(link)
            }
        }
        
        return array
    }
    
    static let numberF = NumberFormatter()
    
    var doubleValue: Double {
        var doubleValue: Double = 0.0
        String.numberF.decimalSeparator = "."
        
        if let result = String.numberF.number(from: self) {
            doubleValue = result.doubleValue
            
        } else {
            String.numberF.decimalSeparator = ","
            
            if let result = String.numberF.number(from: self) {
                doubleValue = result.doubleValue
            }
        }
        
        return doubleValue
    }
}
