//
//  RatingVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import UIKit
import Cosmos
import SwiftyJSON

@available(iOS 11.0, *)
class RatingVC: BaseVC {
    
    @IBOutlet weak var tbl_review: UITableView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var cus_rating: CosmosView!
    @IBOutlet weak var uiv_back: UIView!
    @IBOutlet weak var uiv_modal: UIView!
    @IBOutlet weak var lbl_reply_username: UILabel!
    @IBOutlet weak var cus_reply_rating: CosmosView!
    @IBOutlet weak var lbl_reply_time: UILabel!
    @IBOutlet weak var lbl_reviewer_content: UILabel!
    @IBOutlet weak var txv_replycontent: UITextView!
    var selected_review: ReviewModel?
    
    var reviews = [ReviewModel]()
    let cellSpacingHeight: CGFloat = 0 // cell line spacing must use section instead of row
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if thisuser.isValid{
            setDataSource()
            setTableView()
            setUI()
        }else{
            self.setReplyModal(false, review: nil)
            self.navigationItem.title = "Rating"
            self.lbl_username.text = nil
            self.cus_rating.isHidden = true
            self.tbl_review.isHidden = true
            showLoginAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDataSource() {
        self.reviews.removeAll()
        self.showLoadingView(vc: self)
        ApiManager.manageReview(request_type: .get_review, owner_id: thisuser.user_id, reviewer_id: nil, review_content: nil, review_time: nil, review_rating: nil, review_id: nil, reply: nil) { (isSuccess, data) in
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
                                thisuser.rating = Float(total.total_rating ?? 0)
                                thisuser.loadUserInfo()
                                thisuser.saveUserInfo()
                            }
                            self.tbl_review.reloadData()
                        }
                    }else{
                        self.cus_rating.rating = 0.0
                        thisuser.rating = 0.0
                        thisuser.loadUserInfo()
                        thisuser.saveUserInfo()
                        self.tbl_review.reloadData()
                    }
                }else{
                    self.cus_rating.rating = 0.0
                    thisuser.rating = 0.0
                    thisuser.loadUserInfo()
                    thisuser.saveUserInfo()
                    self.tbl_review.reloadData()
                }
            }else{
                self.showAlerMessage(message: "Network Error")
                self.tbl_review.reloadData()
            }
        }
    }
    
    func setUI()  {
        self.navigationItem.title = "Rating"
        self.lbl_username.text = thisuser.first_name! + " " + thisuser.last_name!
        self.setReplyModal(false, review: nil)
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
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.setReplyModal(false, review: nil)
    }
    
    func setReplyModal(_ isShow: Bool, review: ReviewModel?)  {
        self.uiv_modal.isHidden = !isShow
        self.uiv_back.isHidden = !isShow
        
        if isShow{
            if let review = review{
                self.cus_reply_rating.rating = Double(review.review_rating ?? 0.0)
                self.lbl_reply_time.text = getStrShortDate("\(review.review_time ?? Int(NSDate().timeIntervalSince1970 * 1000))")
                if let firstname = review.reviewer?.first_name, let lastname = review.reviewer?.last_name{
                    self.lbl_reply_username.text = firstname + lastname
                }
                self.lbl_reviewer_content.text = review.review_content
                self.txv_replycontent.text = review.reply
                self.txv_replycontent.delegate = self
            }
        }else{
            self.cus_reply_rating.rating = 0.0
            self.lbl_reply_time.text = ""
            self.lbl_reply_username.text = ""
            self.lbl_reviewer_content.text = ""
            self.txv_replycontent.text = ""
            self.txv_replycontent.delegate = nil
        }
    }
    
    @IBAction func replyBtnClicked(_ sender: Any) {
        let reply = self.txv_replycontent.text ?? ""
        if reply.isEmpty || reply == "Write your reply on reviewer."{
            self.showAlerMessage(message: "Please write your reply.")
            return
        }else{
            if let selected_review = self.selected_review{
                self.showLoadingView(vc: self)
                ApiManager.manageReview(request_type: .reply_review, owner_id: thisuser.user_id, reviewer_id: nil, review_content: nil, review_time: nil, review_rating: nil, review_id: selected_review.id, reply: reply) { (isSuccess, data) in
                    self.hideLoadingView()
                    self.setReplyModal(false, review: nil)
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
extension RatingVC: UITableViewDataSource, UITableViewDelegate{
    
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
        if reviews.count > indexPath.section{
            cell.entity = reviews[indexPath.section]
        }
        //cell.setDummy()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_review = reviews[indexPath.section]
        self.setReplyModal(true, review: reviews[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return cellSpacingHeight
        }
    }
}

extension RatingVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your reply on reviewer."
            textView.textColor = UIColor.lightGray
        }
    }
}
