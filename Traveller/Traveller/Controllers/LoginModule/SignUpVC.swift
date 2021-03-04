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
    
    
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var pickCountryButton: UIButton!
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editInit()
        self.lbl_signupbottom.text = "Do you have account already?\nBack to Signin"
        uiv_camera.addTapGesture(tapNumber: 1, target: self, action: #selector(onEdtPhoto))
        self.imagePicker = ImagePicker1(presentationController: self, delegate: self, is_cropping: true)
    }
    
    func editInit() {
        setEdtPlaceholder(edt_firstname, placeholderText:"First Name", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_lastname, placeholderText:"Last Name", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_email, placeholderText:"Email", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_birthday, placeholderText:"Birthday", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_pwd, placeholderText:"Password", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_confirmpwd, placeholderText:"Confirm Password", placeColor: UIColor.lightGray, padding: .left(20))
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
    
    @IBAction func maleBtnClicked(_ sender: Any) {
        self.gender = "male"
    }
    
    @IBAction func femaleBtnClicked(_ sender: Any) {
        self.gender = "female"
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
            self.showToast("Please select your user photo")
            return
        }
        
        if first_name.isEmpty{
            self.showToast("Please input your first name")
            return
        }
        
        if last_name.isEmpty{
            self.showToast("Please input your last name")
            return
        }
        if email.isEmpty{
            self.showToast("Please input your email")
            return
        }
        if !email.isValidEmail(){
            self.showToast("Please input your valid email")
            return
        }
        if birthday_timestamp == 0{
            self.showToast("Please input your birthday")
            return
        }
//        if phonenumber.isEmpty{
//            self.showToast("Please input your phone number")
//            return
//        }
        if password.isEmpty{
            self.showToast("Please input your password")
            return
        }
        if confirmpassword.isEmpty{
            self.showToast("Please input confirm password")
            return
        }
        if password != confirmpassword{
            self.showToast("Please input correct confirm password")
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
        let datePicker = ActionSheetDatePicker(title:"Select your birthday", datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if  Int(NSDate().timeIntervalSince1970 * 1000) - Int(datee.timeIntervalSince1970) * 1000 <= Constants.ONE_YEAR_TIMESTAMP * 1{
                    self.birthday_timestamp = 0
                    self.showAlerMessage(message: "Please select your correct birthday!")
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




