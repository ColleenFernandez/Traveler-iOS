//
//  SearchVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import UIKit
import GooglePlaces
import ActionSheetPicker_3_0
import SwiftyJSON

class SearchVC: BaseVC {

    @IBOutlet weak var edt_flyingfrom: UITextField!
    @IBOutlet weak var edt_flyingto: UITextField!
    @IBOutlet weak var edt_fromdate: UITextField!
    @IBOutlet weak var edt_todate: UITextField!
    
    @IBOutlet weak var tbl_search: UITableView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var cons_tbl_height: NSLayoutConstraint!
    
    
    var from_location: String?
    var to_location: String?
    var start_timestamp: Int?
    var end_timestamp: Int?
    var from_id: String?
    var to_id: String?
    var from_is_country:  Int = 0
    var to_is_country:  Int = 0
    var from_country: String?
    var to_country: String?
    var ds_search = [TravelModel]()
    
    var selected_field = 0 // 1: from 2: to
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource(from_location: nil, to_location: nil, from_date: nil, to_date: nil, from_id: nil, to_id: nil, from_is_country: 0,to_is_country: 0, from_country: nil , to_country: nil)
    }
    
    func setDataSource( from_location: String?, to_location: String?, from_date: Int?, to_date: Int?, from_id: String?, to_id: String?, from_is_country: Int,to_is_country: Int, from_country: String?, to_country: String?)  {
        self.ds_search.removeAll()
        self.showLoadingView(vc: self)
        ApiManager.getTravel(from_location: from_location, to_location: to_location, from_date: from_date, to_date: to_date, from_id: from_id, to_id: to_id, from_is_country:from_is_country, to_is_country: to_is_country, from_country: from_country, to_country: to_country) { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                let data = JSON(data as Any)
                if let array = data["total_travel"].arrayObject{
                    if array.count > 0{
                        var num = 0
                        for one in array{
                            num += 1
                            self.ds_search.append(TravelModel(JSON(one)))
                            if num == array.count{
                                self.cons_tbl_height.constant = CGFloat(self.ds_search.count * 100)
                                self.tbl_search.reloadData()
                                self.from_location = nil
                                self.to_location = nil
                                self.from_id = nil
                                self.to_id = nil
                                self.from_is_country = 0
                                self.to_is_country = 0
                                self.from_country = nil
                                self.to_country = nil
                                self.edt_flyingto.text = nil
                                self.edt_flyingfrom.text = nil
                            }
                        }
                    }else{
                        self.tbl_search.reloadData()
                        self.from_location = nil
                        self.to_location = nil
                        self.from_id = nil
                        self.to_id = nil
                        self.from_is_country = 0
                        self.to_is_country = 0
                        self.edt_flyingto.text = nil
                        self.edt_flyingfrom.text = nil
                    }
                }
            }
        }
    }
    
    func setUI() {
        removeNavbarTopLine()
        if language.language == .eng{
            self.navigationItem.title = "Search for a Traveler"
        }else{
            self.navigationItem.title = RUS.SEARCH_FOR_TRAVELLER
        }
        editInit()
        self.btn_search.setTitle(language.language == .eng ? "Search" : RUS.SEARCH, for: .normal)
    }
    
    func editInit() {
        setEdtPlaceholder(edt_flyingfrom, placeholderText: language.language == .eng ? "Flying from" : RUS.FLYING_FROM, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_flyingto, placeholderText:language.language == .eng ? "Flying to" : RUS.FLYING_TO, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_fromdate, placeholderText:language.language == .eng ? "Start date" : RUS.START_DATE, placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_todate, placeholderText:language.language == .eng ? "End date" : RUS.END_DATE, placeColor: UIColor.lightGray, padding: .left(15))
    }
    
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:"Select start date and time", datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            
            if let datee = value as? Date{
                if  Int(NSDate().timeIntervalSince1970 * 1000) > Int(datee.timeIntervalSince1970) * 1000 + Constants.ONE_HOUR_TIMESTAMP{
                    self.start_timestamp = nil
                    self.edt_fromdate.text = ""
                    self.showAlerMessage(message: "Please select correct start date!")
                    return
                }else{
                    self.start_timestamp = Int(datee.timeIntervalSince1970) * 1000
                    if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                        self.edt_fromdate.text = String(local_time.split(separator: " ")[0])
                    }
                }
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func btnEndDateClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:"Select end date and time", datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            if let datee = value as? Date{
                if  Int(NSDate().timeIntervalSince1970 * 1000) > Int(datee.timeIntervalSince1970) * 1000 + Constants.ONE_HOUR_TIMESTAMP || Int(datee.timeIntervalSince1970) * 1000 <= self.start_timestamp ?? Int(NSDate().timeIntervalSince1970) * 1000 + Constants.ONE_HOUR_TIMESTAMP{
                    self.start_timestamp = nil
                    self.edt_todate.text = ""
                    self.showAlerMessage(message: "Please select correct end date!")
                    return
                }else{
                    self.end_timestamp = Int(datee.timeIntervalSince1970) * 1000
                    if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                        self.edt_todate.text = String(local_time.split(separator: " ")[0])
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
        /*let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.city
        acController.autocompleteFilter = filter*/
        
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func flyingToFieldTapped(_ sender: Any) {
        selected_field = 2
        edt_flyingto.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        /*let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.city
        acController.autocompleteFilter = filter*/
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        self.from_location = self.edt_flyingfrom.text
        self.to_location = self.edt_flyingto.text
        setDataSource(from_location: self.from_location, to_location: self.to_location, from_date: self.start_timestamp, to_date: self.end_timestamp, from_id: self.from_id, to_id: self.to_id, from_is_country: self.from_is_country, to_is_country: self.to_is_country, from_country: self.from_country, to_country: self.to_country)
    }
    @IBAction func refreshBtnClicked(_ sender: Any) {
        self.edt_flyingfrom.text = nil
        self.edt_flyingto.text = nil
        self.edt_fromdate.text = nil
        self.edt_todate.text = nil
        self.from_location = nil
        self.to_location = nil
        self.start_timestamp = nil
        self.end_timestamp = nil
        setDataSource(from_location: nil, to_location: nil, from_date: nil, to_date: nil, from_id: nil, to_id: nil, from_is_country: 0,to_is_country: 0, from_country: nil, to_country: nil)
    }
}

extension SearchVC : GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    if selected_field == 1{
        edt_flyingfrom.text = place.formattedAddress
        self.from_id = place.placeID
        if place.addressComponents?.first?.types.first == "country"{
            self.from_is_country = 1
            if let addressComponents = place.addressComponents{
                for one in addressComponents{
                    for two in one.types{
                        if two == "country"{
                            print(one.shortName ?? "")
                            self.from_country = one.shortName
                            break
                        }
                    }
                }
            }
        }else{
            self.from_is_country = 0
        }
        //print(place.attributions)
    }else if selected_field == 2{
        edt_flyingto.text = place.formattedAddress
        self.to_id = place.placeID
        if place.addressComponents?.first?.types.first == "country"{
            self.to_is_country = 1
            if let addressComponents = place.addressComponents{
                for one in addressComponents{
                    for two in one.types{
                        if two == "country"{
                            print(one.shortName ?? "")
                            self.to_country = one.shortName
                            break
                        }
                    }
                }
            }
        }else{
            self.to_is_country = 0
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

extension SearchVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ds_search.count
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tbl_search.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        cell.setDataSource(one: self.ds_search[indexPath.section], vc:"SearchVC")
        cell.profileAction = {() in
            let tovc = self.createVC("RateUserVC") as! RateUserVC
            tovc.rate_user = self.ds_search[indexPath.section].usermodel
            tovc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(tovc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tovc = self.createVC("TripDetailVC") as! TripDetailVC
        tovc.one = self.ds_search[indexPath.section]
        tovc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tovc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 10
        }else{
            return 0
        }
    }
}



