//
//  RateUserVC.swift
//  Traveller
//
//  Created by top Dev on 01.03.2021.
//

import UIKit
import Cosmos
import SwiftyJSON

@available(iOS 11.0, *)
class RateUserVC: BaseVC {
    
    @IBOutlet weak var imv_user: UIImageView!
    @IBOutlet weak var lbl_usercontent: UILabel!
    @IBOutlet weak var tbl_review: UITableView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var cus_rating: CosmosView!
    @IBOutlet weak var cus_review: CosmosView!
    @IBOutlet weak var txv_reviewcontent: UITextView!
    @IBOutlet weak var uiv_back: UIView!
    @IBOutlet weak var uiv_modal: UIView!
    var review_id: Int?
    var reviews = [ReviewModel]()
    let cellSpacingHeight: CGFloat = 0 // cell line spacing must use section instead of row
    var rate_user: UserModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource()
        setUI()
        setTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDataSource() {
        if let user = self.rate_user{
            self.reviews.removeAll()
            self.showLoadingView(vc: self)
            ApiManager.manageReview(request_type: .get_review, owner_id: user.user_id, reviewer_id: nil, review_content: nil, review_time: nil, review_rating: nil, review_id: nil, reply: nil) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    let json = JSON(data as Any)
                    if let reviews = json["review_info"].arrayObject{
                        if reviews.count > 0{
                            var active_num = 0
                            for one in reviews{
                                active_num += 1
                                self.reviews.append(ReviewModel(JSON(one)))
                            }
                            if active_num == reviews.count{
                                if let total = self.reviews.first{
                                    self.cus_rating.rating = total.total_rating ?? 0
                                }
                                self.tbl_review.reloadData()
                            }
                        }else{
                            self.cus_rating.rating = 0.0
                            self.tbl_review.reloadData()
                        }
                    }else{
                        self.cus_rating.rating = 0.0
                        self.tbl_review.reloadData()
                    }
                }else{
                    self.showAlerMessage(message: "Network Error")
                    self.tbl_review.reloadData()
                }
            }
        }
    }
    
    func setUI()  {
        self.setReviewModal(false)
        if let user = self.rate_user{
            self.navigationItem.title = user.first_name! + " " + user.last_name!
            self.imv_user.kf.setImage(with: URL(string: user.user_photo ?? ""))
            self.lbl_username.text = user.first_name! + " " + user.last_name!
            self.lbl_usercontent.text = getAgeFromString(getStrDate("\(user.birthday ?? 0)"))
        }
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: "TabBarVC") as! UITabBarController
        toVC.selectedIndex = 3
        //toVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController = toVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    @objc func reloadTableView(){
        self.tbl_review.scrollToBottomRow()
        DispatchQueue.main.async {
              [weak self] in
            self?.tbl_review.reloadData()}
    }
    
    func setTableView() {
        self.tbl_review.allowsSelection = true
        self.tbl_review.separatorStyle = .none
        self.tbl_review.estimatedRowHeight = 80
    }
    
    func setReviewModal(_ isShow: Bool)  {
        self.uiv_modal.isHidden = !isShow
        self.uiv_back.isHidden = !isShow
        self.cus_review.rating = 0.0
        if isShow{
            self.txv_reviewcontent.delegate = self
            for one in self.reviews{
                if one.reviewer?.user_id == thisuser.user_id{
                    self.txv_reviewcontent.text = one.review_content
                    self.review_id = one.id
                    self.cus_review.rating = Double(one.review_rating ?? 0)
                    break
                }
            }
        }else{
            self.txv_reviewcontent.delegate = nil
        }
    }
    
    
    @IBAction func rateUserBtnClicked(_ sender: Any) {
        self.setReviewModal(true)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.setReviewModal(false)
    }
    
    @IBAction func reviewBtnClicked(_ sender: Any) {
        let rating = self.cus_review.rating
        let content = self.txv_reviewcontent.text ?? ""
        if rating == 0.0{
            self.showAlerMessage(message: "Please select rating star.")
            return
        }
        if content.isEmpty || content == "Write your review on user."{
            self.showAlerMessage(message: "Please write reivew.")
            return
        }else{
            if let user = rate_user{
                self.showLoadingView(vc: self)
                ApiManager.manageReview(request_type: .give_reiview, owner_id:user.user_id, reviewer_id: thisuser.user_id, review_content: content, review_time: Int(NSDate().timeIntervalSince1970 * 1000), review_rating: Float(rating), review_id: self.review_id, reply: nil) { (isSuccess, data) in
                    self.hideLoadingView()
                    self.setReviewModal(false)
                    if isSuccess{
                        self.reviews.removeAll()
                        let json = JSON(data as Any)
                        if let reviews = json["review_info"].arrayObject{
                            if reviews.count > 0{
                                var active_num = 0
                                for one in reviews{
                                    active_num += 1
                                    self.reviews.append(ReviewModel(JSON(one)))
                                }
                                if active_num == reviews.count{
                                    if let total = self.reviews.first{
                                        self.cus_rating.rating = total.total_rating ?? 0
                                    }
                                    self.tbl_review.reloadData()
                                }
                            }else{
                                self.cus_rating.rating = 0.0
                                self.tbl_review.reloadData()
                            }
                        }else{
                            self.cus_rating.rating = 0.0
                            self.tbl_review.reloadData()
                        }
                    }else{
                        self.showAlerMessage(message: "Network Error")
                        self.tbl_review.reloadData()
                    }
                }
            }
        }
    }
}

@available(iOS 11.0, *)
extension RateUserVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.reviews.count
        //return 10
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
        let cell = tbl_review.dequeueReusableCell(withIdentifier: "ReviewCell", for:indexPath) as! ReviewCell
        cell.selectionStyle = .none
        cell.entity = reviews[indexPath.section]
        //cell.setDummy()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return cellSpacingHeight
        }
    }
}

extension RateUserVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your review on user."
            textView.textColor = UIColor.lightGray
        }
    }
}
