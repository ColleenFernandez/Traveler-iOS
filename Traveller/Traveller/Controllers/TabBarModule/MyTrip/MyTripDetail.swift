//
//  MyTripDetail.swift
//  Traveller
//
//  Created by top Dev on 03.03.2021.
//

import UIKit
import Cosmos
import BEMCheckBox

class MyTripDetail: BaseVC {

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
            self.lbl_servicetime.text = getWeekAndDateTimeFromTmp(Int64(one.travel_time ?? Int(NSDate().timeIntervalSince1970 * 1000)))
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
        self.navigationItem.title = "My Trip Details"
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
}

