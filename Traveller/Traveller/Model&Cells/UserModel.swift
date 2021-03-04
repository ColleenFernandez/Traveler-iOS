
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
    var socail_id: String?
    var login_type: LoginType?

    override init() {
       super.init()
        user_id = -1
        first_name = nil
        last_name = nil
        user_photo = nil
        user_email = nil
        password = nil
        rating = nil
        birthday = nil
        phone_number = nil
        username = nil
        login_type = nil
        socail_id = nil
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
    
    init(_ json: JSON){
        self.user_id = json[PARAMS.ID].intValue
        self.first_name = json[PARAMS.FIRST_NAME].stringValue
        self.last_name = json[PARAMS.LAST_NAME].stringValue
        self.user_photo = json[PARAMS.USER_PHOTO].stringValue
        self.user_email = json[PARAMS.USER_EMAIL].stringValue
        self.password = UserDefault.getString(key: PARAMS.PASSWORD, defaultValue: "")
        self.rating = json[PARAMS.RATING].floatValue
        self.birthday = json[PARAMS.BIRTHDAY].intValue
        self.phone_number = json[PARAMS.PHONE_NUMBER].stringValue
        let login_type = json[PARAMS.LOGIN_TYPE].intValue
        if login_type == 0{
            self.login_type = .facebook
        }else if login_type == 1{
            self.login_type = .google
        }else if login_type == 2{
            self.login_type = .apple
        }else if login_type == 3{
            self.login_type = .phone
        }else{
            self.login_type = .email
        }
        self.socail_id = json[PARAMS.SOCIAL_ID].stringValue
    }
    
    
   var isValid: Bool {
       return user_id != nil && user_id != -1
   }

    // Recover user credential from UserDefault
    func loadUserInfo() {
        user_id = UserDefault.getInt(key: PARAMS.USER_ID, defaultValue: 0)
        first_name = UserDefault.getString(key: PARAMS.FIRST_NAME, defaultValue: "")
        last_name = UserDefault.getString(key: PARAMS.LAST_NAME, defaultValue: "")
        user_photo = UserDefault.getString(key: PARAMS.USER_PHOTO, defaultValue: "")
       
        user_email = UserDefault.getString(key: PARAMS.USER_EMAIL, defaultValue: "")
        password = UserDefault.getString(key: PARAMS.PASSWORD, defaultValue: "")
        rating = UserDefault.getFloat(key: PARAMS.RATING, defaultValue: 0.0)
        birthday = UserDefault.getInt(key: PARAMS.BIRTHDAY, defaultValue: Int(NSDate().timeIntervalSince1970) * 1000)
        phone_number = UserDefault.getString(key: PARAMS.PHONE_NUMBER, defaultValue: "")
        let login_type = UserDefault.getInt(key: PARAMS.LOGIN_TYPE, defaultValue: -1)
        if login_type == 0{
            self.login_type = .facebook
        }else if login_type == 1{
            self.login_type = .google
        }else if login_type == 2{
            self.login_type = .apple
        }else if login_type == 3{
            self.login_type = .phone
        }else{
            self.login_type = .email
        }
        socail_id = UserDefault.getString(key: PARAMS.SOCIAL_ID, defaultValue: "")
        
    }
    // Save user credential to UserDefault
    func saveUserInfo() {
        UserDefault.setInt(key: PARAMS.USER_ID, value: user_id)
        UserDefault.setString(key: PARAMS.FIRST_NAME, value: first_name)
        UserDefault.setString(key: PARAMS.LAST_NAME, value: last_name)
        UserDefault.setString(key: PARAMS.USER_EMAIL, value: user_email)
        UserDefault.setString(key: PARAMS.USER_PHOTO, value: user_photo)
        UserDefault.setString(key: PARAMS.PASSWORD, value: password)
        UserDefault.setFloat(key: PARAMS.RATING, value: rating ?? 0.0)
        UserDefault.setInt(key: PARAMS.BIRTHDAY, value: birthday ?? Int(NSDate().timeIntervalSince1970) * 1000)
        UserDefault.setString(key: PARAMS.PHONE_NUMBER, value: phone_number)
        UserDefault.setInt(key: PARAMS.LOGIN_TYPE, value: login_type?.rawValue ?? -1)
        UserDefault.setString(key: PARAMS.SOCIAL_ID, value: socail_id)
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
        login_type = nil
        socail_id = nil

        UserDefault.setInt(key: PARAMS.USER_ID, value: -1)
        UserDefault.setString(key: PARAMS.FIRST_NAME, value: nil)
        UserDefault.setString(key: PARAMS.LAST_NAME, value: nil)
        UserDefault.setString(key: PARAMS.USER_EMAIL, value: nil)
        UserDefault.setString(key: PARAMS.USER_PHOTO, value: nil)
        UserDefault.setFloat(key: PARAMS.RATING, value: 0.0)
        UserDefault.setInt(key: PARAMS.BIRTHDAY, value: 0)
        UserDefault.setString(key: PARAMS.PHONE_NUMBER, value: nil)
        UserDefault.setInt(key: PARAMS.LOGIN_TYPE, value: -1)
        UserDefault.setString(key: PARAMS.SOCIAL_ID, value: nil)
    }
}



