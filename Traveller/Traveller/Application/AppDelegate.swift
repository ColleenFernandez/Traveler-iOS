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
import FBSDKCoreKit
import GoogleSignIn

var thisuser:UserModel!
var deviceTokenString: String?
var language: Language!

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        GMSPlacesClient.provideAPIKey(PLACE_API_KEY)

        FirebaseApp.configure()
        
        thisuser = UserModel()
        thisuser.loadUserInfo()
        thisuser.saveUserInfo()
        
        language = Language()
        language.load()
        
        UserDefault.Sync()
        // for google signin
        GIDSignIn.sharedInstance().clientID = Constants.CLIENT_ID
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

