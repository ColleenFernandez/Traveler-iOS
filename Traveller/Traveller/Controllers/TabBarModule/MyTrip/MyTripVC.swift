//
//  MyTripVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import UIKit

class MyTripVC: BaseVC {

    @IBOutlet weak var tbl_active: UITableView!
    @IBOutlet weak var tbl_history: UITableView!
    
    var ds_active = [TravelModel]()
    var ds_history = [TravelModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI()  {
        restoreNavbarTopLine()
        navigationItem.title = "My Trips"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDataSource()
    }
    
    func  setDataSource()  {
        self.ds_active.removeAll()
        for i in 0 ..< TestData.user_images.count{
            var items = TestData.items
            for ii in 0 ..< 6{
                let index = (i + ii) % 10
                if index < items.count{
                    items.remove(at:index )
                }
            }
            
            self.ds_active.append(TravelModel(travel_id: i, usermodel: UserModel(user_id: i, first_name: TestData.userNames[i], last_name: TestData.userNames[(i + 1) % 10], user_photo: TestData.user_images[i], user_email: TestData.userEmails[i], password: "", rating: TestData.rating[i], birthday: TestData.post_times[i] * 1000, phone_number: "123456789"), travel_time: Int64(TestData.post_times[i] * 1000), weight: Float(TestData.weight[i]), price: TestData.price[i], items: items, des: TestData.des[i], from_location: TestData.userLocation[i], to_location: TestData.userLocation[(i + 1) % 10]))
            self.ds_history = self.ds_active
        }
        self.tbl_active.reloadData()
        self.tbl_history.reloadData()
    }

    @IBAction func newTripBtnClicked(_ sender: Any) {
        self.gotoNavPresent("NewTripVC", fullscreen: true)
    }
}

extension MyTripVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tbl_active{
            return self.ds_active.count
        }else{
            return self.ds_history.count
        }
        
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
       let cell = tbl_active.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        if tableView == self.tbl_active{
            cell.setDataSource(one: self.ds_active[indexPath.section], vc:"MyTripVC")
            
            return cell
        }else{
            cell.setDataSource(one: self.ds_history[indexPath.section], vc:"MyTripVC")
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let tovc = self.createVC("TripDetailVC") as! TripDetailVC
        tovc.one = self.ds_active[indexPath.section]
        tovc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tovc, animated: true)*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 10
        }else{
            return 0
        }
    }
}
