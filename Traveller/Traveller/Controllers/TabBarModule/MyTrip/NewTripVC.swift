//
//  NewTripVC.swift
//  Traveller
//
//  Created by top Dev on 15.02.2021.
//

import UIKit
import GooglePlaces
import ActionSheetPicker_3_0
import BEMCheckBox

class NewTripVC: BaseVC {
    
    @IBOutlet weak var edt_flyingfrom: UITextField!
    @IBOutlet weak var edt_flyingto: UITextField!
    @IBOutlet weak var edt_date: UITextField!
    @IBOutlet weak var edt_time: UITextField!
    @IBOutlet weak var edt_weight: UITextField!
    @IBOutlet weak var edt_price: UITextField!
    @IBOutlet weak var txv_additionalinformation: UITextView!
    
    @IBOutlet weak var cus_document: BEMCheckBox!
    @IBOutlet weak var cus_medicine: BEMCheckBox!
    @IBOutlet weak var cus_makeup: BEMCheckBox!
    @IBOutlet weak var cus_money: BEMCheckBox!
    @IBOutlet weak var cus_food: BEMCheckBox!
    @IBOutlet weak var cus_mobile: BEMCheckBox!
    @IBOutlet weak var cus_laptop: BEMCheckBox!
    @IBOutlet weak var cus_electroinics: BEMCheckBox!
    @IBOutlet weak var cus_books: BEMCheckBox!
    @IBOutlet weak var cus_toys: BEMCheckBox!
    @IBOutlet weak var cus_clothes: BEMCheckBox!
    @IBOutlet weak var cus_shoes: BEMCheckBox!
    @IBOutlet weak var cus_selectall: BEMCheckBox!
    
    @IBOutlet weak var lbl_document: UILabel!
    @IBOutlet weak var lbl_medicine: UILabel!
    @IBOutlet weak var lbl_makeup: UILabel!
    @IBOutlet weak var lbl_money: UILabel!
    @IBOutlet weak var lbl_food: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_laptop: UILabel!
    @IBOutlet weak var lbl_electronics: UILabel!
    @IBOutlet weak var lbl_books: UILabel!
    @IBOutlet weak var lbl_toys: UILabel!
    @IBOutlet weak var lbl_clothes: UILabel!
    @IBOutlet weak var lbl_shoes: UILabel!
    @IBOutlet weak var lbl_checkall: UILabel!
    @IBOutlet weak var lbl_icanbring: UILabel!
    @IBOutlet weak var btn_save_trip: dropShadowDarkButton!
    
    var is_document_check: Bool = false
    var is_medicine_check: Bool = false
    var is_makeup_check: Bool = false
    var is_money_check: Bool = false
    var is_food_check: Bool = false
    var is_mobile_check: Bool = false
    var is_laptop_check: Bool = false
    var is_electronices_check: Bool = false
    var is_books_check: Bool = false
    var is_toys_check: Bool = false
    var is_clothes_check: Bool = false
    var is_shoes_check: Bool = false
    
    var selected_field = 0 // 1: from 2: to
    var date_timestamp: Int?
    var start_timestamp: Int?
    var check_boxs = [BEMCheckBox]()
    var is_selectall =  false
    var from_id: String = ""
    var to_id: String = ""
    var from_country: String = ""
    var to_country: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        setSelectAllCheck()
    }
    
    func setUI() {
        removeNavbarTopLine()
        // setting txv_additionalinformation information
        
        self.txv_additionalinformation.delegate = self
        txv_additionalinformation.text = language.language == .eng ? "You can add additional information here to share with other people" : RUS.YOU_CAN_ADD_ADDITIONAL_INFORMATION_HERE
        txv_additionalinformation.textColor = UIColor.darkGray
        // end txv_additionalinformation information
        
        self.navigationItem.title = language.language == .eng ? "New Trip" : RUS.NEW_TRIP
        editInit()
        check_boxs = [cus_document, cus_medicine, cus_makeup,cus_money, cus_food, cus_mobile,  cus_laptop, cus_electroinics, cus_books, cus_toys,   cus_clothes,cus_shoes]
        for one in check_boxs{
            setCheckBox(one, checked: false)
        }
        self.addLeftButton4NavBar()
        self.lbl_document.text = language.language == .eng ? "Document" : RUS.DOCUMENT
        self.lbl_medicine.text = language.language == .eng ? "Medicine" : RUS.MEDICINE
        self.lbl_makeup.text = language.language == .eng ? "Makeup" : RUS.MAKEUP
        self.lbl_money.text = language.language == .eng ? "Money" : RUS.MONEY
        self.lbl_food.text = language.language == .eng ? "Food" : RUS.FOOD
        self.lbl_mobile.text = language.language == .eng ? "Mobile" : RUS.MOBILE
        self.lbl_laptop.text = language.language == .eng ? "Laptop" : RUS.LAPTOP
        self.lbl_electronics.text = language.language == .eng ? "Electronics" : RUS.ELECTRONICS
        self.lbl_books.text = language.language == .eng ? "Books" : RUS.BOOKS
        self.lbl_toys.text = language.language == .eng ? "Toys" : RUS.TOYS
        self.lbl_clothes.text = language.language == .eng ? "Clothes" : RUS.CLOTHES
        self.lbl_shoes.text = language.language == .eng ? "Shoes" : RUS.SHOES
        self.lbl_checkall.text = language.language == .eng ? "Select All" : RUS.SELECT_ALL
        self.lbl_icanbring.text =  language.language == .eng ? "I can bring the following" : RUS.I_CAN_BRING_FOLLOWING
        self.btn_save_trip.setTitle(language.language == .eng ? "Save Trip" : RUS.SAVE_TRIP, for: .normal)
    }
    
    @IBAction func checkallBtnClicked(_ sender: Any) {
        self.is_selectall = !self.is_selectall
        setCheckBox(self.cus_selectall, checked: self.is_selectall)
        check_boxs = [cus_document, cus_medicine, cus_makeup,cus_money, cus_food, cus_mobile,  cus_laptop, cus_electroinics, cus_books, cus_toys,   cus_clothes,cus_shoes]
        for one in check_boxs{
            setCheckBox(one, checked: self.is_selectall)
        }
    }
    
    @IBAction func docBtnClicked(_ sender: Any) {
        self.is_document_check = !self.is_document_check
        setCheckBox(self.cus_document, checked: self.is_document_check)
    }
    
    @IBAction func medicineBtnClicked(_ sender: Any) {
        self.is_medicine_check = !self.is_medicine_check
        setCheckBox(self.cus_medicine, checked: self.is_medicine_check)
    }
    
    @IBAction func makeupBtnClicked(_ sender: Any) {
        self.is_makeup_check = !self.is_makeup_check
        setCheckBox(self.cus_makeup, checked: self.is_makeup_check)
    }
    
    @IBAction func moneyBtnClicked(_ sender: Any) {
        self.is_money_check = !self.is_money_check
        setCheckBox(self.cus_money, checked: self.is_money_check)
    }
    
    @IBAction func foodBtnClicked(_ sender: Any) {
        self.is_food_check = !self.is_food_check
        setCheckBox(self.cus_food, checked: self.is_food_check)
    }
    
    @IBAction func mobileBtnClicked(_ sender: Any) {
        self.is_mobile_check = !self.is_mobile_check
        setCheckBox(self.cus_mobile, checked: self.is_mobile_check)
    }
    
    @IBAction func laptopBtnClicked(_ sender: Any) {
        self.is_laptop_check = !self.is_laptop_check
        setCheckBox(self.cus_laptop, checked: self.is_laptop_check)
    }
    
    @IBAction func electronicsBtnClicked(_ sender: Any) {
        self.is_electronices_check = !self.is_electronices_check
        setCheckBox(self.cus_electroinics, checked: self.is_electronices_check)
    }
    
    @IBAction func booksBtnClicked(_ sender: Any) {
        self.is_books_check = !self.is_books_check
        setCheckBox(self.cus_books, checked: self.is_books_check)
    }
    
    @IBAction func toysBtnClicked(_ sender: Any) {
        self.is_toys_check = !self.is_toys_check
        setCheckBox(self.cus_toys, checked: self.is_toys_check)
    }
    
    @IBAction func clothesBtnClicked(_ sender: Any) {
        self.is_clothes_check = !self.is_clothes_check
        setCheckBox(self.cus_clothes, checked: self.is_clothes_check)
    }
    
    @IBAction func shoesBtnClicked(_ sender: Any) {
        self.is_shoes_check = !self.is_shoes_check
        setCheckBox(self.cus_shoes, checked: self.is_shoes_check)
    }
    
    
    
    func addLeftButton4NavBar() {
        // if needed i will add
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(addTappedLeftBtn), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemBack
    }
    
    @objc func addTappedLeftBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func editInit() {
        setEdtPlaceholder(edt_flyingfrom, placeholderText:language.language == .eng ? "Flying from" : RUS.FLYING_FROM, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_flyingto, placeholderText:language.language == .eng ? "Flying to" : RUS.FLYING_TO, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_date, placeholderText:language.language == .eng ? "Arrival date" : RUS.ARRIVAL_DATE, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_time, placeholderText:language.language == .eng ? "Arrival time" : RUS.ARRIVAL_TIME, placeColor: UIColor.lightGray, padding: .left(15))
        
        setEdtPlaceholder(edt_weight, placeholderText:language.language == .eng ? "Can carry" : RUS.CAN_CARRY, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_price, placeholderText:language.language == .eng ? "Price per KG" : RUS.PRICE_PER_KG, placeColor: UIColor.lightGray, padding: .left(15))
    }
    
    func setCheckBox(_ checkbox: BEMCheckBox, checked: Bool)  {
        checkbox.lineWidth = 1.0
        checkbox.onCheckColor = .black
        checkbox.onFillColor = .white
        checkbox.boxType = .square
        checkbox.onAnimationType = .oneStroke
        checkbox.offAnimationType = .bounce
        checkbox.isUserInteractionEnabled = true
        checkbox.on = checked
    }
    
    func setSelectAllCheck()  {
        self.cus_selectall.lineWidth = 1.0
        self.cus_selectall.onCheckColor = .black
        self.cus_selectall.onFillColor = .white
        self.cus_selectall.boxType = .square
        self.cus_selectall.onAnimationType = .oneStroke
        self.cus_selectall.offAnimationType = .bounce
        self.cus_selectall.isUserInteractionEnabled = true
        self.cus_selectall.on = false
    }
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        
        let datePicker = ActionSheetDatePicker(title:language.language == .eng ? "Please select arrival date" : RUS.PLEASE_SELECT_ARRIVAL_DATE, datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if  Int(NSDate().timeIntervalSince1970 * 1000) > Int(datee.timeIntervalSince1970) * 1000 + Constants.ONE_HOUR_TIMESTAMP{
                    self.edt_date.text = ""
                    self.showAlerMessage(message: language.language == .eng ? "Please select arrival date" : RUS.PLEASE_SELECT_ARRIVAL_DATE)
                    return
                }else{
                    self.date_timestamp = Int(datee.timeIntervalSince1970) * 1000
                    if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                        self.edt_date.text = String(local_time.split(separator: " ")[0])
                    }
                }
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func btnEndDateClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:language.language == .eng ? "Please select arrival time" : RUS.PLEASE_SELECT_ARRIVAL_TIME, datePickerMode: UIDatePicker.Mode.time, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if let date_timestamp = self.date_timestamp{
                    if date_timestamp - Int(NSDate().timeIntervalSince1970) * 1000 <= Constants.ONE_DAY_TIMESTAMP - Constants.ONE_HOUR_TIMESTAMP{
                        if  Int(datee.timeIntervalSince1970) * 1000 - Int(NSDate().timeIntervalSince1970 * 1000) <= Constants.ONE_HOUR_TIMESTAMP - Constants.ONE_MIN_TIMESTAMP{
                            
                            self.edt_time.text = ""
                            self.showAlerMessage(message: language.language == .eng ? "Please select correct arrival time" : "пожалуйста, выберите правильную дату прибытия")
                            return
                        }else{
                            self.start_timestamp = Int(datee.timeIntervalSince1970) * 1000
                            if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                                self.edt_time.text = String(local_time.split(separator: " ")[1]) + " " + String(local_time.split(separator: " ")[2])
                            }
                        }
                    }else{
                        let timediff = Int(NSDate().timeIntervalSince1970) * 1000 - Int(datee.timeIntervalSince1970) * 1000
                        self.start_timestamp = date_timestamp - timediff
                        if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                            self.edt_time.text = String(local_time.split(separator: " ")[1]) + " " + String(local_time.split(separator: " ")[2])
                        }
                    }
                }
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func flyingFromFieldTapped(_ sender: Any) {
        selected_field = 1
        edt_flyingfrom.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
//        let filter = GMSAutocompleteFilter()
//        filter.type = GMSPlacesAutocompleteTypeFilter.city
//        acController.autocompleteFilter = filter
        
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func flyingToFieldTapped(_ sender: Any) {
        selected_field = 2
        edt_flyingto.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
//        let filter = GMSAutocompleteFilter()
//        filter.type = GMSPlacesAutocompleteTypeFilter.city
//        acController.autocompleteFilter = filter
        
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        let from_location = edt_flyingfrom.text ?? ""
        let to_location = edt_flyingto.text ?? ""
        let weight = edt_weight.text ?? ""
        let price = edt_price.text ?? ""
        let date = edt_date.text ?? ""
        let time = edt_time.text ?? ""
        var des = txv_additionalinformation.text ?? ""
        if des == "You can add additional information here to share with other people" || des == RUS.YOU_CAN_ADD_ADDITIONAL_INFORMATION_HERE{
            des = ""
        }
        
        var items = [String]()
        for i in 0 ..< check_boxs.count{
            if check_boxs[i].on{
                items.append(Constants.items[i])
            }
        }
        if from_location.isEmpty{
            self.showAlerMessage(message: language.language == .eng ? "Please select flying from location.": RUS.PLEASE_SELECT_FLYING_LOCATION)
            return
        }
        if to_location.isEmpty{
            self.showAlerMessage(message: language.language == .eng ? "Please select flying to location." : RUS.PLEASE_SELECT_TO_LOCATION)
            return
        }
        if date.isEmpty{
            self.showAlerMessage(message: language.language == .eng ? "Please select arrival date" : RUS.PLEASE_SELECT_ARRIVAL_DATE)
            return
        }
        if time.isEmpty{
            self.showAlerMessage(message: language.language == .eng ? "Please select arrival time" : RUS.PLEASE_SELECT_ARRIVAL_TIME)
            return
        }
        
        if weight.isEmpty{
            self.showAlerMessage(message: language.language == .eng ? "Please input weight." : RUS.PLEASE_INPUT_WEIGHT)
            return
        }
        if price.isEmpty{
            self.showAlerMessage(message: language.language == .eng ? "Please input price." : RUS.PLEASE_INPUT_PRICE)
            return
        }
        if items.count == 0{
            self.showAlerMessage(message: language.language == .eng ? "Please selct bring items." : RUS.PLEASE_INPUT_BRING_ITEMS)
            return
        }else{
            self.showLoadingView(vc: self)
            ApiManager.createTravel(travel_time: self.start_timestamp ?? Int(NSDate().timeIntervalSince1970 * 1000), weight: weight.toFloat() ?? 0.0, price: price.toInt() ?? 0, items: items.joined(separator: ","), des: des, from_location: from_location, to_location: to_location, from_id: self.from_id, to_id:self.to_id, from_country: from_country, to_country: self.to_country) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        /**DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideLoadingView()
            self.navigationController?.popViewController(animated: true)
        }*/
    }
}

extension NewTripVC : GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    if selected_field == 1{
        edt_flyingfrom.text = place.formattedAddress
        self.from_id = place.placeID ?? ""
        if let addressComponents = place.addressComponents{
            for one in addressComponents{
                for two in one.types{
                    if two == "country"{
                        print(one.shortName ?? "")
                        self.from_country = one.shortName ?? ""
                        break
                    }
                }
            }
        }
    }else if selected_field == 2{
        edt_flyingto.text = place.formattedAddress
        self.to_id = place.placeID ?? ""
        if let addressComponents = place.addressComponents{
            for one in addressComponents{
                for two in one.types{
                    if two == "country"{
                        print(one.shortName ?? "")
                        self.to_country = one.shortName ?? ""
                        break
                    }
                }
            }
        }
    }else{
        print("default")
    }
    dismiss(animated: true, completion: nil)
  }
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // Handle the error
    print("Error: ", error.localizedDescription)
  }
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    // Dismiss when the user canceled the action
    dismiss(animated: true, completion: nil)
  }
}

extension NewTripVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = language.language == .eng ? "You can add additional information here to share with other people" : RUS.YOU_CAN_ADD_ADDITIONAL_INFORMATION_HERE
            textView.textColor = UIColor.darkGray
        }
    }
}
