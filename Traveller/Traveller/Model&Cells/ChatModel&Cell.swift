//
//  ChatModel.swift
//  DatingKinky
//
//  Created by top Dev on 8/10/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//


import Foundation
import SwiftyUserDefaults
import Kingfisher
//import SwiftyGif

class ChatModel {
    
    var me : Bool
    var timestamp : String
    var msgContent : String
    var image : String
    var photo : String
    var name : String
    var sender_id : String
    
    init(me : Bool,timestamp : String, msgContent : String, image: String, photo : String, name: String , sender_id : String) {
        
        self.timestamp = timestamp
        self.msgContent = msgContent
        self.me = me
        self.image = image
        self.photo = photo
        self.name = name
        self.sender_id = sender_id
    }
    
    init() {
        self.timestamp = ""
        self.msgContent = ""
        self.me = true
        self.image = ""
        self.photo = ""
        self.name = ""
        self.sender_id = ""
    }
}


class ChatCell: UITableViewCell {
    
    @IBOutlet weak var meView: UIView!
    @IBOutlet weak var melblContent: UILabel!
    @IBOutlet weak var melblTime: UILabel!
    //@IBOutlet weak var mecorner: UIImageView!
    @IBOutlet weak var youView: UIView!
    @IBOutlet weak var youlblContent: UILabel!
    @IBOutlet weak var youlblTime: UILabel!
    //@IBOutlet weak var youreadStatue: UIImageView!
    //@IBOutlet weak var yourcorner: UIImageView!
    @IBOutlet weak var cons_meWidth: NSLayoutConstraint!
    @IBOutlet weak var cons_youWidth: NSLayoutConstraint!
    @IBOutlet weak var imv_partner: UIImageView!
    @IBOutlet weak var lbl_readReceipt: UILabel!
    
    var entity : ChatModel!{
        didSet {
            melblContent.text = entity.msgContent
            let time = getStrDateshort(entity.timestamp)
            melblTime.text = time
            melblTime.font = melblTime.font.italic
            youlblContent.text = entity.msgContent
            youlblTime.text = time
            youlblTime.font = youlblTime.font.italic
            
            roundCorners4me(cornerRadius: 8)
            roundCorners4you(cornerRadius: 8)
            let url = URL(string: entity.photo)
            imv_partner.kf.setImage(with: url,placeholder: UIImage.init(named: "placeholder"))
        }
    }
    
    func roundCorners4me(cornerRadius: Double) {
        self.meView.layer.cornerRadius = CGFloat(cornerRadius)
        self.meView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.meView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundCorners4you(cornerRadius: Double) {
        self.youView.layer.cornerRadius = CGFloat(cornerRadius)
        self.youView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.youView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

/**class chatGifCell: UITableViewCell {
    
    @IBOutlet weak var uiv_me: UIView!
    @IBOutlet weak var imv_meImage: UIImageView!
    @IBOutlet weak var lbl_metime: UILabel!
    @IBOutlet weak var uiv_you: UIView!
    @IBOutlet weak var imv_youImage: UIImageView!
    @IBOutlet weak var lbl_youtime: UILabel!
    @IBOutlet weak var btn_me: UIButton!
    @IBOutlet weak var btn_you: UIButton!
    @IBOutlet weak var imv_partner: UIImageView!
    @IBOutlet weak var lbl_readReceipt: UILabel!
    
    var entity : ChatModel!{
        didSet {
            let url = URL(string: entity.image)
            if let url = url{
                var loader1 = UIActivityIndicatorView()
                var loader2 = UIActivityIndicatorView()
                if #available(iOS 13.0, *) {
                     loader1 = UIActivityIndicatorView.init(style: .medium)
                } else {
                    
                }
                self.imv_meImage.setGifFromURL(url, customLoader: loader1)
                if #available(iOS 13.0, *) {
                     loader2 = UIActivityIndicatorView.init(style: .medium)
                } else {
                    // Fallback on earlier versions
                }
                self.imv_youImage.setGifFromURL(url, customLoader: loader2)
            }
            
            let time = getStrDateshort(entity.timestamp)
            lbl_metime.text = time
            lbl_youtime.text = time
            lbl_youtime.font = lbl_youtime.font.italic
            lbl_metime.font = lbl_metime.font.italic
            roundCorners4me(cornerRadius: 8)
            roundCorners4you(cornerRadius: 8)
            let readTime = getStrDateshort(entity.read_time)
            if readTime != ""{
                lbl_readReceipt.text = " " + "•Read" + " " + readTime
                lbl_readReceipt.font = lbl_readReceipt.font.italic
            }else{
                lbl_readReceipt.text = " "
            }
            let url1 = URL(string: entity.photo)
            imv_partner.kf.setImage(with: url1,placeholder: UIImage.init(named: "placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imv_meImage.clear()
        self.imv_youImage.clear()
    }
    
    func roundCorners4me(cornerRadius: Double) {
        self.imv_meImage.layer.cornerRadius = CGFloat(cornerRadius)
        self.imv_meImage.clipsToBounds = true
        /* layerMaxXMaxYCorner – bottom right corner
        layerMaxXMinYCorner – top right corner
        layerMinXMaxYCorner – bottom left corner
        layerMinXMinYCorner – top left corner*/
        if #available(iOS 11.0, *) {
            self.imv_meImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundCorners4you(cornerRadius: Double) {
        self.imv_youImage.layer.cornerRadius = CGFloat(cornerRadius)
        self.imv_youImage.clipsToBounds = true
        /* layerMaxXMaxYCorner – bottom right corner
        layerMaxXMinYCorner – top right corner
        layerMinXMaxYCorner – bottom left corner
        layerMinXMinYCorner – top left corner*/
        if #available(iOS 11.0, *) {
            self.imv_youImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}*/

class chatImageCell: UITableViewCell {
    
    @IBOutlet weak var uiv_me: UIView!
    @IBOutlet weak var imv_meImage: UIImageView!
    @IBOutlet weak var lbl_metime: UILabel!
    @IBOutlet weak var uiv_you: UIView!
    @IBOutlet weak var imv_youImage: UIImageView!
    @IBOutlet weak var lbl_youtime: UILabel!
    @IBOutlet weak var btn_me: UIButton!
    @IBOutlet weak var btn_you: UIButton!
    @IBOutlet weak var imv_partner: UIImageView!
    @IBOutlet weak var lbl_readReceipt: UILabel!
    
    var entity : ChatModel!{
        didSet {
            let urlString : NSString = entity.image as NSString
            let urlStr : NSString = urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            let searchURL : URL = URL(string: urlStr as String)!
            
            //let url = URL(string: entity.image)
            
            self.imv_meImage.kf.indicatorType = .activity
            self.imv_youImage.kf.indicatorType = .activity
            self.imv_meImage.kf.setImage(with: searchURL,placeholder: nil)
            self.imv_youImage.kf.setImage(with: searchURL,placeholder: nil)
            let time = getStrDateshort(entity.timestamp)
            lbl_metime.text = time
            lbl_youtime.text = time
            lbl_metime.font = lbl_metime.font.italic
            lbl_youtime.font = lbl_youtime.font.italic
            roundCorners4me(cornerRadius: 8)
            roundCorners4you(cornerRadius: 8)
            
            let url = URL(string: entity.photo)
            imv_partner.kf.setImage(with: url,placeholder: UIImage.init(named: "placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func roundCorners4me(cornerRadius: Double) {
        self.imv_meImage.layer.cornerRadius = CGFloat(cornerRadius)
        self.imv_meImage.clipsToBounds = true
        /* layerMaxXMaxYCorner – bottom right corner
        layerMaxXMinYCorner – top right corner
        layerMinXMaxYCorner – bottom left corner
        layerMinXMinYCorner – top left corner*/
        if #available(iOS 11.0, *) {
            self.imv_meImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundCorners4you(cornerRadius: Double) {
        self.imv_youImage.layer.cornerRadius = CGFloat(cornerRadius)
        self.imv_youImage.clipsToBounds = true
        /* layerMaxXMaxYCorner – bottom right corner
        layerMaxXMinYCorner – top right corner
        layerMinXMaxYCorner – bottom left corner
        layerMinXMinYCorner – top left corner*/
        if #available(iOS 11.0, *) {
            self.imv_youImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}

