//
//  ReviewModel&Cell.swift
//  Traveller
//
//  Created by top Dev on 16.02.2021.
//

import Foundation
import SwiftyJSON
import Cosmos
import UIKit

class ReviewModel: NSObject{
    
    var id: Int?
    var reviewer: UserModel?
    var review_content: String?
    var review_time: Int?
    var review_rating: Double?
    var reply: String?
    
    override init() {
        self.id = -1
        self.reviewer = nil
        self.review_content = nil
        self.review_time = nil
        self.review_rating = nil
        self.reply = nil
    }
    
    init(id: Int, reviewer : UserModel, review_content : String, review_time: Int, review_rating: Double, reply: String) {
        self.id = id
        self.reviewer = reviewer
        self.review_content = review_content
        self.review_time = review_time
        self.review_rating = review_rating
        self.reply = reply
    }
}

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_reviewTIme: UILabel!
    @IBOutlet weak var cus_rating: CosmosView!
    
    @IBOutlet weak var lbl_review_content: UILabel!
    @IBOutlet weak var lbl_reply: UILabel!
    @IBOutlet weak var meView: UIView!
    
    var entity: ReviewModel!{
        didSet{
//            self.lbl_userName.text = entity.reviewer?.username
//            self.lbl_reviewTIme.text = getStrShortDate("\(entity.review_time)")
//            self.cus_rating.rating = entity.review_rating ?? 0
//            self.lbl_review_content.text = entity.review_content
//            self.lbl_reply.text = entity.reply
            //roundCorners4me(cornerRadius: 8)
        }
    }
    
    func setDummy()  {
        self.lbl_userName.text = "John Doe"
        self.lbl_reviewTIme.text = "10/01/2021"
        self.cus_rating.rating = 4.0
        self.lbl_review_content.text = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cup"
        self.lbl_reply.text = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cup"
        roundCorners4me(cornerRadius: 8)
    }
    
    func roundCorners4me(cornerRadius: Double) {
        self.meView.layer.cornerRadius = CGFloat(cornerRadius)
        self.meView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.meView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}
