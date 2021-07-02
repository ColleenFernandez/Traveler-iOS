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
import DLRadioButton

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
    @IBOutlet weak var btn_chanagepwd: UIButton!
    
    @IBOutlet weak var btn_update: UIButton!
    @IBOutlet weak var btn_logout: UIButton!
    @IBOutlet weak var btn_changepwds: UIButton!
    
    @IBOutlet weak var lbl_changepwd: UILabel!
    @IBOutlet weak var btn_eng: DLRadioButton!
    @IBOutlet weak var btn_rus: DLRadioButton!
    
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
            setEdtPlaceholder(edt_firstname, placeholderText:language.language == .eng ? "First Name" : RUS.FIRST_NAME, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_lastname, placeholderText:language.language == .eng ? "Last Name" : RUS.LAST_NAME, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_email, placeholderText:language.language == .eng ? "Email" : RUS.EMAIL, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_birthday, placeholderText:language.language == .eng ? "Date of Birth" : RUS.DATE_OF_BIRTH, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_pwd, placeholderText:"*********", placeColor: UIColor.lightGray, padding: .left(20))
            edt_firstname.isUserInteractionEnabled = false
            edt_lastname.isUserInteractionEnabled = false
            edt_email.isUserInteractionEnabled = false
            edt_birthday.isUserInteractionEnabled = false
            edt_pwd.isUserInteractionEnabled = false
            showLoginAlert()
        }else{
            setUI()
            uiv_camera.addTapGesture(tapNumber: 1, target: self, action: #selector(onEdtPhoto))
            self.imagePicker = ImagePicker1(presentationController: self, delegate: self, is_cropping: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func englishBtnClicked(_ sender: Any) {
        //TODO: english clicked
        language.set(.eng)
        language.save()
        setUI()
        setTab()
    }
    
    @IBAction func russianBtnClicked(_ sender: Any) {
        //TODO: english clicked
        language.set(.rus)
        language.save()
        setUI()
        setTab()
    }
    
    func setTab()  {
        let tabbarController = self.navigationController?.tabBarController as! TabBarVC
        
        guard let items = tabbarController.tabBar.items else { return }
        if language.language == .eng{
            items[0].title = "Search"
            items[1].title = "My trips"
            items[2].title = "Chat"
            items[3].title = "Rating"
            items[4].title = "Profile"
        }else{
            items[0].title = RUS.SEARCH
            items[1].title = RUS.MY_TRIPS
            items[2].title = RUS.CHAT
            items[3].title = RUS.RATING
            items[4].title = RUS.PROFILE
        }
    }
    
    func setUI()  {
        setChangePwd(false)
        editInit()
        if language.language == .eng{
            self.btn_eng.isSelected = true
        }else{
            self.btn_rus.isSelected = true
        }
    }
    
    func editInit() {
        setEdtPlaceholder(edt_firstname, placeholderText:language.language == .eng ? "First Name" : RUS.FIRST_NAME, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_lastname, placeholderText:language.language == .eng ? "Last Name" : RUS.LAST_NAME, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_email, placeholderText:language.language == .eng ? "Email" : RUS.EMAIL, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_birthday, placeholderText:language.language == .eng ? "Date of Birth" : RUS.DATE_OF_BIRTH, placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_pwd, placeholderText:"*********", placeColor: UIColor.lightGray, padding: .left(20))
        
        edt_firstname.text = thisuser.first_name
        edt_lastname.text = thisuser.last_name
        edt_email.text = thisuser.user_email
        edt_email.textColor = .lightGray
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
        
        self.btn_chanagepwd.setTitle(language.language == .eng ? "Change Password" : RUS.CHANGE_PASSWORD, for: .normal)
        self.btn_update.setTitle(language.language == .eng ? "Update" : RUS.UPDATE, for: .normal)
        self.btn_logout.setTitle(language.language == .eng ? "Logout" : RUS.LOGOUT, for: .normal)
        self.btn_changepwds.setTitle(language.language == .eng ? "Change Password" : RUS.CHANGE_PASSWORD, for: .normal)
        self.lbl_changepwd.text = language.language == .eng ? "Change Password" : RUS.CHANGE_PASSWORD
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
                self.showToast(language.language == .eng ? "Please input your first name" : RUS.PLEASE_INPUT_YOUR_FIRST_NAME)
                return
            }
            
            if last_name.isEmpty{
                self.showToast(language.language == .eng ? "Please input your last name": RUS.PLEASE_INPUT_YOUR_LAST_NAME)
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
            if birthday.isEmpty{
                self.showToast(language.language == .eng ? "Please input your birthday" : RUS.PLEASE_INPUT_YOUR_BIRTHDAY)
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
                        self.showAlerMessage(message: language.language == .eng ? "Successfully Updated" : RUS.SUCCESSFULLY_UPDATED)
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
                self.showToast(language.language == .eng ? "Your session is social login. Social login doesn't need password." : RUS.YOUR_SESSION_IS_SOCIAL)
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
                self.showToast(language.language == .eng ? "Please input correct current password" : RUS.PLEASE_INPUT_CORRECT_CURRENT_PASSWORD)
                return
            }
            if let newpwd = newpwd, newpwd.isEmpty{
                self.showToast(language.language == .eng ? "Please input new password" : RUS.PLEASE_INPUT_NEW_PASSWORD)
                return
            }
            if let confirmpwd = confirmpwd, confirmpwd.isEmpty{
                self.showToast(language.language == .eng ? "Please input confirm password" : RUS.PLEASE_INPUT_CONFIRM_PASSWORD)
                return
            }
            if newpwd != confirmpwd{
                self.showToast(language.language == .eng ? "Please input matched confirm password" : RUS.PLEASE_INPUT_MATCHED_CONFIRM_PASSWORD)
                return
            }else{
                self.showLoadingView(vc: self)
                ApiManager.changePassword(password: newpwd ?? "") { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        UserDefault.setString(key: PARAMS.PASSWORD, value: newpwd)
                        thisuser.loadUserInfo()
                        thisuser.saveUserInfo()
                        self.showAlerMessage(message: language.language == .eng ? "Password updated" : RUS.PASSWORD_UPDATED)
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
            setEdtPlaceholder(edt_currentpwd, placeholderText:language.language == .eng ? "Current Password" : RUS.CURRENT_PASSWORD, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_newpwd, placeholderText:language.language == .eng ? "New Password" : RUS.NEW_PASSWORD, placeColor: UIColor.lightGray, padding: .left(20))
            setEdtPlaceholder(edt_confirmpwd, placeholderText:language.language == .eng ? "Confirm New Password" : RUS.CONFIRM_NEW_PASSWORD, placeColor: UIColor.lightGray, padding: .left(20))
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





