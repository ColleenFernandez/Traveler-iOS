//
//  AppDelegate.swift
//  Traveller
//
//  Created by top Dev on 10.02.2021.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import FirebaseCore

var thisuser:UserModel!
var deviceTokenString: String?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        GMSPlacesClient.provideAPIKey(PLACE_API_KEY)
        FirebaseApp.configure()
        
        thisuser = UserModel()
        thisuser.loadUserInfo()
        
        thisuser.user_id = 100
        thisuser.first_name = "Adam"
        thisuser.last_name = "Errikson"
        thisuser.birthday = 620129575
        thisuser.user_email = "adam@gmail.com"
        thisuser.user_photo = "https://i.pinimg.com/236x/5d/34/a7/5d34a7134293e8db3cd95410269ce63d.jpg"
        thisuser.rating = 4.5
        thisuser.phone_number = "18605312109"
        thisuser.password = "12345"
        
        thisuser.saveUserInfo()
        UserDefault.Sync()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

