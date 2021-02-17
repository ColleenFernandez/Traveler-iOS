//
//  CommonUtils.swift
//  Fiit
//
//  Created by JIS on 2016/12/10.
//  Copyright © 2016 JIS. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation
import UIKit

func previewImageFromVideo(url: NSURL) -> UIImage? {
    let asset = AVAsset(url:url as URL)
    let imageGenerator = AVAssetImageGenerator(asset:asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    var time = asset.duration
    time.value = min(time.value, 1)
    
    do {
        let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: imageRef)
    } catch {
        return nil
    }
}


func isValidEmail(testStr:String) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
    
}

func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

func saveWatermark(image: UIImage) -> String! {
    
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0]
    
    // current document directory
    fileManager.changeCurrentDirectoryPath(documentDirectory as String)
    
    do {
        try fileManager.createDirectory(atPath: "psj", withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let savedFilePath = "\(documentDirectory)/\("psj")/watermark.png"
    
    // if the file exists already, delete and write, else if create filePath
    if (fileManager.fileExists(atPath: savedFilePath)) {
        do {
            try fileManager.removeItem(atPath: savedFilePath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    } else {
        fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
    }
    
    if let data = resize(image: image, maxHeight: 512, maxWidth: 512, compressionQuality: 1, mode: "PNG") {
        
        do {
            try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
        } catch {
            print(error)
        }
        
    }
    
    return savedFilePath
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    
    let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

let systemSoundID = 1007

func playSound() {
    
    AudioServicesPlayAlertSound(UInt32(systemSoundID))
}

func heightForView(text:String, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

func getStrDate(_ tstamp: String,format: String = "MMM-dd-yyyy HH:mm") -> String {
    let date: Date? = Date(timeIntervalSince1970: TimeInterval(tstamp)!/1000)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    let strDate = dateFormatter.string(from: date ?? Date())
    
    return strDate
}

func getStrShortDate(_ tstamp: String) -> String {
    let date: Date? = Date(timeIntervalSince1970: TimeInterval(tstamp)!/1000)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM-dd-yyyy"
    let strDate = dateFormatter.string(from: date ?? Date())
    
    return strDate
}
func getStrDateshort(_ tstamp: String) -> String {
    if let timeinterval = TimeInterval(tstamp){
        let date = Date(timeIntervalSince1970: timeinterval/1000)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm a" //Specify your format that you want MM-dd HH:mm format okay, format setting is very important if you have change any things eventhough it is very small. it will be change the format
        
        let strDate = dateFormatter.string(from: date)
        return strDate
    }else{
        return ""
    }
}

func validatePhoneNumber(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result = phoneTest.evaluate(with: value)
    return result
}


func saveBinaryWithName(image: UIImage, name: String) -> String! {
    
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0]
    
    // current document directory
    fileManager.changeCurrentDirectoryPath(documentDirectory as String)
    
    do {
        try fileManager.createDirectory(atPath: Constants.SAVE_ROOT_PATH, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let savedFilePath = "\(documentDirectory)/\(Constants.SAVE_ROOT_PATH)/\(name)"
    
    // if the file exists already, delete and write, else if create filePath
    if (fileManager.fileExists(atPath: savedFilePath)) {
        do {
            try fileManager.removeItem(atPath: savedFilePath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    } else {
        fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
    }
    
    if let data = resize(image: image, maxHeight: 4000, maxWidth: 3000, compressionQuality: 1, mode: "PNG") {
        
        do {
            try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
        } catch {
            print(error)
        }
    }
    
    return savedFilePath
}

func getAgeFromString(_ dateStr: String) -> String {
    let now = Date()
    var returnedString = ""
    var age = 0
    let birthday: Date? = getDateFromDateStringwithFormat(dateStr, format: "yyyy-MM-dd")
    let calendar = Calendar.current
    if let birthday = birthday{
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        age = ageComponents.year!
    }
    if age == 0{
        returnedString = ""
    }else{
        returnedString = "\(age)"
    }
    return returnedString
}

func resizeImage4Normalization(image: UIImage, maxHeight: Float = 4000.0, maxWidth: Float = 4000.0, compressionQuality: Float = 0.5, mode: String = "JPG") -> UIImage? {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    
    let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in:rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    return img
}

