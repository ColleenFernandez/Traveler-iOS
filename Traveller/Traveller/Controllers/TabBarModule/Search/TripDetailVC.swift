//
//  TripDetailVC.swift
//  Traveller
//
//  Created by top Dev on 12.02.2021.
//

import UIKit
import Cosmos
import BEMCheckBox

class TripDetailVC: BaseVC {

    @IBOutlet weak var imv_profile: UIImageView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var cus_rating: CosmosView!
    @IBOutlet weak var lbl_from: UILabel!
    @IBOutlet weak var lbl_to: UILabel!
    @IBOutlet weak var lbl_servicetime: UILabel!
    @IBOutlet weak var lbl_weight: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
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
    @IBOutlet weak var txv_from_traveler: UITextView!
    @IBOutlet weak var txv_send_traveler: UITextView!
    
    var one: TravelModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        removeNavbarTopLine()
        if let one = self.one{
            if let photo = one.usermodel?.user_photo{
                imv_profile.kf.indicatorType = .activity
                imv_profile.kf.setImage(with: URL(string: photo), placeholder: UIImage.init(named: "logo"))
            }
            self.lbl_username.text = one.usermodel?.first_name
            self.lbl_servicetime.text = getWeekAndDateTimeFromTmp(one.travel_time ?? Int64(NSDate().timeIntervalSince1970 * 1000))
            self.lbl_weight.text = "\(one.weight ?? 0.0)"
            self.lbl_price.text = "\(one.price ?? 0)"
            self.cus_rating.rating = Double(one.usermodel?.rating ?? 0.0)
            
            let check_boxs: [BEMCheckBox] = [cus_document, cus_medicine, cus_makeup,cus_money, cus_food, cus_mobile,  cus_laptop, cus_electroinics, cus_books, cus_toys,   cus_clothes,cus_shoes]
            for one in check_boxs{
                setCheckBox(one, checked: false)
            }
            
            if let itmes = one.items{
                for two in itmes{
                    let result = self.getCheckedStatus(two)
                    if result.0{
                        check_boxs[result.1].on = true
                    }
                }
            }
            self.txv_from_traveler.text = one.des
            self.lbl_from.text = "From:" + " " + one.from_location!
            self.lbl_to.text = "To:" + " " + one.to_location!
        }
        self.navigationItem.title = "Trip Details"
        self.addLeftButton4NavBar()
        self.txv_send_traveler.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
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
    
    
    func getCheckedStatus( _ item: String) -> (Bool, Int) {
        for i in 0 ..< Constants.items.count{
            if item == Constants.items[i]{
                return (true, i)
            }
        }
        return (false, -1)
    }
    
    func setCheckBox(_ checkbox: BEMCheckBox, checked: Bool)  {
        checkbox.lineWidth = 1.0
        checkbox.onCheckColor = .black
        checkbox.onFillColor = .white
        checkbox.boxType = .square
        checkbox.onAnimationType = .oneStroke
        checkbox.offAnimationType = .bounce
        checkbox.isUserInteractionEnabled = false
        checkbox.on = checked
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        let msg = self.txv_send_traveler.text
        if msg!.isEmpty{
            self.showToast("Please input send text")
            return
        }else{
            if let one = self.one{
                self.showLoadingView(vc: self)
                
                let me_id: String = "\(thisuser.user_id ?? 0)"
                let partner_id: String = "\(one.usermodel!.user_id ?? 0)"
                let chatroom_id = thisuser.user_id > one.usermodel!.user_id ? partner_id + "_" +  me_id : me_id + "_" +  partner_id
                let timeNow = Int(NSDate().timeIntervalSince1970) * 1000
                var chatObject = [String: String]()
                // MARK: for message object for partner - chatObject
                chatObject["message"]     = msg
                chatObject["photo"]       = thisuser.user_photo
                chatObject["sender_id"]   = "\(thisuser.user_id ?? 0)"
                chatObject["time"]        = "\(timeNow)" as String
                chatObject["name"]        = thisuser.first_name! + " " +  thisuser.last_name!
                chatObject["image"]       = ""
                FirebaseAPI.sendMessage(chatObject, chatroom_id) { (status, message) in
                    if status {
                        var listObject = [String: String]()
                        listObject["id"]   = partner_id
                        // MARK: for list view for my list object - - listobject
                        listObject["message"]     = msg
                        listObject["sender_name"]    = one.usermodel!.first_name! + " " +  one.usermodel!.last_name!
                        listObject["sender_photo"]  = one.usermodel!.user_photo
                        listObject["time"]           = "\(timeNow)" as String
                        
                        
                        FirebaseAPI.sendListUpdate(listObject, "u" + me_id, partnerid: "u" + partner_id){
                            (status,message) in
                            if status{
                                var listObject1 = [String: String]()
                                // MARK:  for list view for partner's list object - listobject1
                                listObject1["id"]              = me_id
                                listObject1["message"]          = msg
                                listObject1["sender_name"]     = thisuser.first_name! + " " + thisuser.last_name!
                                listObject1["sender_photo"]    = thisuser.user_photo
                                listObject1["time"]            = "\(timeNow)" as String
                               
                                /**if !online{
                                    FirebaseAPI.sendListUpdate(listObject1, "u" + partner_id, partnerid: "u" + me_id){
                                        (status,message) in
                                        if status{
                                            ApiManager.sendPushNoti(receiver_id: partner_id.toInt()!, message: listObject1["message"]!)
                                            self.isdosending = false
                                            if msgtype == .image{
                                                self.uiv_postView.isHidden = true
                                                self.imageFils.removeAll()
                                                self.imv_Post.image = nil
                                            }
                                        }
                                    }
                                }else{
                                    FirebaseAPI.sendListUpdate(listObject1, "u" + partner_id, partnerid: "u" + me_id){
                                        (status,message) in
                                        if status{
                                            self.isdosending = false
                                            if msgtype == .image{
                                                self.uiv_postView.isHidden = true
                                                self.imageFils.removeAll()
                                                self.imv_Post.image = nil
                                            }
                                        }
                                    }
                                }*/
                                FirebaseAPI.sendListUpdate(listObject1, "u" + partner_id, partnerid: "u" + me_id){
                                    (status,message) in
                                    if status{
                                        //add action after completion
                                        self.hideLoadingView()
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
