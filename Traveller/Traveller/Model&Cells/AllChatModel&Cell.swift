//
//  AllChatModel&Cell.swift
//  DatingKinky
//
//  Created by Ubuntu on 8/2/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
import SwiftyJSON

class AllChatModel: NSObject{
    
    var id: Int?
    var userName: String?
    var userAvatar: String?
    var msgTime: String?
    var content: String?
    var showOverlay: Bool = false
    
    override init() {
        self.id = -1
        self.userName = ""
        self.userAvatar = ""
        self.msgTime = ""
        self.content = ""
        self.showOverlay = false
    }
    
    init(id: Int, username : String, userAvatar : String, msgTime: String, content: String, showOverlay: Bool = false) {
        self.id = id
        self.userName = username
        self.userAvatar = userAvatar
        self.msgTime = getStrDateshort(msgTime)
        self.showOverlay = showOverlay
        self.content = content
    }
}

class AllChatCell: UICollectionViewCell {
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet var imv_profile: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_msgTIme: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var uiv_overlay: UIView!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_decline: UIButton!
    @IBOutlet weak var btn_spaceBtn: UIButton!
    //@IBOutlet weak var uiv_colorOverlay: UIView!
    //@IBOutlet weak var uiv_blur: UIView!
    @IBOutlet weak var uiv_blur: CustomBlurView!
    
    var entity: AllChatModel!{
        didSet{
            let url = URL(string: entity.userAvatar ?? "")
            imv_profile.kf.setImage(with: url,placeholder: UIImage.init(named: "placeholder"))
            self.lbl_userName.text = entity.userName
           
            self.lbl_msgTIme.text = entity.msgTime
            self.lbl_content.text = entity.content
            self.lbl_content.font = lbl_content.font.italic
            //totalView.addBlur()
            self.uiv_overlay.isHidden = !entity.showOverlay
            uiv_blur.visualEffectView.blurRadius = 3
        }
    }
}

