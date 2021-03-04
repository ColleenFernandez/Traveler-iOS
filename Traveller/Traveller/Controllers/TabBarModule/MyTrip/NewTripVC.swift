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
    
    var selected_field = 0 // 1: from 2: to
    var date_timestamp: Int?
    var start_timestamp: Int?
    var check_boxs = [BEMCheckBox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        removeNavbarTopLine()
        self.navigationItem.title = "New Trip"
        editInit()
        check_boxs = [cus_document, cus_medicine, cus_makeup,cus_money, cus_food, cus_mobile,  cus_laptop, cus_electroinics, cus_books, cus_toys,   cus_clothes,cus_shoes]
        for one in check_boxs{
            setCheckBox(one, checked: false)
        }
        self.addLeftButton4NavBar()
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
        setEdtPlaceholder(edt_flyingfrom, placeholderText:"Flying from", placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_flyingto, placeholderText:"Flying to", placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_date, placeholderText:"Date", placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_time, placeholderText:"Time", placeColor: UIColor.lightGray, padding: .left(15))
        
        setEdtPlaceholder(edt_weight, placeholderText:"Weight", placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_price, placeholderText:"Price", placeColor: UIColor.lightGray, padding: .left(15))
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
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        
        let datePicker = ActionSheetDatePicker(title:"Select start date", datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if  Int(NSDate().timeIntervalSince1970 * 1000) > Int(datee.timeIntervalSince1970) * 1000 + Constants.ONE_HOUR_TIMESTAMP{
                    self.edt_date.text = ""
                    self.showAlerMessage(message: "Please select correct start date!")
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
        let datePicker = ActionSheetDatePicker(title:"Select start time", datePickerMode: UIDatePicker.Mode.time, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if let date_timestamp = self.date_timestamp{
                    if date_timestamp - Int(NSDate().timeIntervalSince1970) * 1000 <= Constants.ONE_DAY_TIMESTAMP - Constants.ONE_HOUR_TIMESTAMP{
                        if  Int(datee.timeIntervalSince1970) * 1000 - Int(NSDate().timeIntervalSince1970 * 1000) <= Constants.ONE_HOUR_TIMESTAMP - Constants.ONE_MIN_TIMESTAMP{
                            
                            self.edt_time.text = ""
                            self.showAlerMessage(message: "Please select correct start time. Time must be 1 hour later from now at least!")
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
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func flyingToFieldTapped(_ sender: Any) {
        selected_field = 2
        edt_flyingto.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        let from_location = edt_flyingfrom.text ?? ""
        let to_location = edt_flyingto.text ?? ""
        let weight = edt_weight.text ?? ""
        let price = edt_price.text ?? ""
        let date = edt_date.text ?? ""
        let time = edt_time.text ?? ""
        let des = txv_additionalinformation.text ?? ""
        var items = [String]()
        for i in 0 ..< check_boxs.count{
            if check_boxs[i].on{
                items.append(Constants.items[i])
            }
        }
        if from_location.isEmpty{
            self.showAlerMessage(message: "Please select flying from location.")
            return
        }
        if to_location.isEmpty{
            self.showAlerMessage(message: "Please select flying to location.")
            return
        }
        if date.isEmpty{
            self.showAlerMessage(message: "Please select start date.")
            return
        }
        if time.isEmpty{
            self.showAlerMessage(message: "Please select start time.")
            return
        }
        
        if weight.isEmpty{
            self.showAlerMessage(message: "Please input weight.")
            return
        }
        if price.isEmpty{
            self.showAlerMessage(message: "Please input price.")
            return
        }
        if items.count == 0{
            self.showAlerMessage(message: "Please selct bring items.")
            return
        }else{
            self.showLoadingView(vc: self)
            ApiManager.createTravel(travel_time: self.start_timestamp ?? Int(NSDate().timeIntervalSince1970 * 1000), weight: weight.toFloat() ?? 0.0, price: price.toInt() ?? 0, items: items.joined(separator: ","), des: des, from_location: from_location, to_location: to_location) { (isSuccess, data) in
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
    }else if selected_field == 2{
        edt_flyingto.text = place.formattedAddress
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
