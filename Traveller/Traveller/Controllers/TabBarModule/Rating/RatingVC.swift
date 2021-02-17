//
//  RatingVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import UIKit
import Cosmos


@available(iOS 11.0, *)
class RatingVC: BaseVC {
    
    @IBOutlet weak var tbl_review: UITableView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var cus_rating: CosmosView!
    var reviews = [ReviewModel]()
    let cellSpacingHeight: CGFloat = 10 // cell line spacing must use section instead of row
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.setTableView()
    }
    
    func setUI()  {
        self.navigationItem.title = "Rating"
        self.lbl_username.text = thisuser.first_name! + " " + thisuser.last_name!
        self.cus_rating.rating = 4.0
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
        tbl_review.delegate = self
        tbl_review.dataSource = self
        self.tbl_review.allowsSelection = true
        self.tbl_review.separatorStyle = .none
        self.tbl_review.estimatedRowHeight = 80
    }
}

@available(iOS 11.0, *)
extension RatingVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return self.reviews.count
        return 10
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
        //cell.entity = reviews[indexPath.section]
        cell.setDummy()
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
