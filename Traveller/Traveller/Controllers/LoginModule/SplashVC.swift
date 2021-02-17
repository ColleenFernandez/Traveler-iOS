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
                self.showLoadingView(vc: self)
                /*ApiManager.signin(email: thisuser.user_email ?? "", password: thisuser.password ?? "") { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        UserDefault.setBool(key: PARAMS.LOGOUT, value: false)
                        self.gotoTabControllerWithIndex(0)
                    }else{
                        self.gotoVC("LoginNav")
                    }
                }*/
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideLoadingView()
                    self.gotoVC("LoginVCNav")
                }
                
            }else{
                self.gotoVC("LoginVCNav")
            }
        }else{
            self.gotoVC("LoginVCNav")
        }
    }
}
