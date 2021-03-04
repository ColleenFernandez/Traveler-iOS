//
//  TravelModel.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import Foundation
import SwiftyJSON
import Kingfisher
import Cosmos

class TravelModel: NSObject {
    var travel_id: Int!
    var usermodel: UserModel?
    var travel_time: Int?
    var weight: Float?
    var price: Int?
    var items: [String]?
    var des: String?
    var from_location: String?
    var to_location: String?
    
    override init() {
       super.init()
        travel_id = -1
        usermodel = nil
        travel_time = nil
        weight = nil
        price = nil
        items = nil
        des = nil
        from_location = nil
        to_location = nil
    }
    
    init(travel_id: Int, usermodel: UserModel, travel_time: Int, weight: Float, price: Int, items: [String], des: String, from_location: String, to_location: String){
        self.travel_id = travel_id
        self.usermodel = usermodel
        self.travel_time = travel_time
        self.weight = weight
        self.price = price
        self.items = items
        self.des = des
        self.from_location = from_location
        self.to_location = to_location
    }
    
    init(_ json: JSON){
        self.travel_id = json[PARAMS.TRAVEL_ID].intValue
        self.usermodel = UserModel(json)
        self.travel_time = json[PARAMS.TRAVEL_TIME].intValue
        self.weight = json[PARAMS.WEIGHT].floatValue
        self.price = json[PARAMS.PRICE].intValue
        let items = json[PARAMS.ITEMS].stringValue.split{ !$0.isLetter }
        self.items = [String]()
        self.items?.removeAll()
        for one in items{
            self.items?.append(String(one))
        }
        self.des = json[PARAMS.DES].stringValue
        self.from_location = json[PARAMS.FROM_LOCATION].stringValue
        self.to_location = json[PARAMS.TO_LOCATION].stringValue
    }
}

class TravelCell: UITableViewCell{
    
    @IBOutlet weak var imv_profile: UIImageView!
    @IBOutlet weak var lbl_firstname: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_weight: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var cus_rating: CosmosView!
    @IBOutlet weak var lbl_from: UILabel!
    @IBOutlet weak var lbl_to: UILabel!
    
    
    var profileAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDataSource(one: TravelModel, vc: String)  {
        if vc == "SearchVC"{
            if let photo = one.usermodel?.user_photo{
                imv_profile.kf.indicatorType = .activity
                imv_profile.kf.setImage(with: URL(string: photo), placeholder: UIImage.init(named: "logo"))
            }
            self.lbl_firstname.text = one.usermodel?.first_name
            self.cus_rating.rating = Double(one.usermodel?.rating ?? 0.0)
        }
        self.lbl_date.text = getWeekAndDateTimeFromTmp(Int64(one.travel_time ?? Int(NSDate().timeIntervalSince1970 * 1000)))
        self.lbl_weight.text = "\(one.weight ?? 0.0)"
        self.lbl_price.text = "\(one.price ?? 0)"
        
        if vc == "MyTripVC"{
            self.lbl_from.text = one.from_location
            self.lbl_to.text = one.to_location
        }
    }
    
    @IBAction func profileBtnClicked(_ sender: Any) {
        //petProfileAction?()
        profileAction?()
    }
}
