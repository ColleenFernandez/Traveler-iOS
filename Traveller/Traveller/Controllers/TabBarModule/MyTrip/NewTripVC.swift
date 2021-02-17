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
    var start_timestamp: Int = 0
    var end_timestamp: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        removeNavbarTopLine()
        self.navigationItem.title = "New Trip"
        editInit()
        let check_boxs: [BEMCheckBox] = [cus_document, cus_medicine, cus_makeup,cus_money, cus_food, cus_mobile,  cus_laptop, cus_electroinics, cus_books, cus_toys,   cus_clothes,cus_shoes]
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
        let datePicker = ActionSheetDatePicker(title:"Select date", datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                self.edt_date.text = String(local_time.split(separator: " ")[0])
            }
            if let datee = value as? Date{
                self.start_timestamp = Int(datee.timeIntervalSince1970) * 1000
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func btnEndDateClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:"Select time", datePickerMode: UIDatePicker.Mode.time, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                self.edt_time.text = String(local_time.split(separator: " ")[1]) + " " + String(local_time.split(separator: " ")[2])
            }
            if let datee = value as? Date{
                self.end_timestamp = Int(datee.timeIntervalSince1970) * 1000
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
        self.showLoadingView(vc: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideLoadingView()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension NewTripVC : GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    if selected_field == 1{
        edt_flyingfrom.text = place.name
    }else if selected_field == 2{
        edt_flyingto.text = place.name
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
