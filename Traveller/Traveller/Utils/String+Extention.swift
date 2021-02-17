//
//  String+Extention.swift
//  bumerang
//
//  Created by RMS on 2019/10/2.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func split(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    
    func splitByLength(_ length: Int, seperator: String) -> [String] {
        var result = [String]()
        var collectedWords = [String]()
        collectedWords.reserveCapacity(length)
        var count = 0
        let words = self.components(separatedBy: " ")
        
        for word in words {
            count += word.count + 1 //add 1 to include space
            if (count > length) {
                // Reached the desired length
                
                result.append(collectedWords.map { String($0) }.joined(separator: seperator) )
                collectedWords.removeAll(keepingCapacity: true)
                
                count = word.count
                collectedWords.append(word)
            } else {
                collectedWords.append(word)
            }
        }
        
        // Append the remainder
        if !collectedWords.isEmpty {
            result.append(collectedWords.map { String($0) }.joined(separator: seperator))
        }
        
        return result
    }
    
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var lines: [String] {
        return components(separatedBy: CharacterSet.newlines)
    }
    
    public var firstLine: String? {
        return lines.first?.trimmed
    }
    
    public var lastLine: String? {
        return lines.last?.trimmed
    }
    
    public func replaceNewLineCharater(separator: String = " ") -> String {
        return components(separatedBy: CharacterSet.whitespaces).joined(separator: separator).trimmed
    }
    
    public func replacePunctuationCharacters(separator: String = "") -> String {
        return components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: separator).trimmed
    }
}


extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
    
    func encodeString() -> String? {
        
        let customAllowedSet =  NSCharacterSet(charactersIn:"!*'();:@&=+$,/?%#[] ").inverted
        return addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
    
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
        
        if decodedStr != nil {
            return decodedStr!
        }
        
        return self
    }
    
    var encodeEmoji: String {
        
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue) as String?
        
        if encodedStr != nil {
            return encodedStr!
        }
        
        return self
    }
}

extension String {
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    //Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    //Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }

    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }

    //Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    
    private static var digitsPattern = UnicodeScalar("0")..."9"
//    var digits: String {
//        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
//    }
    var integer: Int { return Int(self) ?? 0 }
}

extension String {

    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool { return isValid(regex: regex.rawValue) }
    func isValid(regex: String) -> Bool { return range(of: regex, options: .regularExpression) != nil }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

//    func makeACall() {
//        guard   isValid(regex: .phone),
//                let url = URL(string: "tel://\(self.onlyDigits())"),
//                UIApplication.shared.canOpenURL(url) else { return }
//        if #available(iOS 10, *) {
//            UIApplication.shared.open(url)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
//    }
}
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func getdateFromString(formate:String)->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.date(from:self)!
    }
    func convertStringToStandardDateFormat() -> NSDate {
        
        
        
        let strMessage = (self as NSString).doubleValue
        
        // if let timeResult = (dict["last_message_timestamp"] as? Float) {
        let date = Date(timeIntervalSince1970:strMessage)
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
//        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
//        dateFormatter.timeZone = .current
//        return dateFormatter.string(from: date)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let dateString = dateFormatter.date(from: self)! as NSDate
//        return dateString as NSDate
        
        return date as NSDate
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isValidUsername() -> Bool {
       let RegEx = "^[0-9a-zA-Z\\_.]{5,32}$"
       //  let RegEx = "^(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}"
    
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    func isValidPassword() -> Bool {
        //        let RegEx = "\\w{5,32}"
        let RegEx = "^(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
}

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

extension String {
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from { guard start < self.count else { return "" } }
        
        if let end = to { guard end >= 0 else { return "" } }
        
        if let start = from, let end = to { guard end - start >= 0 else { return "" } }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else { startIndex = self.startIndex }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else { endIndex = self.endIndex }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else { return "" }
        
        let end: Int
        if let start = from, start > 0 { end = start + length - 1 } else { end = length - 1 }
        
        return self.substring(from: from, to: end)
    }
    
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
  }
