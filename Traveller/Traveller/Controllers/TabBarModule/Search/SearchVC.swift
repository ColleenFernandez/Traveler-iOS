//
//  SearchVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import UIKit
import GooglePlaces
import ActionSheetPicker_3_0

class SearchVC: BaseVC {

    @IBOutlet weak var edt_flyingfrom: UITextField!
    @IBOutlet weak var edt_flyingto: UITextField!
    @IBOutlet weak var txv_startdate: UITextView!
    @IBOutlet weak var txv_enddate: UITextView!
    
    @IBOutlet weak var tbl_search: UITableView!
    
    var start_timestamp: Int = 0
    var end_timestamp: Int = 0
    var ds_search = [TravelModel]()
    
    var selected_field = 0 // 1: from 2: to
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource()
    }
    
    func  setDataSource()  {
        self.ds_search.removeAll()
        for i in 0 ..< TestData.user_images.count{
            var items = TestData.items
            for ii in 0 ..< 6{
                let index = (i + ii) % 10
                if index < items.count{
                    items.remove(at:index )
                }
            }
            
            self.ds_search.append(TravelModel(travel_id: i, usermodel: UserModel(user_id: i, first_name: TestData.userNames[i], last_name: TestData.userNames[(i + 1) % 10], user_photo: TestData.user_images[i], user_email: TestData.userEmails[i], password: "", rating: TestData.rating[i], birthday: TestData.post_times[i] * 1000, phone_number: "123456789"), travel_time: Int64(TestData.post_times[i] * 1000), weight: Float(TestData.weight[i]), price: TestData.price[i], items: items, des: TestData.des[i], from_location: TestData.userLocation[i], to_location: TestData.userLocation[(i + 1) % 10]))
        }
        self.tbl_search.reloadData()
    }
    
    func setUI() {
        removeNavbarTopLine()
        self.navigationItem.title = "Search for a Traveler"
        editInit()
        
    }
    
    func editInit() {
        setEdtPlaceholder(edt_flyingfrom, placeholderText:"Flying from", placeColor: UIColor.lightGray, padding: .left(15))
        setEdtPlaceholder(edt_flyingto, placeholderText:"Flying to", placeColor: UIColor.lightGray, padding: .left(15))
        txv_startdate.contentInset = .init(top: -5, left: 10, bottom: 0, right: 0)
        txv_enddate.contentInset = .init(top: -5, left: 10, bottom: 0, right: 0)
    }
    
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:"Select start date and time", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                self.txv_startdate.text = String(local_time.split(separator: " ")[0]) + "\n" + String(local_time.split(separator: " ")[1]) + " " + String(local_time.split(separator: " ")[2])
            }
            if let datee = value as? Date{
                self.start_timestamp = Int(datee.timeIntervalSince1970) * 1000
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func btnEndDateClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title:"Select end date and time", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            if let local_time = utcToLocal(dateStr: "\(value ?? "")"){
                self.txv_enddate.text = String(local_time.split(separator: " ")[0]) + "\n" + String(local_time.split(separator: " ")[1]) + " " + String(local_time.split(separator: " ")[2])
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
    @IBAction func searchBtnClicked(_ sender: Any) {
        self.showLoadingView(vc: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideLoadingView()
            for i in 0 ... 6{
                let index = Int.random(in: 0 ... 9)
                if index < self.ds_search.count{
                    self.ds_search.remove(at: index)
                }
            }
            self.tbl_search.reloadData()
        }
    }
}

extension SearchVC : GMSAutocompleteViewControllerDelegate {
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
//            let tovc = self.createVC("CommentVC") as! CommentVC
//            tovc.comment_room_id = "\(self.ds_search[indexPath.section].post_id ?? 0)"
//            let navcontroller = UINavigationController(rootViewController: tovc)
//            navcontroller.modalPresentationStyle = .fullScreen
//            self.present(navcontroller, animated: false, completion: nil)
            
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



