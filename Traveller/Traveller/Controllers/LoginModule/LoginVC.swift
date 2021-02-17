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
        setLogin()
    }
    
    func setLogin()  {
        self.showLoadingView(vc: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideLoadingView()
            self.gotoTabControllerWithIndex(0)
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        setLogin()
    }
    @IBAction func loginWithPhoneNumber(_ sender: Any) {
        setLogin()
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        self.gotoVC("LoginNav")
    }
    
    @IBAction func loginWithGuest(_ sender: Any) {
        setLogin()
    }
    @IBAction func signUp(_ sender: Any) {
        //self.gotoNavPresent("SignUpVC", fullscreen: true)
        self.gotoVC("SignUpVC")
    }
}
