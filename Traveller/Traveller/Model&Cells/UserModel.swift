//
//  UserModel.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 1/18/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel: NSObject {

    var user_id : Int!
    var first_name : String?
    var last_name : String?
    var user_photo : String?
    var user_email: String?
    var password : String?
    var rating: Float?
    var birthday: Int?
    var phone_number: String?
    var username: String?
    

    override init() {
       super.init()
        user_id = -1
        first_name = ""
        last_name = ""
        user_photo = ""
        user_email = ""
        password = ""
        rating = 0
        birthday = 0
        phone_number = ""
        username = ""
    }

    init(user_id: Int, first_name: String, last_name: String, user_photo: String, user_email: String, password: String, rating: Float, birthday: Int, phone_number: String){
        self.user_id = user_id
        self.first_name = first_name
        self.last_name = last_name
        self.user_photo = user_photo
        self.user_email = user_email
        self.password = password
        self.rating = rating
        self.birthday = birthday
        self.phone_number = phone_number
    }
    
    init(user_id: Int, user_name: String, user_photo: String){
        self.user_id = user_id
        self.username = user_name
        self.user_photo = user_photo
    }
    
    // for comment
    /**init(comment: Dictionary<String, Any>){
        self.user_id = comment[PARAMS.USER_ID] as? Int
        self.user_name = comment[PARAMS.USER_NAME] as? String
        self.user_photo = comment[PARAMS.USER_PHOTO] as? String
        self.user_location = comment[PARAMS.USER_LOCATION] as? String
        self.user_email = comment[PARAMS.EMAIL] as? String
        self.lat = comment[PARAMS.LAT] as? String
        self.long = comment[PARAMS.LONG] as? String
        self.stripe_account_id = comment[PARAMS.STRIPE_ACCOUNT_ID] as? String
    }
    
    init(user_id: Int, user_name: String, user_photo: String, user_location: String, user_email: String,is_friend: Bool, stripe_account_id: String, is_sharelocation: Bool){
        self.user_id = user_id
        self.user_name = user_name
        self.user_photo = user_photo
        self.user_location = user_location
        self.user_email = user_email
        self.is_friend = is_friend
        self.stripe_account_id = stripe_account_id
        self.is_sharelocation = is_sharelocation
    }

    init(_ json : JSON) {
        self.user_id = json[PARAMS.ID].intValue
        self.user_name = json[PARAMS.USER_NAME].stringValue
        self.user_email = json[PARAMS.EMAIL].stringValue
        self.user_photo = json[PARAMS.USER_PHOTO].stringValue
        self.user_location = json[PARAMS.USER_LOCATION].stringValue
        self.lat = json["lat"].stringValue
        self.long = json["long"].stringValue
        self.password = UserDefault.getString(key: PARAMS.PASSWORD,defaultValue: "")
        self.stripe_account_id = json[PARAMS.STRIPE_ACCOUNT_ID].stringValue
        self.is_sharelocation = json[PARAMS.IS_SHARELOCATION].intValue == 1 ? true: false
    }
    
    init(json1 : JSON) {// for other user
        self.user_id = json1[PARAMS.ID].intValue
        self.user_name = json1[PARAMS.USER_NAME].stringValue
        self.user_email = json1[PARAMS.EMAIL].stringValue
        self.user_photo = json1[PARAMS.USER_PHOTO].stringValue
        self.user_location = json1[PARAMS.USER_LOCATION].stringValue
        self.lat = json1["lat"].stringValue
        self.long = json1["long"].stringValue
        self.is_friend = json1[PARAMS.IS_FRIEND].intValue == 1 ? true: false// must be changed
        self.stripe_account_id = json1[PARAMS.STRIPE_ACCOUNT_ID].stringValue
        self.is_sharelocation = json1[PARAMS.IS_SHARELOCATION].intValue == 1 ? true: false
    }*/
    // Check and returns if user is valid user or not
   var isValid: Bool {
       return user_id != nil && user_id != -1
   }

    // Recover user credential from UserDefault
    func loadUserInfo() {
        user_id = UserDefault.getInt(key: PARAMS.USER_ID, defaultValue: 0)
        first_name = UserDefault.getString(key: PARAMS.FIRST_NAME, defaultValue: "")
        last_name = UserDefault.getString(key: PARAMS.LAST_NAME, defaultValue: "")
        user_photo = UserDefault.getString(key: PARAMS.USER_PHOTO, defaultValue: "")
       
        user_email = UserDefault.getString(key: PARAMS.EMAIL, defaultValue: "")
        password = UserDefault.getString(key: PARAMS.PASSWORD, defaultValue: "")
        rating = UserDefault.getFloat(key: PARAMS.RATING, defaultValue: 0.0)
        birthday = UserDefault.getInt(key: PARAMS.BIRTHDAY, defaultValue: Int(NSDate().timeIntervalSince1970) * 1000)
        phone_number = UserDefault.getString(key: PARAMS.PHONE_NUMBER, defaultValue: "")
    }
    // Save user credential to UserDefault
    func saveUserInfo() {
        UserDefault.setInt(key: PARAMS.USER_ID, value: user_id)
        UserDefault.setString(key: PARAMS.FIRST_NAME, value: first_name)
        UserDefault.setString(key: PARAMS.LAST_NAME, value: last_name)
        UserDefault.setString(key: PARAMS.EMAIL, value: user_email)
        UserDefault.setString(key: PARAMS.USER_PHOTO, value: user_photo)
        UserDefault.setString(key: PARAMS.PASSWORD, value: password)
        UserDefault.setFloat(key: PARAMS.RATING, value: rating ?? 0.0)
        UserDefault.setInt(key: PARAMS.BIRTHDAY, value: birthday ?? Int(NSDate().timeIntervalSince1970) * 1000)
        UserDefault.setString(key: PARAMS.PHONE_NUMBER, value: phone_number)
    }
    // Clear save user credential
    func clearUserInfo() {

        user_id = -1
        first_name = nil
        last_name = nil
        user_photo = nil
        user_email = nil
        password = nil
        rating = nil
        birthday = nil
        phone_number = nil

        UserDefault.setInt(key: PARAMS.USER_ID, value: -1)
        UserDefault.setString(key: PARAMS.FIRST_NAME, value: nil)
        UserDefault.setString(key: PARAMS.LAST_NAME, value: nil)
        UserDefault.setString(key: PARAMS.EMAIL, value: nil)
        UserDefault.setString(key: PARAMS.USER_PHOTO, value: nil)
        UserDefault.setString(key: PARAMS.PASSWORD, value: nil)
        UserDefault.setFloat(key: PARAMS.RATING, value: 0.0)
        UserDefault.setInt(key: PARAMS.BIRTHDAY, value: 0)
        UserDefault.setString(key: PARAMS.PHONE_NUMBER, value: nil)
    }
}

