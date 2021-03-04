//
//  LoginVC.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/10/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import GoogleSignIn
import FacebookCore
import FBSDKLoginKit
import AuthenticationServices

class LoginVC: BaseVC{
    @IBOutlet weak var lbl_signup: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBar()
    }
    
    func setUI() {
        self.lbl_signup.text = "Don't you have an account yet?\nSign up here"
    }
   
    @IBAction func englishBtnClicked(_ sender: Any) {
        //TODO: english clicked
    }
    
    @IBAction func russianBtnClicked(_ sender: Any) {
        //TODO: english clicked
    }
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self](result, error) in
            
            if error != nil {
                print("Login failed")
            } else {
                if result!.isCancelled { print("login canceled") }
                else { self!.getFaceBookUserData() }
            }
        }
    }
    
    func setLogin()  {
        self.showLoadingView(vc: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideLoadingView()
            self.gotoTabControllerWithIndex(0)
        }
    }
 
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signIn()
        //setLogin()
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        self.gotoVC("LoginNav")
    }
    
    @IBAction func loginWithGuest(_ sender: Any) {
        thisuser.clearUserInfo()
        thisuser.saveUserInfo()
        setLogin()
    }
    @IBAction func signUp(_ sender: Any) {
        //self.gotoNavPresent("SignUpVC", fullscreen: true)
        self.gotoVC("SignUpVC")
    }
    
    @IBAction func appleSigninBtnClicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            self.showToast("Updated system version")
        }
    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getFaceBookUserData() {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, last_name"])) { (httpResponse, result, error) in
            let jsonResponse = JSON(result as Any)
            let socialId = jsonResponse["id"].intValue
            let id = jsonResponse["id"].stringValue
            let fname = jsonResponse["first_name"].stringValue
            let lname = jsonResponse["last_name"].stringValue
            let email = jsonResponse["email"].string ?? String(format: "%@@facebook.com", id)
            let name = jsonResponse["name"].string ?? "unknown"
            let photoUrlString = "http://graph.facebook.com/\(socialId)/picture?type=large"
            print("id: " + id)
            print("fname: " + fname)
            print("lname: " + lname)
            print("email: " + email)
            print("name: " + name)
            self.showLoadingView(vc: self)
            ApiManager.socialLogin(email: email, first_name: fname, last_name: lname, user_photo: photoUrlString, login_type: .facebook, social_id: id) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if let msg = data as? String{
                        self.showAlerMessage(message: msg)
                    }
                }
            }
        }
        connection.start()
    }
}

//MARK:- GIDSignInDelegate
extension LoginVC : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            guard let user = user else {return}
            //let socialId = user.userID!                  // For client-side use only!
             // Safe to send to the server
            let fullName = user.profile.name!
            var firstname = ""
            var lastname = ""
            firstname = String(fullName.split(separator: " ").first ?? "")
            lastname = String(fullName.split(separator: " ").last ?? "")
            let email = user.profile.email!
            let photoUrlString = user.profile.imageURL(withDimension: 300)!.description
            self.showLoadingView(vc: self)
            ApiManager.socialLogin(email: email, first_name: firstname, last_name: lastname, user_photo: photoUrlString, login_type: .google, social_id: "") { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if let msg = data as? String{
                        self.showAlerMessage(message: msg)
                    }
                }
            }
        } else {
            print("GIDSignIn:--  ", error.localizedDescription)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true) {}
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
    }
    // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            var userFirstName = ""
            var userLastName = ""
            var userEmail = ""
            
            let userIdentifier = appleIDCredential.user
            userFirstName = appleIDCredential.fullName?.givenName ?? ""
            userLastName = appleIDCredential.fullName?.familyName ?? ""
            userEmail = appleIDCredential.email ?? ""
            print("\(userIdentifier)\n \(userFirstName)\n \(userLastName)\n \(userEmail)")
            self.showLoadingView(vc: self)
            ApiManager.socialLogin(email: userEmail, first_name: userFirstName, last_name: userLastName, user_photo: "", login_type: .apple, social_id: userIdentifier) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if let msg = data as? String{
                        self.showAlerMessage(message: msg)
                    }
                }
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("\(username)\n \(password )")
            //Navigate to other view controller
        }
    }
}

extension LoginVC : ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

