//
//  SplashVC.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/10/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import _SwiftUIKitOverlayShims


class SplashVC: BaseVC {
    
    var networkStatus = 0
    //var ds_notifications = [NotiModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: {
                self.networkStatus = 1
                if self.networkStatus == 1{
                    //self.showAlerMessage(message: "No  Internet connection")
                }
                else{
                    return
                }
            }
        )
        self.checkBackgrouond()
    }
   
    func checkBackgrouond(){
        if thisuser.isValid{
            if !UserDefault.getBool(key: PARAMS.LOGOUT, defaultValue: false){
                if thisuser.login_type == .email{
                    self.showLoadingView(vc: self)
                    ApiManager.signin(email: thisuser.user_email ?? "", password: thisuser.password ?? "") { (isSuccess, data) in
                        self.hideLoadingView()
                        if isSuccess{
                            self.gotoTabControllerWithIndex(0)
                        }else{
                            self.gotoVC("LoginVCNav")
                        }
                    }
                }else{
                    self.showLoadingView(vc: self)
                    ApiManager.socialLogin(email: thisuser.user_email ?? "", first_name: thisuser.first_name ?? "", last_name: thisuser.last_name ?? "", user_photo: thisuser.user_photo ?? "", login_type: thisuser.login_type ?? .google, social_id: thisuser.password ?? "", completion: { (isSuccess, data) in
                        if isSuccess{
                            self.gotoTabControllerWithIndex(0)
                        }else{
                            self.gotoVC("LoginVCNav")
                        }
                    })
                }
                
                /**DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideLoadingView()
                    self.gotoVC("LoginVCNav")
                }*/
            }else{
                self.gotoVC("LoginVCNav")
            }
        }else{
            self.gotoVC("LoginVCNav")
        }
    }
}
