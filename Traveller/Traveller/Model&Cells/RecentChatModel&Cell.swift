////
////  RecentChatModel&Cell.swift
////  DatingKinky
////
////  Created by Ubuntu on 8/1/20.
////  Copyright © 2020 Ubuntu. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//
//class RecentChatCell: UICollectionViewCell {
//    
//    @IBOutlet var imv_profile: UIImageView!
//    @IBOutlet weak var lbl_userName: UILabel!
//    @IBOutlet weak var lbl_userdetail: UILabel!
//    @IBOutlet weak var lbl_messageNum: UILabel!
//    
//    var entity: AllChatModel!{
//        
//        didSet{
//            
//            let url = URL(string: entity.userAvatar ?? "")
//            imv_profile.kf.indicatorType = .activity
//            imv_profile.kf.setImage(with: url,placeholder: UIImage.init(named: "placeholder"))
//            self.lbl_userName.text = entity.userName
//            self.lbl_messageNum.text = entity.messageNum! + " " + "Messages"
//            self.lbl_messageNum.font = lbl_messageNum.font.italic
//            self.lbl_userdetail.text = entity.location
//        }
//    }
//}
//
