//
//  SignUpVC.swift
//  EveraveUpdate
//
//  Created by Mac on 5/9/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//


import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import Photos
import ActionSheetPicker_3_0
import SKCountryPicker
import BEMCheckBox

class SignUpVC: BaseVC {
    
    @IBOutlet weak var edt_firstname: UITextField!
    @IBOutlet weak var edt_lastname: UITextField!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_birthday: UITextField!
    @IBOutlet weak var edt_phonenumber: UITextField!
    @IBOutlet weak var edt_pwd: UITextField!
    @IBOutlet weak var edt_confirmpwd: UITextField!
    @IBOutlet weak var imv_avatar: UIImageView!
    @IBOutlet weak var uiv_camera: UIView!
    @IBOutlet weak var lbl_signupbottom: UILabel!
    @IBOutlet weak var btn_signup: UIButton!
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var pickCountryButton: UIButton!
    @IBOutlet weak var cus_termscheck: BEMCheckBox!
    @IBOutlet weak var lbl_termscheck: UILabel!
    
    var gender = "male"
    var imageFils = [String]()
    var first_name = ""
    var last_name = ""
    var email = ""
    var birthday = ""
    var country_code = ""
    var phonenumber = ""
    var password = ""
    var confirmpassword = ""
    var user_gender: String?
    var imagePicker: ImagePicker1!
    var birthday_timestamp: Int = 0
    var is_checked: Bool = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editInit()
        self.lbl_signupbottom.text = language.language == .eng ? "Do you have account already?\nBack to Signin" : "у вас уже есть аккаунт?\nВернуться, чтобы войти"
        uiv_camera.addTapGesture(tapNumber: 1, target: self, action: #selector(onEdtPhoto))
        self.imagePicker = ImagePicker1(presentationController: self, delegate: self, is_cropping: true)
    }
    
    func editInit() {
        setEdtPlaceholder(edt_firstname, placeholderText:language.language == .eng ? "First Name" : RUS.FIRST_NAME, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_lastname, placeholderText:language.language == .eng ? "Last Name" : RUS.LAST_NAME, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_email, placeholderText:language.language == .eng ? "Email" : RUS.EMAIL, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_birthday, placeholderText:language.language == .eng ? "Date of Birth" : RUS.DATE_OF_BIRTH, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_pwd, placeholderText:language.language == .eng ? "Password" : RUS.PASSWORD, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_confirmpwd, placeholderText:language.language == .eng ? "Confirm Password" : RUS.CONFIRM_NEW_PASSWORD, placeColor: UIColor.lightGray, padding: .left(20))
        // configuration of check box
        cus_termscheck.lineWidth = 1.0
        cus_termscheck.onCheckColor = .black
        cus_termscheck.onFillColor = .white
        cus_termscheck.boxType = .square
        cus_termscheck.onAnimationType = .oneStroke
        cus_termscheck.offAnimationType = .bounce
        cus_termscheck.isUserInteractionEnabled = true
        cus_termscheck.on = false
        lbl_termscheck.text = language.language == .eng ? "I agree terms and conditions" : "Я согласен с условиями"
        btn_signup.setTitle(language.language == .eng ? "Sign up" : "зарегистрироваться", for: .normal)
    }
    
    @IBAction func cus_checkbtnclicked(_ sender: Any) {
        self.is_checked = !self.is_checked
    }
    
    @objc func onEdtPhoto(gesture: UITapGestureRecognizer) -> Void {
        self.imagePicker.present(from: view)
    }
    
    func gotoUploadProfile(_ image: UIImage?) {
        self.imageFils.removeAll()
        if let image = image{
            imageFils.append(saveToFile(image:image,filePath:"photo",fileName:randomString(length: 2))) // Image save action
            self.imv_avatar.image = image
        }
    }

    @IBAction func termsbtnClickedd(_ sender: Any) {
        self.gotoWebViewWithProgressBar(Constants.TERMS_LINK, title: language.language == .eng ? "Terms & Condition" : "сроки и условия")
    }
    
    @IBAction func pickCountryAction(_ sender: UIButton) {
        presentCountryPickerScene(withSelectionControlEnabled: true)
    }
    
    @IBAction func signupBtnClicked(_ sender: Any) {
        first_name = self.edt_firstname.text ?? ""
        last_name = self.edt_lastname.text ?? ""
        email = self.edt_email.text ?? ""
        birthday = self.edt_birthday.text ?? ""
        phonenumber = self.edt_phonenumber.text ?? ""
        password = self.edt_pwd.text ?? ""
        confirmpassword = self.edt_confirmpwd.text ?? ""
        
        if imageFils.count == 0{
            self.showToast(language.language == .eng ? "Please select your user photo" : "пожалуйста, выберите свое фото пользователя.")
            return
        }
        
        if first_name.isEmpty{
            self.showToast(language.language == .eng ? "Please input your first name" : RUS.PLEASE_INPUT_YOUR_FIRST_NAME)
            return
        }
        
        if last_name.isEmpty{
            self.showToast(language.language == .eng ? "Please input your last name" : RUS.PLEASE_INPUT_YOUR_LAST_NAME)
            return
        }
        if email.isEmpty{
            self.showToast(language.language == .eng ? "Please input your email" : RUS.PLEASE_INPUT_YOUR_EMAIL)
            return
        }
        if !email.isValidEmail(){
            self.showToast(language.language == .eng ? "Please input your valid email" : RUS.PLEASE_INPUT_YOUR_VALID_EMAIL)
            return
        }
        if birthday_timestamp == 0{
            self.showToast(language.language == .eng ? "Please input your birthday" : RUS.PLEASE_INPUT_YOUR_BIRTHDAY)
            return
        }
//        if phonenumber.isEmpty{
//            self.showToast("Please input your phone number")
//            return
//        }
        if password.isEmpty{
            self.showToast(language.language == .eng ? "Please input your password" : RUS.PLEASE_INPUT_YOUR_PASSWORD)
            return
        }
        if confirmpassword.isEmpty{
            self.showToast(language.language == .eng ? "Please input confirm password" : RUS.PLEASE_INPUT_CONFIRM_PASSWORD)
            return
        }
        if password != confirmpassword{
            self.showToast(language.language == .eng ? "Please input correct confirm password" : RUS.PLEASE_INPUT_MATCHED_CONFIRM_PASSWORD)
            return
        }
        if !self.is_checked{
            self.showToast(language.language == .eng ? "Do you agree terms and conditions? If yes, please confirm checkbox." : "Вы согласны с условиями? если да, подтвердите флажок.")
            return
        }
        else{
            self.showLoadingView(vc: self)
            //self.country_code = self.lbl_countryCode.text ?? ""
            self.showLoadingView(vc: self)
            ApiManager.signup(user_email: email, first_name: first_name, last_name: last_name, user_photo: imageFils.first ?? "", birthday: birthday_timestamp, phone_number: "", login_type: .email, password: password) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if let messagge = data as? String{
                        self.showAlerMessage(message: messagge)
                    }
                }
            }
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.gotoTabControllerWithIndex(0)
            }*/
        }
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
//        self.navigationController?.popToRootViewController(animated: true)
        self.gotoVC("LoginVC")
    }
    
    @IBAction func birthdayBtnClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:language.language == .eng ? "Select your birthday" : RUS.SELECT_YOUR_BIRTHDAY, datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if  Int(NSDate().timeIntervalSince1970 * 1000) - Int(datee.timeIntervalSince1970) * 1000 <= Constants.ONE_YEAR_TIMESTAMP * 1{
                    self.birthday_timestamp = 0
                    self.showAlerMessage(message: language.language == .eng ? "Please select your correct birthday!" : RUS.PLEASE_SELECT_YOUR_CORRECT_BIRTHDAY)
                    return
                }else{
                    self.birthday_timestamp = Int(datee.timeIntervalSince1970) * 1000
                    self.edt_birthday.text = getStrDate("\(Int(datee.timeIntervalSince1970) * 1000)", format: "MM/dd/yyyy")
                }
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
}

extension SignUpVC: ImagePickerDelegate1{
    
    func didSelect(image: UIImage?) {
        self.gotoUploadProfile(image)
    }
}

private extension SignUpVC {
    func presentCountryPickerScene(withSelectionControlEnabled selectionControlEnabled: Bool = true) {
        switch selectionControlEnabled {
        case true:
            let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                
                guard let self = self else { return }
                
                self.countryImageView.isHidden = false
                self.countryImageView.image = country.flag
                self.lbl_countryCode.text = country.dialingCode
            }
            
            countryController.flagStyle = .circular
            countryController.favoriteCountriesLocaleIdentifiers = ["IN", "US"]
        case false:
            let countryController = CountryPickerController.presentController(on: self) { [weak self] (country: Country) in
                
                guard let self = self else { return }
                
                self.countryImageView.isHidden = false
                self.countryImageView.image = country.flag
                self.lbl_countryCode.text = country.dialingCode
            }
            
            countryController.flagStyle = .corner
            countryController.favoriteCountriesLocaleIdentifiers = ["IN", "US"]
        }
    }
}




