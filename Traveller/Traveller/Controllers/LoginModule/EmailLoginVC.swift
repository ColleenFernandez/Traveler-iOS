//
//  EmailLoginVC.swift
//  Traveller
//
//  Created by top Dev on 16.02.2021.
//

import UIKit

class EmailLoginVC: BaseVC, UITextFieldDelegate {

    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_password: UITextField!
    @IBOutlet weak var btn_forgot: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var lbl_back: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        //loadLayout()
    }
    
    func loadLayout() {
        self.edt_email.text = "topdevme@gmail.com"
        self.edt_password.text = "123"
    }
    
    func setUI() {
        self.edt_password.delegate = self
        if language.language == .eng{
            setEdtPlaceholder(edt_email, placeholderText:"Email", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_password, placeholderText:"Password", placeColor: UIColor.lightGray, padding: .left(20))
            self.btn_forgot.setTitle("Forgot Password?", for: .normal)
            self.btn_login.setTitle("Login", for: .normal)
            self.lbl_back.text = "Back"
        }else{
            setEdtPlaceholder(edt_email, placeholderText:RUS.EMAIL, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_password, placeholderText:RUS.PASSWORD, placeColor: UIColor.lightGray, padding: .left(20))
            self.btn_forgot.setTitle(RUS.FORGOT_PASSWORD, for: .normal)
            self.btn_login.setTitle(RUS.LOGIN, for: .normal)
            self.lbl_back.text = RUS.BACK
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = self.edt_email.text ?? ""
        let password = self.edt_password.text ?? ""
        
        if email.isEmpty{
            if language.language == .eng{
                self.showToastCenter("Please input your email")
            }else{
                self.showToastCenter(RUS.PLEASE_INPUT_YOUR_EMAIL)
            }
            return true
        }
        if !email.isValidEmail(){
            if language.language == .eng{
                self.showToastCenter("Please input your valid email")
            }else{
                self.showToastCenter(RUS.PLEASE_INPUT_YOUR_VALID_EMAIL)
            }
            return true
        }
        
        if password.isEmpty{
            if language.language == .eng{
                self.showToastCenter("Please input your password")
            }else{
                self.showToastCenter(RUS.PLEASE_INPUT_YOUR_PASSWORD)
            }
            return true
        }else{
            self.showLoadingView(vc: self)
            ApiManager.signin(email: email, password: password) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if let msg = data as? String{
                        if msg == "User doesn't exist"{
                            if language.language == .eng{
                                self.showAlerMessage(message: msg)
                            }else{
                                self.showAlerMessage(message: RUS.USER_DON_T_EXIST)
                            }
                        }else{
                            if language.language == .eng{
                                self.showAlerMessage(message: msg)
                            }else{
                                self.showAlerMessage(message: RUS.INCORRECT_PASSWORD)
                            }
                        }
                    }
                }
            }
            /**DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideLoadingView()
                self.gotoTabControllerWithIndex(0)
            }*/
        }
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        let email = self.edt_email.text ?? ""
        let password = self.edt_password.text ?? ""
        
        if email.isEmpty{
            if language.language == .eng{
                self.showToast("Please input your email")
            }else{
                self.showToast(RUS.PLEASE_INPUT_YOUR_EMAIL)
            }
            return
        }
        if !email.isValidEmail(){
            if language.language == .eng{
                self.showToast("Please input your valid email")
            }else{
                self.showToast(RUS.PLEASE_INPUT_YOUR_VALID_EMAIL)
            }
            return
        }
        
        if password.isEmpty{
            if language.language == .eng{
                self.showToast("Please input your password")
            }else{
                self.showToast(RUS.PLEASE_INPUT_YOUR_PASSWORD)
            }
            
            return
        }else{
            self.showLoadingView(vc: self)
            ApiManager.signin(email: email, password: password) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if let msg = data as? String{
                        if msg == "User doesn't exist"{
                            if language.language == .eng{
                                self.showAlerMessage(message: msg)
                            }else{
                                self.showAlerMessage(message: RUS.USER_DON_T_EXIST)
                            }
                        }else{
                            if language.language == .eng{
                                self.showAlerMessage(message: msg)
                            }else{
                                self.showAlerMessage(message: RUS.INCORRECT_PASSWORD)
                            }
                        }
                    }
                }
            }
            /**DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideLoadingView()
                self.gotoTabControllerWithIndex(0)
            }*/
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.gotoVC("LoginVCNav")
    }
    @IBAction func forgotBtnClicked(_ sender: Any) {
        self.gotoNavPresent("ForgotVC", fullscreen: true)
    }
}
