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

let SERVER_URL = "http://192.168.101.99/dogrun/api/"
//let SERVER_URL = "http://mofutomo.com/api/"
let SUCCESSTRUE = 200

struct PARAMS {
    static let USER_ID             = "user_id"
    static let FIRST_NAME             = "first_name"
    static let LAST_NAME             = "last_name"
    static let EMAIL               = "email"
    static let PASSWORD            = "password"
    static let USER_PHOTO          = "user_photo"
    static let RATING          = "rating"
    static let PHONE_NUMBER          = "phone_number"
    static let BIRTHDAY          = "birthday"
    static let LOGOUT              = "logout"
    static let TOKEN               = "token"
    
//    static let COMMENT_TEXT        = "comment_text"
//    static let COMMENT_TIME        = "comment_time"
//
//    static let ID                  = "id"
//    static let ISSHOWING_MAP       = "isshowing_map"
//    static let IS_FRIEND           = "is_friend"
//    static let IS_LIKE             = "is_like"
//    static let IS_SHARELOCATION    = "is_sharelocation"
//    static let LAT                 = "lat"
//    static let LIKE_NUM            = "like_num"
//    static let LOCATION_COUNT      = "location_count"
//
//    static let LONG                = "long"
//    static let MEDIA_RATIO         = "media_ratio"
//    static let MEDIA_TYPE          = "media_type"
//    static let MEDIA_URL           = "media_url"
//    static let MESSAGE             = "message"
//    static let OWNER_ID            = "owner_id"
//
//    static let PETS_INFO           = "pets_info"
//    static let PET_BIRTH           = "pet_birth"
//    static let PET_GENDER          = "pet_gender"
//    static let PET_ID              = "pet_id"
//    static let PET_KIND            = "pet_kind"
//    static let PET_NAME            = "pet_name"
//    static let PET_PHOTO           = "pet_photo"
//    static let PET_TYPE            = "pet_type"
//    static let PIN_CODE            = "pin_code"
//    static let POST_DES            = "post_des"
//    static let POST_DETAIL         = "post_detail"
//    static let POST_ID             = "post_id"
//    static let POST_THUMB          = "post_thumb"
//    static let POST_TIME           = "post_time"
//    static let RADIUS              = "radius"
//    static let REQUEST_TYPE        = "request_type"
//    static let RESULTCODE          = "result_code"
//    static let SELF_INTRO          = "self_intro"
//    static let SERVICE_DESCRIPTION = "service_description"
//    static let SERVICE_ID          = "service_id"
//    static let SERVICE_PRICE       = "service_price"
//    static let SERVICE_STATUS      = "service_status"
//    static let SERVICE_TIME        = "service_time"
//    static let SERVICE_TYPE        = "service_type"
//    static let STRIPE_ACCOUNT_ID   = "stripe_account_id"
//
//
//    static let USER_INFO           = "user_info"
//    static let USER_LOCATION       = "user_location"
//    static let USER_NAME           = "user_name"
//
}
//
//class ApiManager {
//
//    class func signin(email : String,password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
//        let params = [PARAMS.EMAIL : email, PARAMS.PASSWORD: password,PARAMS.TOKEN: deviceTokenString ?? ""] as [String : Any]
//        Alamofire.request(SERVER_URL + "signin", method:.post, parameters:params)
//        .responseJSON { response in
//            switch response.result {
//                case .failure:
//                completion(false, nil)
//                case .success(let data):
//                let dict = JSON(data)
//                let status = dict[PARAMS.RESULTCODE].intValue// 0,1,2
//                if status == SUCCESSTRUE {
//                    if let user_data = dict[PARAMS.USER_INFO].arrayObject{
//                        thisuser.clearUserInfo()
//                        thisuser = UserModel(JSON(user_data.first!))
//                        thisuser.saveUserInfo()
//                        thisuser.loadUserInfo()
//                    }
//                    if let pets_data = dict[PARAMS.PETS_INFO].arrayObject{
//                        my_pets.removeAll()
//                        if pets_data.count > 0{
//                            for one in pets_data{
//                                my_pets.append(PetModel(JSON(one)))
//                            }
//                        }
//                    }
//                    ApiManager.getAllDogs { (isSuccess, data) in
//                        if isSuccess{
//                            ds_alldog_breeds.removeAll()
//                            let json = JSON(data as Any)
//                            if let array = json.arrayObject{
//                                var num = 0
//                                for one in array{
//                                    num += 1
//                                    ds_alldog_breeds.append(KeyValueModel(key: JSON(JSON(one)["image"].object)["url"].stringValue,value: JSON(one)["name"].stringValue))
//                                    if num == array.count{
//                                        print("thisisdogbreeds ===> ", ds_alldog_breeds.count)
//                                        ApiManager.getAllCats { (isSuccess, data) in
//                                            if isSuccess{
//                                                ds_allcat_breeds.removeAll()
//                                                let json = JSON(data as Any)
//                                                if let cat_array = json.arrayObject{
//                                                    var num = 0
//                                                    for one in cat_array{
//                                                        num += 1
//                                                        ds_allcat_breeds.append(KeyValueModel(key:JSON(JSON(one)["image"].object)["url"].stringValue, value: JSON(one)["name"].stringValue))
//                                                        if num == cat_array.count{
//                                                            completion(true,status)
//                                                        }
//                                                    }
//                                                }
//                                            }else{
//                                                completion(false, status)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }else{
//                            completion(false, status)
//                        }
//                    }
//                } else if(status == 201)  {// email exist
//                    completion(false, status)
//                } else if(status == 202)  {// pictuer upload fail
//                    completion(false, status)
//                } else{
//                    completion(false, status)
//                }
//            }
//        }
//    }
//
//    class func signup(user_name : String,email: String, password: String,user_photo: String,user_location: String, latitude: String, longitude: String,completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
//        let requestURL = SERVER_URL + "signup"
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                if !user_photo.isEmpty{
//                    multipartFormData.append(URL(fileURLWithPath: user_photo), withName: PARAMS.USER_PHOTO)
//                }
//                multipartFormData.append( user_name.data(using:.utf8)!, withName: PARAMS.USER_NAME)
//                multipartFormData.append( email.data(using:.utf8)!, withName: PARAMS.EMAIL)
//                multipartFormData.append( password.data(using:.utf8)!, withName: PARAMS.PASSWORD)
//                multipartFormData.append( user_location.data(using:.utf8)!, withName: PARAMS.USER_LOCATION)
//                multipartFormData.append( latitude.data(using:.utf8)!, withName: PARAMS.LAT)
//                multipartFormData.append( longitude.data(using:.utf8)!, withName: PARAMS.LONG)
//                if let devicetoken = deviceTokenString{
//                    multipartFormData.append( devicetoken.data(using:.utf8)!, withName: PARAMS.TOKEN)
//                }else{
//                    multipartFormData.append( "deviceTokenNull".data(using:.utf8)!, withName: PARAMS.TOKEN)
//                }
//            },
//            to: requestURL,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                    case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        switch response.result {
//                            case .failure: completion(false, nil)
//                            case .success(let data):
//                            let dict = JSON(data)
//                            let status = dict[PARAMS.RESULTCODE].intValue
//                            if status == SUCCESSTRUE {
//                                if let user_data = dict[PARAMS.USER_INFO].arrayObject{
//                                    thisuser.clearUserInfo()
//                                    thisuser = UserModel(JSON(user_data.first!))
//                                    thisuser.saveUserInfo()
//                                    thisuser.loadUserInfo()
//                                }
//                                if let pets_data = dict[PARAMS.PETS_INFO].arrayObject{
//                                    my_pets.removeAll()
//                                    if pets_data.count > 0{
//                                        for one in pets_data{
//                                            my_pets.append(PetModel(JSON(one)))
//                                        }
//                                    }
//                                }
//                                ApiManager.getAllDogs { (isSuccess, data) in
//                                    if isSuccess{
//                                        ds_alldog_breeds.removeAll()
//                                        let json = JSON(data as Any)
//                                        if let array = json.arrayObject{
//                                            var num = 0
//                                            for one in array{
//                                                num += 1
//                                                ds_alldog_breeds.append(KeyValueModel(key: JSON(JSON(one)["image"].object)["url"].stringValue,value: JSON(one)["name"].stringValue))
//                                                if num == array.count{
//                                                    print("thisisdogbreeds ===> ", ds_alldog_breeds.count)
//                                                    ApiManager.getAllCats { (isSuccess, data) in
//                                                        if isSuccess{
//                                                            ds_allcat_breeds.removeAll()
//                                                            let json = JSON(data as Any)
//                                                            if let cat_array = json.arrayObject{
//                                                                var num = 0
//                                                                for one in cat_array{
//                                                                    num += 1
//                                                                    ds_allcat_breeds.append(KeyValueModel(key:JSON(JSON(one)["image"].object)["url"].stringValue, value: JSON(one)["name"].stringValue))
//                                                                    if num == cat_array.count{
//                                                                        completion(true,status)
//                                                                    }
//                                                                }
//                                                            }
//                                                        }else{
//                                                            completion(false, status)
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }else{
//                                        completion(false, status)
//                                    }
//                                }
//                            } else if(status == 201)  {// email exist
//                                completion(false, status)
//                            } else if(status == 202)  {// pictuer upload fail
//                                completion(false, status)
//                            } else{
//                                completion(false, status)
//                            }
//                        }
//                    }
//                    case .failure( _):
//                    completion(false, nil)
//                }
//            }
//        )
//    }
//
//    class func uploadPost(pet_id: Int,post_des: String,media_type: Int, media_ratio: Float, attachments: [(Data, String, String, String)],completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
//        let requestURL = SERVER_URL + "uploadPost"
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//
//                for i in 0..<attachments.count {
//                    multipartFormData.append(attachments[i].0, withName: attachments[i].1, fileName: attachments[i].2, mimeType: attachments[i].3)
//                }
//
//                multipartFormData.append( "\(Int(NSDate().timeIntervalSince1970) * 1000)".data(using:.utf8)!, withName: PARAMS.POST_TIME)
//                multipartFormData.append( "\(pet_id)".data(using:.utf8)!, withName: PARAMS.PET_ID)
//                multipartFormData.append("\(post_des.utf8)".data(using:.utf8)!, withName: PARAMS.POST_DES)
//                multipartFormData.append( "\(media_type)".data(using:.utf8)!, withName: PARAMS.MEDIA_TYPE)
//                multipartFormData.append( "\(media_ratio)".data(using:.utf8)!, withName: PARAMS.MEDIA_RATIO)
//            },
//            to: requestURL,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                    case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        switch response.result {
//                            case .failure: completion(false, nil)
//                            case .success(let data):
//                            let dict = JSON(data)
//                            let status = dict[PARAMS.RESULTCODE].intValue
//                            if status == SUCCESSTRUE {
//                                completion(true, status)
//                            }else{
//                                completion(false, status)
//                            }
//                        }
//                    }
//                    case .failure( _):
//                    completion(false, nil)
//                }
//            }
//        )
//    }
//}
//
