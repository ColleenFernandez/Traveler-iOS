//
//  ProfileVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//


import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import Photos
import ActionSheetPicker_3_0
import SKCountryPicker
import Kingfisher

class ProfileVC: BaseVC {
    
    @IBOutlet weak var edt_firstname: UITextField!
    @IBOutlet weak var edt_lastname: UITextField!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_birthday: UITextField!
    @IBOutlet weak var edt_phonenumber: UITextField!
    @IBOutlet weak var edt_pwd: UITextField!
    
    @IBOutlet weak var imv_avatar: UIImageView!
    @IBOutlet weak var uiv_camera: UIView!
    
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var pickCountryButton: UIButton!
    
    @IBOutlet weak var edt_currentpwd: UITextField!
    @IBOutlet weak var edt_newpwd: UITextField!
    @IBOutlet weak var edt_confirmpwd: UITextField!
    
    @IBOutlet weak var uiv_back: UIView!
    @IBOutlet weak var uiv_modal: UIView!
    var imageFils = [String]()
    var first_name = ""
    var last_name = ""
    var email = ""
    var birthday = ""
    var country_code = ""
    var phonenumber = ""
    var imagePicker: ImagePicker1!
    var birthday_timestamp: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        if !thisuser.isValid{
            setChangePwd(false)
            setEdtPlaceholder(edt_firstname, placeholderText:"First Name", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_lastname, placeholderText:"Last Name", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_email, placeholderText:"Email", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_birthday, placeholderText:"Birthday", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_pwd, placeholderText:"*********", placeColor: UIColor.lightGray, padding: .left(20))
            edt_firstname.isUserInteractionEnabled = false
            edt_lastname.isUserInteractionEnabled = false
            edt_email.isUserInteractionEnabled = false
            edt_birthday.isUserInteractionEnabled = false
            edt_pwd.isUserInteractionEnabled = false
            showLoginAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if thisuser.isValid{
            setUI()
            uiv_camera.addTapGesture(tapNumber: 1, target: self, action: #selector(onEdtPhoto))
            self.imagePicker = ImagePicker1(presentationController: self, delegate: self, is_cropping: true)
        }
    }
    
    func setUI()  {
        setChangePwd(false)
        editInit()
    }
    
    func editInit() {
        setEdtPlaceholder(edt_firstname, placeholderText:"First Name", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_lastname, placeholderText:"Last Name", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_email, placeholderText:"Email", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_birthday, placeholderText:"Birthday", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_pwd, placeholderText:"*********", placeColor: UIColor.lightGray, padding: .left(20))
        
        edt_firstname.text = thisuser.first_name
        edt_lastname.text = thisuser.last_name
        edt_email.text = thisuser.user_email
        edt_email.textColor = .darkGray
        edt_email.isUserInteractionEnabled = false
        if thisuser.birthday != 0{
            edt_birthday.text = getStrDate("\(thisuser.birthday ?? Int(NSDate().timeIntervalSince1970 * 1000))", format: "MM/dd/yyyy")
        }else{
            edt_birthday.text = nil
        }
        
        imv_avatar.kf.indicatorType = .activity
        imv_avatar.kf.setImage(with: URL(string: thisuser.user_photo ?? ""),placeholder: UIImage.init(named: "avatar"))
        
        edt_pwd.isUserInteractionEnabled = false
        if let countrycode = thisuser.phone_number?.split(separator: ",").first{
            lbl_countryCode.text = String(countrycode)
        }
        if let phone_number = thisuser.phone_number?.split(separator: ",").last{
            edt_phonenumber.text = String(phone_number)
        }
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
    
    @IBAction func pickCountryAction(_ sender: UIButton) {
        presentCountryPickerScene(withSelectionControlEnabled: true)
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        if thisuser.isValid{
            first_name = self.edt_firstname.text ?? ""
            last_name = self.edt_lastname.text ?? ""
            email = self.edt_email.text ?? ""
            birthday = self.edt_birthday.text ?? ""
            //phonenumber = self.edt_phonenumber.text ?? ""
            
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
            if birthday.isEmpty{
                self.showToast("Please input your birthday")
                return
            }
//            if phonenumber.isEmpty{
//                self.showToast("Please input your phone number")
//                return
//            }
            
            else{
                self.showLoadingView(vc: self)
                ApiManager.updateProfile(first_name: first_name, last_name: last_name, user_photo: imageFils.first ?? "", birthday: birthday_timestamp == 0 ? thisuser.birthday ?? 0 : birthday_timestamp, phone_number: thisuser.phone_number ?? "" ) { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        self.showAlerMessage(message: "Successfully Updated")
                    }else{
                        if let msg = data as? String{
                            self.showAlerMessage(message: msg)
                        }
                    }
                }
            }
        }else{
            showLoginAlert()
        }
    }
    
    @IBAction func birthdayBtnClicked(_ sender: Any) {
        if thisuser.isValid{
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
            }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
            
            datePicker?.show()
        }else{
            showLoginAlert()
        }
    }
    
    @IBAction func changePwdBtnClicked(_ sender: Any) {
        if thisuser.isValid{
            if thisuser.login_type == .email{
                setChangePwd(true)
            }else{
                self.showToast("Your session is social login. Social login doesn't need password.")
            }
            
        }else{
            showLoginAlert()
        }
    }
    @IBAction func spaceBtnclicked(_ sender: Any) {
        setChangePwd(false)
    }
    @IBAction func changeBtnClicked(_ sender: Any) {
        if thisuser.isValid{
            let currentpwd = self.edt_currentpwd.text
            let newpwd = self.edt_newpwd.text
            let confirmpwd = self.edt_confirmpwd.text
            
            if currentpwd != thisuser.password{
                self.showToast("Please input correct current password")
                return
            }
            if let newpwd = newpwd, newpwd.isEmpty{
                self.showToast("Please input new password")
                return
            }
            if let confirmpwd = confirmpwd, confirmpwd.isEmpty{
                self.showToast("Please input confirm  password")
                return
            }
            if newpwd != confirmpwd{
                self.showToast("Please input matched confirm password")
                return
            }else{
                self.showLoadingView(vc: self)
                ApiManager.changePassword(password: newpwd ?? "") { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        UserDefault.setString(key: PARAMS.PASSWORD, value: newpwd)
                        thisuser.loadUserInfo()
                        thisuser.saveUserInfo()
                        self.showAlerMessage(message: "Password updated")
                        self.setChangePwd(false)
                    }
                }
                /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideLoadingView()
                    self.showAlerMessage(message: "Password updated")
                    self.setChangePwd(false)
                }*/
            }
        }else{
            
        }
    }
    
    func setChangePwd(_ isShow: Bool)  {
        self.uiv_modal.isHidden = !isShow
        self.uiv_back.isHidden = !isShow
        if isShow{
            setEdtPlaceholder(edt_currentpwd, placeholderText:"Current Password", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_newpwd, placeholderText:"New Password", placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_confirmpwd, placeholderText:"Confirm New Password", placeColor: UIColor.lightGray, padding: .left(20))
        }else{
            edt_currentpwd.text = ""
            edt_newpwd.text = ""
            edt_confirmpwd.text = ""
        }
    }
    @IBAction func logoutBtnClicked(_ sender: Any) {
        UserDefault.setBool(key: PARAMS.LOGOUT, value: true)
        thisuser.clearUserInfo()
        thisuser.saveUserInfo()
        self.gotoVC("LoginVCNav")
    }
}

extension ProfileVC: ImagePickerDelegate1{
    
    func didSelect(image: UIImage?) {
        self.gotoUploadProfile(image)
    }
}

private extension ProfileVC {
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





