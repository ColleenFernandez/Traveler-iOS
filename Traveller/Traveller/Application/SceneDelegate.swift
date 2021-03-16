//
//  SceneDelegate.swift
//  Traveller
//
//  Created by top Dev on 10.02.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        thisuser = UserModel()
        thisuser.loadUserInfo()
        thisuser.saveUserInfo()
        UserDefault.Sync()
    }
}

