//
//  ApiManager.swift
//  Everave Update
//
//  Created by Ubuntu on 16/01/2020
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
// ************************************************************************//
                            // Travaler project //
// ************************************************************************//

//let SERVER_URL = "http://192.168.101.99/traveler/api/"
let SERVER_URL = "http://54.228.79.46/index.php/api/"

let SUCCESSTRUE = 200
let SUCCESS = "success"

struct PARAMS {
    static let BIRTHDAY       = "birthday"
    static let DES            = "des"
    static let EMAIL          = "email"
    static let FIRST_NAME     = "first_name"
    static let FROM_DATE      = "from_date"
    static let FROM_LOCATION  = "from_location"
    static let ID             = "id"
    static let ITEMS          = "items"
    static let LAST_NAME      = "last_name"
    static let LOGIN_TYPE     = "login_type"
    static let LOGOUT         = "logout"
    static let MESSAGE        = "message"
    static let OWNER_ID       = "owner_id"
    static let PASSWORD       = "password"
    static let PHONE_NUMBER   = "phone_number"
    static let PRICE          = "price"
    static let PIN_CODE          = "pin_code"
    static let RATING         = "rating"
    static let REPLY          = "reply"
    static let REVIEWER_ID    = "reviewer_id"
    static let REVIEW_CONTENT = "review_content"
    static let REVIEW_ID      = "review_id"
    static let REVIEW_RATING  = "review_rating"
    static let REVIEW_TIME    = "review_time"
    static let TOKEN          = "token"
    static let TO_DATE        = "to_date"
    static let TO_LOCATION    = "to_location"
    static let TRAVEL_ID      = "travel_id"
    static let TRAVEL_TIME    = "travel_time"
    static let USER_EMAIL     = "user_email"
    static let USER_ID        = "user_id"
    static let USER_PHOTO     = "user_photo"
    static let WEIGHT         = "weight"
    static let REQUEST_TYPE   = "request_type"
    static let SOCIAL_ID   = "social_id"
    static let LANGUAGE = "language"
}

class ApiManager {

    class func signin(email : String, password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_EMAIL : email, PARAMS.PASSWORD: password,PARAMS.TOKEN: deviceTokenString ?? ""] as [String : Any]
        Alamofire.request(SERVER_URL + "signin", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    if let user_data = dict["user_info"].arrayObject{
                        thisuser.clearUserInfo()
                        UserDefault.setString(key: PARAMS.PASSWORD, value: password)
                        UserDefault.setBool(key: PARAMS.LOGOUT, value: false)
                        thisuser = UserModel(JSON(user_data.first!))
                        thisuser.saveUserInfo()
                        thisuser.loadUserInfo()
                        completion(true, status)
                    }
                } else{
                    completion(false, status)
                }
            }
        }
    }
    
    class func socialLogin(email : String, first_name: String,last_name: String,user_photo: String,login_type: LoginType,social_id: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_EMAIL : email, PARAMS.FIRST_NAME: first_name, PARAMS.LAST_NAME: last_name, PARAMS.USER_PHOTO: user_photo, PARAMS.LOGIN_TYPE:login_type.rawValue, PARAMS.SOCIAL_ID: social_id ,PARAMS.TOKEN: deviceTokenString ?? ""] as [String : Any]
        Alamofire.request(SERVER_URL + "socialLogin", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    if let user_data = dict["user_info"].arrayObject{
                        thisuser.clearUserInfo()
                        UserDefault.setBool(key: PARAMS.LOGOUT, value: false)
                        if let model = user_data.first{
                            thisuser = UserModel(JSON(model))
                            thisuser.saveUserInfo()
                            thisuser.loadUserInfo()
                        }
                        
                        completion(true, status)
                    }
                } else{
                    completion(false, status)
                }
            }
        }
    }

    class func signup(user_email : String,first_name: String, last_name: String,user_photo: String,birthday: Int, phone_number: String, login_type: LoginType,password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let requestURL = SERVER_URL + "signup"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append( user_email.data(using:.utf8)!, withName: PARAMS.USER_EMAIL)
                multipartFormData.append( first_name.data(using:.utf8)!, withName: PARAMS.FIRST_NAME)
                multipartFormData.append( last_name.data(using:.utf8)!, withName: PARAMS.LAST_NAME)
                if !user_photo.isEmpty{
                    multipartFormData.append(URL(fileURLWithPath: user_photo), withName: PARAMS.USER_PHOTO)
                }
                multipartFormData.append( "\(birthday)".data(using:.utf8)!, withName: PARAMS.BIRTHDAY)
                multipartFormData.append( phone_number.data(using:.utf8)!, withName: PARAMS.PHONE_NUMBER)
                multipartFormData.append( "\(login_type.rawValue)".data(using:.utf8)!, withName: PARAMS.LOGIN_TYPE)
                
                if let devicetoken = deviceTokenString{
                    multipartFormData.append( devicetoken.data(using:.utf8)!, withName: PARAMS.TOKEN)
                }else{
                    multipartFormData.append( "deviceTokenNull".data(using:.utf8)!, withName: PARAMS.TOKEN)
                }
                multipartFormData.append( password.data(using:.utf8)!, withName: PARAMS.PASSWORD)
            },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                            case .failure: completion(false, nil)
                            case .success(let data):
                            let dict = JSON(data)
                            let status = dict[PARAMS.MESSAGE].stringValue
                            if status == SUCCESS {
                                if let user_data = dict["user_info"].arrayObject{
                                    thisuser.clearUserInfo()
                                    UserDefault.setString(key: PARAMS.PASSWORD, value: password)
                                    UserDefault.setBool(key: PARAMS.LOGOUT, value: false)
                                    thisuser = UserModel(JSON(user_data.first!))
                                    thisuser.saveUserInfo()
                                    thisuser.loadUserInfo()
                                    completion(true, status)
                                }
                            }else{
                                completion(false, status)
                            }
                        }
                    }
                    case .failure( _):
                    completion(false, nil)
                }
            }
        )
    }
    
    

    class func updateProfile(first_name: String, last_name: String,user_photo: String,birthday: Int, phone_number: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let requestURL = SERVER_URL + "updateProfile"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append( "\(thisuser.user_id ?? 0)".data(using:.utf8)!, withName: PARAMS.USER_ID)
                multipartFormData.append( first_name.data(using:.utf8)!, withName: PARAMS.FIRST_NAME)
                multipartFormData.append( last_name.data(using:.utf8)!, withName: PARAMS.LAST_NAME)
                if !user_photo.isEmpty{
                    multipartFormData.append(URL(fileURLWithPath: user_photo), withName: PARAMS.USER_PHOTO)
                }
                multipartFormData.append( "\(birthday)".data(using:.utf8)!, withName: PARAMS.BIRTHDAY)
                multipartFormData.append( phone_number.data(using:.utf8)!, withName: PARAMS.PHONE_NUMBER)
                
            },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                            case .failure: completion(false, nil)
                            case .success(let data):
                            let dict = JSON(data)
                            let status = dict[PARAMS.MESSAGE].stringValue
                            if status == SUCCESS {
                                if let user_data = dict["user_info"].arrayObject{
                                    thisuser.clearUserInfo()
                                    UserDefault.setBool(key: PARAMS.LOGOUT, value: false)
                                    thisuser = UserModel(JSON(user_data.first!))
                                    thisuser.saveUserInfo()
                                    thisuser.loadUserInfo()
                                    completion(true, status)
                                }
                            }else{
                                completion(false, status)
                            }
                        }
                    }
                    case .failure( _):
                    completion(false, nil)
                }
            }
        )
    }
    
    class func changePassword(password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["user_id" : thisuser.user_id ?? -1, PARAMS.PASSWORD: password] as [String : Any]
        Alamofire.request(SERVER_URL + "changePassword", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    completion(true, status)
                } else{
                    completion(false, status)
                }
            }
        }
    }
    
    class func getTravel(from_location: String?,to_location: String?,from_date: Int?,to_date: Int?, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        var params = [String: Any]()
        if let user_id = thisuser.user_id{
            params[PARAMS.USER_ID] = user_id
        }
        if let from_location = from_location{
            params[PARAMS.FROM_LOCATION] = from_location
        }
        if let to_location = to_location{
            params[PARAMS.TO_LOCATION] = to_location
        }
        if let from_date = from_date{
            params[PARAMS.FROM_DATE] = from_date
        }
        if let to_date = to_date{
            params[PARAMS.TO_DATE] = to_date
        }
        
        Alamofire.request(SERVER_URL + "getTravel", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    completion(true, dict)
                } else{
                    completion(false, status)
                }
            }
        }
    }
    
    class func getMyTrips(completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["user_id" : thisuser.user_id ?? -1] as [String : Any]
        Alamofire.request(SERVER_URL + "getMyTrips", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    completion(true, dict)
                } else{
                    completion(false, status)
                }
            }
        }
    }
    
    class func createTravel(travel_time: Int, weight: Float, price: Int, items: String, des: String, from_location: String,to_location: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_ID: thisuser.user_id ?? -1, PARAMS.TRAVEL_TIME: travel_time, PARAMS.WEIGHT: weight, PARAMS.PRICE: price, PARAMS.ITEMS: items, PARAMS.DES
                        : des ,PARAMS.FROM_LOCATION : from_location, PARAMS.TO_LOCATION: to_location ] as [String : Any]
        Alamofire.request(SERVER_URL + "createTravel", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    completion(true, dict)
                } else{
                    completion(false, status)
                }
            }
        }
    }
    
    /*
     $request_type = $this->input->post('request_type');// 0: give review, 1: reply review, 2: get review
             $reviewer_id = $this->input->post('reviewer_id');
             $owner_id = $this->input->post('owner_id');
             $review_content = $this->input->post('review_content');
             $review_time = $this->input->post('review_time');
             $review_rating = $this->input->post('review_rating');
             $review_id = $this->input->post('review_id');
             $reply = $this->input->post('reply');
     */
    class func manageReview(request_type: RequestType,owner_id: Int, reviewer_id: Int?, review_content: String?, review_time: Int?, review_rating: Float?, review_id: Int?, reply: String?, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        var params = [String: Any]()
        
        if request_type == .give_reiview{
            if let review_content = review_content, let review_time = review_time, let review_rating = review_rating, let reviewer_id = reviewer_id{
                if let reviewid = review_id{
                    params = [PARAMS.OWNER_ID: owner_id, PARAMS.REVIEW_ID: reviewid, PARAMS.REVIEW_CONTENT:review_content, PARAMS.REVIEW_TIME: review_time, PARAMS.REVIEW_RATING: review_rating, PARAMS.REVIEWER_ID: reviewer_id, PARAMS.REQUEST_TYPE: request_type.rawValue]
                }else{
                    params = [PARAMS.OWNER_ID: owner_id, PARAMS.REVIEW_CONTENT:review_content, PARAMS.REVIEW_TIME: review_time, PARAMS.REVIEW_RATING: review_rating, PARAMS.REVIEWER_ID: reviewer_id, PARAMS.REQUEST_TYPE: request_type.rawValue]
                }
            }
            
            
        }else if request_type == .reply_review{// reply review
            if let reviewid = review_id, let reply = reply{
                params = [PARAMS.REVIEW_ID: reviewid,PARAMS.REPLY: reply, PARAMS.OWNER_ID: owner_id, PARAMS.REQUEST_TYPE: request_type.rawValue]
            }
        }else{// get review
            params = [PARAMS.OWNER_ID: owner_id, PARAMS.REQUEST_TYPE: request_type.rawValue]
        }
        Alamofire.request(SERVER_URL + "manageReview", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.MESSAGE].stringValue
                if status == SUCCESS {
                    completion(true, dict)
                } else{
                    completion(false, status)
                }
            }
        }
    }
    
    class func forgot(email: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.EMAIL: email] as [String : Any]
        Alamofire.request(SERVER_URL + "forgot", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                //print("sellers =====> ",dict)
                let status = dict[PARAMS.MESSAGE].stringValue// 0,1,2
                let pin_code = dict[PARAMS.PIN_CODE].stringValue// 0,1,2
                if status == SUCCESS {
                    completion(true,pin_code)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func resetPassword(email: String,password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.EMAIL: email, PARAMS.PASSWORD: password] as [String : Any]
        Alamofire.request(SERVER_URL + "resetPassword", method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                //print("sellers =====> ",dict)
                let status = dict[PARAMS.MESSAGE].stringValue// 0,1,2
                if status == SUCCESS {
                    completion(true,status)
                } else {
                    completion(false, status)
                }
            }
        }
    }
}

enum LoginType: Int {
    case facebook = 0
    case google = 1
    case apple = 2
    case phone = 3
    case email = 4
}

enum RequestType: Int {
    case give_reiview = 0
    case reply_review = 1
    case get_review = 2
}

