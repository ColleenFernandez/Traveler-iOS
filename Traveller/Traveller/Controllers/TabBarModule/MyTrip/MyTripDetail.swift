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
    @IBOutlet weak var txv_from_traveler: UITextView!
    
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
    @IBOutlet weak var lbl_icanbring: UILabel!
    @IBOutlet weak var lbl_travelnotes: UILabel!
    
    
    @IBOutlet weak var btn_updatetrip: dropShadowDarkButton!
    var check_boxs = [BEMCheckBox]()
    
    var one: TravelModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.setEdtPlaceholder(self.edt_weight, placeholderText: language.language == .eng ? "Please input weight" : RUS.PLEASE_INPUT_WEIGHT, placeColor: .lightGray, padding: .left(4))
            self.setEdtPlaceholder(self.edt_price, placeholderText: language.language == .eng ? "Please input price" : RUS.PLEASE_INPUT_PRICE, placeColor: .lightGray, padding: .left(4))
            self.edt_weight.text = "\(one.weight ?? 0.0)"
            self.edt_price.text = "\(one.price ?? 0)"
            self.cus_rating.rating = Double(one.usermodel?.rating ?? 0.0)
            
            check_boxs = [cus_document, cus_medicine, cus_makeup,cus_money, cus_food, cus_mobile,  cus_laptop, cus_electroinics, cus_books, cus_toys,   cus_clothes,cus_shoes]
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
        
        self.lbl_icanbring.text =  language.language == .eng ? "I can bring the following" : RUS.I_CAN_BRING_FOLLOWING
        self.lbl_travelnotes.text = language.language == .eng ? "Travel Notes" : RUS.TRAVEL_NOTES
        
        self.navigationItem.title = language.language == .eng ? "My Trip Details" : "Детали моей поездки"
        self.btn_updatetrip.setTitle(language.language == .eng ? "Update Trip" : "обновить поездку", for: .normal)
        self.addLeftButton4NavBar()
        self.addRightButton4NavBar()
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
    
    func addRightButton4NavBar() {
        // if needed i will add
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "delete")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(addTappedRightBtn), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItemBack
    }
    
    @objc func addTappedRightBtn() {
        // show delete confirm dialog
        
        let alert = UIAlertController(title: language.language == .eng ? "Delete travel" : "Удалить путешествие", message: language.language == .eng ? "Do you want to delete this travel?" : "Вы хотите удалить это путешествие?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: language.language == .eng ? "OK" : "OK", style: .default, handler: { action in
            if let one = self.one{
                self.showLoadingView(vc: self)
                ApiManager.deleteMyTrips(travel_id: one.travel_id) { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showToast("Network issue")
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: language.language == .eng ? "Cancel" : "отменить", style: .default, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
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
        //checkbox.isUserInteractionEnabled = false
        checkbox.on = checked
    }
    
    @IBAction func upateTripBtnClicked(_ sender: Any) {
        if let one = self.one{
            let weight = edt_weight.text ?? ""
            let price = edt_price.text ?? ""
            var des = txv_from_traveler.text ?? ""
            
            var items = [String]()
            for i in 0 ..< check_boxs.count{
                if check_boxs[i].on{
                    items.append(Constants.items[i])
                }
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
                ApiManager.updateMyTrips(travel_id: one.travel_id, weight: weight.toFloat() ?? 0.0, price: price.toInt() ?? 0, items: items.joined(separator: ","), des: des) { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

