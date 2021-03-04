
//
//  ForgotPwdVC.swift
//  EveraveUpdate
//
//  Created by Mac on 6/29/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//
import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import KAPinField

class ForgotVC: BaseVC {

    @IBOutlet weak var otpCodeView: KAPinField!
    @IBOutlet weak var edt_email: UITextField!
    //@IBOutlet weak var edt_userName: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    //var verificationID = ""
    @IBOutlet weak var uiv_dlg: UIView!
    @IBOutlet weak var uiv_dlgBack: UIView!
    
    @IBOutlet weak var edt_newPwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    var pincode = ""
    var email = ""
                 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStyle()
        self.setDlg()
        self.edt_email.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavBar()
        self.title = "Reset Password"
        self.addleftButton()
    }
    
    func addleftButton() {
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(leftBtnClicked), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemBack
    }
    
    @objc func leftBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setDlg()  {
        self.uiv_dlgBack.isHidden = true
        self.uiv_dlg.isHidden = true
        self.edt_newPwd.text = ""
        self.confirmPwd.text = ""
    }
    
    @IBAction func gotoSend(_ sender: Any) {
        //self.username = self.edt_userName.text!
        self.email = self.edt_email.text!
        if email.isEmpty{
            self.showToast("Please input your email")
            return
        }
        
        if !(email.isValidEmail()){
            self.showToast("Please input valid email")
            //self.progShowInfo(true, msg: "Invalid phone number")
            return
        }
        else{
            self.showLoadingView(vc: self)
            ApiManager.forgot(email: self.email ) { (isSuccess, data) in
                self.hideLoadingView()
                self.edt_email.text = ""
                if isSuccess{
                    self.pincode = data as! String
                    print(self.pincode)
                    self.refreshPinField()
                    self.sendOTP()
                }else{
                    self.showAlerMessage(message: "Email not exist")// username not exist
                    //メールが存在しません。
                }
            }
        }
    }
    
    @IBAction func sendNewPwd(_ sender: Any) {
        let newPwd = self.edt_newPwd.text
        let confirmPwd = self.confirmPwd.text
        if newPwd == "" || confirmPwd == ""{
            self.showAlerMessage(message: "Please input your password.")
            return
        }
        if confirmPwd != newPwd{
            self.showAlerMessage(message: "Please confirm your password.")
            return
        }else{
            self.showLoadingView(vc: self)
            /**DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.uiv_dlgBack.isHidden = true
                self.uiv_dlg.isHidden = true
                self.edt_newPwd.text = ""
                self.confirmPwd.text = ""
                print("success")
                //self.navigationController?.popViewController(animated: true)
                //self.showAlerMessage(message: "更新に成功。")
                let alertController = UIAlertController(title: nil, message:"更新に成功。", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }*/
            ApiManager.resetPassword(email: self.email, password: newPwd ?? "") { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.uiv_dlgBack.isHidden = true
                    self.uiv_dlg.isHidden = true
                    self.edt_newPwd.text = ""
                    self.confirmPwd.text = ""
                    print("success")
                    UserDefault.setString(key: PARAMS.PASSWORD, value: newPwd)
                    UserDefault.Sync()
                    thisuser.loadUserInfo()
                    thisuser.saveUserInfo()
                    
                    //self.navigationController?.popViewController(animated: true)
                    //self.showAlerMessage(message: "更新に成功。")
                    let alertController = UIAlertController(title: nil, message:"Reset Password Success", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(action1)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    print("network problem.")
                    self.showAlerMessage(message: "Network issue")
                    self.uiv_dlgBack.isHidden = true
                    self.uiv_dlg.isHidden = true
                    self.edt_newPwd.text = ""
                    self.confirmPwd.text = ""
                }
            }
        }
    }
    
    @IBAction func cancelPwd(_ sender: Any) {
        self.uiv_dlgBack.isHidden = true
        self.uiv_dlg.isHidden = true
        self.edt_newPwd.text = ""
        self.confirmPwd.text = ""
    }
    
    @IBAction func backtoLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendOTP()  {
        self.otpCodeView.becomeFirstResponder()
        self.showAlerMessage(message: "Please check your mailbox and input your verification code")
        //self.showAlerMessage(message: "Please input your verification code.")
        self.btn_submit.setTitle("Resend", for: .normal)
        self.dismissKeyboard()
    }
    
    func setStyle() {
        otpCodeView.properties.delegate = self
//        otpCodeView.properties.token = "-"
        otpCodeView.properties.animateFocus = true
        otpCodeView.text = ""
        otpCodeView.keyboardType = .numberPad
        otpCodeView.properties.numberOfCharacters = 6
        otpCodeView.appearance.tokenColor = UIColor.black.withAlphaComponent(0.2)
        otpCodeView.appearance.tokenFocusColor = UIColor.black.withAlphaComponent(0.2)
        otpCodeView.appearance.textColor = UIColor.black
        otpCodeView.appearance.font = .menlo(40)
        otpCodeView.appearance.kerning = 24
        otpCodeView.appearance.backOffset = 5
        otpCodeView.appearance.backColor = UIColor.clear
        otpCodeView.appearance.backBorderWidth = 1
        otpCodeView.appearance.backBorderColor = UIColor.black.withAlphaComponent(0.2)
        otpCodeView.appearance.backCornerRadius = 4
        otpCodeView.appearance.backFocusColor = UIColor.clear
        otpCodeView.appearance.backBorderFocusColor = UIColor.black.withAlphaComponent(0.8)
        otpCodeView.appearance.backActiveColor = UIColor.clear
        otpCodeView.appearance.backBorderActiveColor = UIColor.black
        otpCodeView.appearance.backRounded = false
        
    }
    
     func refreshPinField() {
        otpCodeView.text = ""
        setStyle()
    }
}

extension ForgotVC : KAPinFieldDelegate {
    
    func pinField(_ field: KAPinField, didChangeTo string: String, isValid: Bool) {
        if isValid {
            print("Valid input: \(string) ")
        } else {
            print("Invalid input: \(string) ")
            self.otpCodeView.animateFailure()
        }
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        print("didFinishWith : \(code)")
        if self.pincode == code{
            field.animateSuccess(with: "👍") {
                print("OK")
                self.uiv_dlg.isHidden = false
                self.uiv_dlgBack.isHidden = false
            }
        }else{
            self.showAlerMessage(message: "PIN code is incorret")
            field.animateFailure()
            self.otpCodeView.becomeFirstResponder()
            return
        }
    }
}

