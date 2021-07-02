//
//  MessageSendVC.swift
//  DatingKinky
//
//  Created by top Dev on 8/9/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import Firebase
import Foundation
import FirebaseStorage
import FirebaseDatabase
import Photos
import Kingfisher
import MBProgressHUD
import IQKeyboardManagerSwift
import Alamofire

@available(iOS 11.0, *)
class MessageSendVC: UIViewController {
    
    @IBOutlet weak var edt_msgSend: UITextView!
    @IBOutlet weak var tbl_Chat: UITableView!
    @IBOutlet weak var uiv_postView: UIView!
    @IBOutlet weak var imv_Post: UIImageView!
    @IBOutlet weak var uiv_msgSend: UIView!
    //@IBOutlet weak var cons_edtMessageSend: NSLayoutConstraint!
    @IBOutlet weak var uiv_dlg: UIView!
    // from other controller
    var partner_model: UserModel!
    
    let cellSpacingHeight: CGFloat = 10 // cell line spacing must use section instead of row
    var messageSendHandle: UInt?
    var newStatusHandle: UInt?
    var changeHandle: UInt?
    var msgdataSource =  [ChatModel]()
    var statuesList =  [StatusModel]()
    
    let ref = Database.database().reference()
    let pathList = Database.database().reference().child("list")
    let pathStatus = Database.database().reference().child("status")
    let requestPath = Database.database().reference().child("request")
    let reset_path4content = Database.database().reference().child("message")
    
    var partnerOnline = false
    var messageNum: Int = 0
    var isBlock: String = "false"
    var downloadURL: URL?
    var gifURL: String?
    var imageFils = [String]()
    var isattachedViewShow = false
    var isemojiViewShow = false
    var isdosending = false
    
    var imagePicker: ImagePicker1!
    
    var hud: MBProgressHUD?
    var iskeyboardshow: Bool = false
    var keyboardSize: CGFloat!
    //var issendingKeyboard: Bool = false
    
    var str_lastseen_4gift: String?
    
    var navigation: UINavigationController!
    // firebase room id and parameter
    var chatroom_id = ""
    var mestatusroomID = ""
    var partnerstatusroomID = ""
    var meListroomId = ""
    var partnerListroomId = ""
    // set flag for current chatting
    var is_current_block = false
    var animator = CPImageViewerAnimator()
    
    // edit part
    var edt_index: Int = 0
    var is_edit = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setParams()
    }
    
    func setParams()  {
        self.msgdataSource.removeAll()
        self.tbl_Chat.reloadData()
        
        let user_id: String = "\(thisuser.user_id ?? 0)"
        let partner_id: String = "\(partner_model.user_id ?? 0)"
        mestatusroomID = partner_id + "_" + user_id
        partnerstatusroomID = user_id + "_" + partner_id
        meListroomId = "u" + user_id
        partnerListroomId = "u" + partner_id
        chatroom_id = thisuser.user_id > self.partner_model.user_id ? partner_id + "_" +  user_id : user_id + "_" +  partner_id
        self.setOnlinestatus4me()
        self.fireBaseNewChatListner(chatroom_id)
        
        IQKeyboardManager.shared.enable = false
        self.iskeyboardshow = false
        self.is_current_block = false
        self.navigationItem.title = self.partner_model.first_name! + " " +  self.partner_model.last_name!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setTableView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let messageSendHandle = messageSendHandle{
            FirebaseAPI.removeChattingRoomObserver(chatroom_id, messageSendHandle)
        }
        if let changeHandle = changeHandle{
            FirebaseAPI.removeChangeRoomObserver(chatroom_id, changeHandle)
        }
        self.setOfflinestatus4me()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uiv_dlg.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    override func viewDidLayoutSubviews() {// other screen came back here screen again.
        IQKeyboardManager.shared.enable = false
    }
    
    @objc func tapTopView(gesture: UITapGestureRecognizer) -> Void {
       
    }
    
    func setupUI() {
        self.edt_msgSend.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = COLORS.PRIMARY
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        edt_msgSend.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 36)
        self.imagePicker = ImagePicker1(presentationController: self, delegate: self, is_cropping: true)
       
        let downSwipeAction = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        /*let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))*/
        downSwipeAction.direction = .down
        self.uiv_dlg.addGestureRecognizer(downSwipeAction)
        self.addObservers()
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
        
        if let messageSendHandle = messageSendHandle{
            FirebaseAPI.removeChattingRoomObserver(chatroom_id, messageSendHandle)
        }
        if let changeHandle = changeHandle{
            FirebaseAPI.removeChangeRoomObserver(chatroom_id, changeHandle)
        }
        self.setOfflinestatus4me()
        
        self.removeNode4me4finish()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: "TabBarVC") as! UITabBarController
        toVC.selectedIndex = 2
        //toVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController = toVC
    }
    
    func addObservers()  {
        // setting notification for keyboard hidding action
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Keyboard will show and hide notification action
    @objc func keyboardWillShow(notification: NSNotification) {
        if !self.iskeyboardshow{
            self.iskeyboardshow = true
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= (keyboardSize.height - view.safeAreaBottom)
                self.keyboardSize = keyboardSize.height - view.safeAreaBottom
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.iskeyboardshow{
            self.view.frame.origin.y += self.keyboardSize
            self.iskeyboardshow = false
        }
    }
    
    @objc func handleSwipeDown(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            self.uiv_postView.isHidden = true
            self.imageFils.removeAll()
            self.imv_Post.image = nil
        }
    }
    
    @objc func reloadTableView(){
        self.tbl_Chat.scrollToBottomRow()
        DispatchQueue.main.async {
              [weak self] in
            self?.tbl_Chat.reloadData()}
    }
    
    func setStatusAccept4partner(_ state: String, partnerId: String, completion: @escaping (_ success: Bool) -> ()) {
        requestPath.child("u" + partnerId).child("u" + "\(thisuser.user_id ?? 0)").child("state").setValue(state)
        completion(true)
    }
    
    func setTableView() {
        tbl_Chat.delegate = self
        tbl_Chat.dataSource = self
        self.tbl_Chat.allowsSelection = true
        self.tbl_Chat.separatorStyle = .none
        self.tbl_Chat.estimatedRowHeight = 80
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
        tbl_Chat.addGestureRecognizer(longPress)
        
    }
    
    /*func setUnreadMessageNum4me(){
        let usersRef = self.pathList.child(self.meListroomId).child(self.partnerListroomId)
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("messageNum"){
               self.pathList.child(self.meListroomId).child(self.partnerListroomId).child("messageNum").setValue("0")
            }else{
                print("false")
            }
        })
    }*/
    
    @objc func longpress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tbl_Chat)
            if let indexPath = tbl_Chat.indexPathForRow(at: touchPoint) {
                // TODO: here set new edit and delete message from list
                if self.msgdataSource[indexPath.section].me{
                    let actionSheet = UIAlertController(title: language.language == .eng ? "Message Operation" : "сообщение операция", message: nil, preferredStyle: .actionSheet)
                    if self.msgdataSource[indexPath.section].image == ""{
                        actionSheet.addAction(UIAlertAction(title: language.language == .eng ? "Edit" : "редактировать" , style: .default, handler: { (action) -> Void in
                            // edit action
                            self.edt_msgSend.text = self.msgdataSource[indexPath.section].msgContent
                            self.is_edit = true
                            self.edt_index = indexPath.section
                        }))
                    }
                    actionSheet.addAction(UIAlertAction(title:language.language == .eng ? "Remove" : "Удалить" , style: .default, handler: { (action) -> Void in
                        Database.database().reference().child("message").child(self.chatroom_id).child(self.msgdataSource[indexPath.section].msg_id).removeValue()
                        self.msgdataSource.remove(at: indexPath.section)
                        self.tbl_Chat.reloadData()
                    }))
                    actionSheet.addAction(UIAlertAction(title: language.language == .eng ? "Cancel" : "отменить" , style: .cancel, handler: nil))
                    self.present(actionSheet, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setOnlinestatus4me()  {
        pathStatus.child(mestatusroomID).removeValue()
        var statusObject = [String: String]()
        statusObject["online"] = "online"
        statusObject["sender_id"] = "\(thisuser.user_id ?? 0)"
        statusObject["time"] = "\(Int(NSDate().timeIntervalSince1970) * 1000)"
        pathStatus.child(mestatusroomID).childByAutoId().setValue(statusObject)
    }
    
    func getPartnerOnlineStatus(completion :  @escaping (_ success: Bool, _ onineval: Bool) -> ()){
        let usersRef = pathStatus.child(partnerstatusroomID)
        let queryRef = usersRef.queryOrdered(byChild: "sender_id")
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                for snap in snapshot.children {
                    let userSnap = snap as! DataSnapshot
                    //let uid = userSnap.key //the uid of each user
                    let userDict = userSnap.value as! [String:AnyObject]
                    let online = userDict["online"] as! String
                    if online != ""{
                        let status = online == "online" ? true : false
                        completion(true, status)
                    }else{
                        completion(true, false)
                    }
                }
            }else{
                completion(true, false)
            }
        })
    }
    
    /*func getPartnerTotalMessageAndBlockState(completion :  @escaping (_ success: Bool, _ number: String, _ isBlock: String) -> ()){
            let usersRef = pathList.child(partnerListroomId).child(meListroomId)
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("messageNum") && snapshot.hasChild("isBlock"){
             if let userDict = snapshot.value as? [String:AnyObject]{
                if let number = userDict["messageNum"] as? String, let isBlock = userDict["isBlock"] as? String{
                    completion(true,number, isBlock)
                }
             }else{
                 completion(true,"0", "false")
             }
            }else{
                completion(true,"0", "false")
            }
        })
    }*/
    
    func fireBaseNewChatListner(_ roomId : String)  {
        self.messageSendHandle = FirebaseAPI.setMessageListener(roomId){ [self] (chatModel) in
            self.msgdataSource.append(chatModel)
            self.tbl_Chat.reloadData()
            self.tbl_Chat.scrollToBottomRow()
        }
    }
    
    func setOfflinestatus4me()  {
        pathStatus.child(mestatusroomID).removeValue()
        var statusObject = [String: String]()
        statusObject["online"] = "offline"
        statusObject["sender_id"] = "\(thisuser.user_id ?? 0)"
        statusObject["time"] = "\(Int(NSDate().timeIntervalSince1970) * 1000)"
        pathStatus.child(mestatusroomID).childByAutoId().setValue(statusObject)
    }
    
    func openGallery() {
        self.imagePicker.present(from: view)
    }
    
    func gotoUploadProfile(_ image: UIImage?) {
        self.imageFils.removeAll()
        if let image = image{
            self.uiv_postView.isHidden = false
            imageFils.append(saveToFile(image:image,filePath:"photo",fileName:randomString(length: 2))) // Image save action
            self.imv_Post.image = image
            
            self.uploadFile2Firebase(imageFils.first!) { (isSuccess, downloadURL) in
                if isSuccess{
                    guard  let downloadURL = downloadURL else {
                        return
                    }
                    self.downloadURL = downloadURL
                }
            }
        }
    }
    
    func setNewUnreadMessage4partner(number: Int, completion: @escaping (_ success: Bool) -> ()) {
        pathList.child(partnerListroomId).child(meListroomId).child("messageNum").setValue("\(number)")
        completion(true)
    }
    
    func checkValid() -> Bool {
        self.view.endEditing(true)
        if edt_msgSend.text!.isEmpty {
            return false
        }
        return true
    }
    
    
    
    func uploadFile2Firebase(_ localFile: String, completion: @escaping (_ success: Bool, _ path: URL?) -> ())  {
        self.showLoadingView(vc: self)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riversRef = storageRef.child("/" + "\(randomString(length: 2))" + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = riversRef.putFile(from: URL(fileURLWithPath: localFile), metadata: metadata) { metadata, error in
            self.hideLoadingView()
            guard metadata != nil else {
                completion(false, nil)
                return
            }
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(false,nil)
                    return
                }
                completion(true, downloadURL)
            }
        }
    }
    
    /*func sendGifWithOnlineCheck4Partner() {
        self.getPartnerTotalMessageAndBlockState{ (isSuccess, num, isBlock) in
            if isSuccess{
                self.messageNum = num.toInt() ?? 0
                self.isBlock = isBlock
                self.getPartnerOnlineStatus { (isSuccess, online) in
                    if isSuccess{
                        guard let gifurl = self.gifURL else {
                            return
                        }
                        self.doSend(online, msgtype: .gif, attachment: "\(gifurl)")
                    }else{
                        self.showToast("Network issue")
                    }
                }
            }
        }
    }*/
    
    @IBAction func sendAction(_ sender: Any) {
        if is_edit{
            var chatObject = [String: String]()
            // MARK: for message object for partner - chatObject
            chatObject["message"]     = edt_msgSend.text ?? ""
            chatObject["image"]       = ""
            chatObject["photo"]       = thisuser.user_photo
            chatObject["sender_id"]   = "\(thisuser.user_id ?? 0)"
            chatObject["time"]        = self.msgdataSource[self.edt_index].timestamp
            chatObject["name"]        = thisuser.first_name! + " " + thisuser.last_name!
            
            Database.database().reference().child("message").child(self.chatroom_id).child(self.msgdataSource[self.edt_index].msg_id).setValue(chatObject)
            self.msgdataSource[edt_index].msgContent = edt_msgSend.text ?? ""
            
            self.edt_msgSend.text = nil
            self.edt_index = 0
            self.is_edit = false
            
            self.tbl_Chat.reloadData()
        }else{
            if checkValid() {
                /**self.getPartnerTotalMessageAndBlockState { (isSuccess, num, isBlock) in
                    if isSuccess{
                        self.messageNum = num.toInt() ?? 0
                        self.isBlock = isBlock
                        //print("messageNum==>",self.messageNum)
                        self.getPartnerOnlineStatus { (isSuccess, online) in
                            if isSuccess{
                                //print("successstate==>",online)
                                let msgcontent = self.edt_msgSend.text!
                                self.edt_msgSend.text! = ""
                                self.doSend(online, msgtype: .text, attachment: msgcontent)
                            }else{
                                //print("failedstate===>",online)
                                //self.showToast("Network issue")
                            }
                        }
                    }
                }*/
                self.getPartnerOnlineStatus { (isSuccess, online) in
                    if isSuccess{
                        //print("successstate==>",online)
                        let msgcontent = self.edt_msgSend.text!
                        self.edt_msgSend.text! = ""
                        self.doSend(online, msgtype: .text, attachment: msgcontent)
                    }else{
                        //print("failedstate===>",online)
                        //self.showToast("Network issue")
                    }
                }
            }
        }
    }
    
    func doSend(_ online: Bool, msgtype: MsgType, attachment: String) {
        if  self.isBlock == "true"{
            self.showToast("Sorry! You have been blocked from this user.")
            if msgtype == .text{
                self.edt_msgSend.text! = ""
            }
            self.isdosending = false
        }else{
            let me_id: String = "\(thisuser.user_id ?? 0)"
            let partner_id: String = "\(self.partner_model.user_id ?? 0)"
            if !isdosending{
                isdosending = true
                let timeNow = Int(NSDate().timeIntervalSince1970) * 1000
                var chatObject = [String: String]()
                // MARK: for message object for partner - chatObject
                if msgtype == .text{
                    if !attachment.isEmpty{
                        chatObject["message"]     = attachment
                    }else{
                        return
                    }
                }else{
                    chatObject["message"]     = ""
                }
                if msgtype == .image || msgtype == .gif{
                    chatObject["image"]       = attachment
                }else{
                    chatObject["image"]       = ""
                }
                chatObject["photo"]       = thisuser.user_photo
                chatObject["sender_id"]   = "\(thisuser.user_id ?? 0)"
                chatObject["time"]        = "\(timeNow)" as String
                chatObject["name"]        = thisuser.first_name! + " " + thisuser.last_name!
                
                FirebaseAPI.sendMessage(chatObject, chatroom_id) { (status, message) in
                    if status {
                        var listObject = [String: String]()
                        listObject["id"]   = partner_id
                        // MARK: for list view for my list object - - listobject
                        if msgtype == .text{
                            listObject["message"]     = attachment
                        }else if msgtype == .image{
                            listObject["message"]     = "Sent image"
                        }else{
                            listObject["message"]     = "Sent gif"
                        }
                        listObject["sender_id"]     = partner_id
                        listObject["sender_first_name"]    = self.partner_model.first_name
                        listObject["sender_last_name"]    = self.partner_model.last_name
                        listObject["sender_photo"]  = self.partner_model.user_photo
                        listObject["sender_birthday"]  = "\(self.partner_model.birthday ?? 0)"
                        listObject["time"]           = "\(timeNow)" as String
                        
                        FirebaseAPI.sendListUpdate(listObject, "u" + me_id, partnerid: "u" + partner_id){
                            (status,message) in
                            if status{
                                var listObject1 = [String: String]()
                                // MARK:  for list view for partner's list object - listobject1
                                listObject1["id"]              = me_id
                                if msgtype == .text{
                                    listObject1["message"]     = attachment
                                }else if msgtype == .image{
                                    listObject1["message"]     = "Sent image"
                                }else{
                                    listObject1["message"]     = "Sent gif"
                                }
                                listObject1["sender_id"]       = me_id
                                listObject1["sender_first_name"]     = thisuser.first_name
                                listObject1["sender_last_name"]     = thisuser.last_name
                                listObject1["sender_photo"]    = thisuser.user_photo
                                listObject1["sender_birthday"]    = "\(thisuser.birthday ?? 0)"
                                listObject1["time"]            = "\(timeNow)" as String
                               
                                /**if !online{
                                    FirebaseAPI.sendListUpdate(listObject1, "u" + partner_id, partnerid: "u" + me_id){
                                        (status,message) in
                                        if status{
                                            ApiManager.sendPushNoti(receiver_id: partner_id.toInt()!, message: listObject1["message"]!)
                                            self.isdosending = false
                                            if msgtype == .image{
                                                self.uiv_postView.isHidden = true
                                                self.imageFils.removeAll()
                                                self.imv_Post.image = nil
                                            }
                                        }
                                    }
                                }else{
                                    FirebaseAPI.sendListUpdate(listObject1, "u" + partner_id, partnerid: "u" + me_id){
                                        (status,message) in
                                        if status{
                                            self.isdosending = false
                                            if msgtype == .image{
                                                self.uiv_postView.isHidden = true
                                                self.imageFils.removeAll()
                                                self.imv_Post.image = nil
                                            }
                                        }
                                    }
                                }*/
                                FirebaseAPI.sendListUpdate(listObject1, "u" + partner_id, partnerid: "u" + me_id){
                                    (status,message) in
                                    if status{
                                        self.isdosending = false
                                        if msgtype == .image{
                                            self.uiv_postView.isHidden = true
                                            self.imageFils.removeAll()
                                            self.imv_Post.image = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func postImageBtnclicked(_ sender: Any) {
        /**self.getPartnerTotalMessageAndBlockState { (isSuccess, num, isBlock) in
            if isSuccess{
                self.messageNum = num.toInt() ?? 0
                self.isBlock = isBlock
                self.getPartnerOnlineStatus { (isSuccess, online) in
                    if isSuccess{
                        guard let downloadRL = self.downloadURL else {
                            return
                        }
                        self.doSend(online, msgtype: .image, attachment: "\(downloadRL)")
                    }else{
                        self.showToast("Network issue")
                    }
                }
            }
        }*/
        self.getPartnerOnlineStatus { (isSuccess, online) in
            if isSuccess{
                guard let downloadRL = self.downloadURL else {
                    return
                }
                self.doSend(online, msgtype: .image, attachment: "\(downloadRL)")
            }else{
                self.showToast("Network issue")
            }
        }
    }
    
    @IBAction func attachBtnClicked(_ sender: Any) {
        self.openGallery()
    }
    
    @IBAction func cancelImageBtnClicked(_ sender: Any) {
        self.uiv_postView.isHidden = true
        self.imageFils.removeAll()
        self.imv_Post.image = nil
    }
    
    func createViewControllerwithStoryBoardName(_ storyBoardName: String, controllerName:
    String) -> UIViewController{
       let storyboad = UIStoryboard(name: storyBoardName, bundle: nil)
       let targetVC = storyboad.instantiateViewController(withIdentifier: controllerName)
       return targetVC
    }
    
    @IBAction func spaceBtnClicked(_ sender: Any) {
        self.uiv_postView.isHidden = true
        self.imageFils.removeAll()
        self.imv_Post.image = nil
    }
}

@available(iOS 11.0, *)
extension MessageSendVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.msgdataSource.count
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
        // check currrent block status
        if self.msgdataSource[indexPath.section].image == ""{
            let cell = tbl_Chat.dequeueReusableCell(withIdentifier: "ChatCell", for:indexPath) as! ChatCell
            cell.selectionStyle = .none
            cell.entity = msgdataSource[indexPath.section]
            
            if self.msgdataSource[indexPath.section].me{
                cell.meView.isHidden = false
                cell.youView.isHidden = true
                cell.imv_partner.isHidden = true
                cell.youlblTime.isHidden = true
                cell.melblTime.isHidden = false
                cell.lbl_readReceipt.isHidden = false
            }else{
                cell.meView.isHidden = true
                cell.youView.isHidden = false
                cell.imv_partner.isHidden = false
                cell.youlblTime.isHidden = false
                cell.melblTime.isHidden = true
                cell.lbl_readReceipt.isHidden = true
            }
            return cell
        }else{
            let cell = tbl_Chat.dequeueReusableCell(withIdentifier: "chatImageCell", for:indexPath) as! chatImageCell
            cell.selectionStyle = .none
            cell.entity = msgdataSource[indexPath.section]
            cell.btn_me.tag = indexPath.section
            cell.btn_you.tag = indexPath.section
            cell.btn_me_handle = {() in
                if let url = URL(string: self.msgdataSource[indexPath.section].image){
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        let controller = CPImageViewer()
                        controller.image = image
                        self.navigationController?.delegate = self.animator
                        self.present(controller, animated: true, completion: nil)
                    })
                }
            }
            
            cell.btn_you_handle = {() in
                if let url = URL(string: self.msgdataSource[indexPath.section].image){
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        let controller = CPImageViewer()
                        controller.image = image
                        self.navigationController?.delegate = self.animator
                        self.present(controller, animated: true, completion: nil)
                    })
                }
            }
            
            if self.msgdataSource[indexPath.section].me{
                cell.uiv_me.isHidden = false
                cell.uiv_you.isHidden = true
                cell.imv_partner.isHidden = true
                cell.btn_me.isHidden = false
                cell.btn_you.isHidden = true
            }else{
                cell.uiv_me.isHidden = true
                cell.uiv_you.isHidden = false
                cell.imv_partner.isHidden = false
                cell.btn_me.isHidden = true
                cell.btn_you.isHidden = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 20
        }else{
            return cellSpacingHeight
        }
    }
}

@available(iOS 11.0, *)
extension MessageSendVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tbl_Chat.scrollToBottomRow()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.tbl_Chat.scrollToBottomRow()
    }
}

@available(iOS 11.0, *)
extension MessageSendVC: ImagePickerDelegate1{
    
    func didSelect(image: UIImage?) {
        self.gotoUploadProfile(image)
    }
}

@available(iOS 11.0, *)
extension MessageSendVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height * 0.8
        let w = h
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

@available(iOS 11.0, *)
extension MessageSendVC{
    func showLoadingView(vc: UIViewController, label: String = "") {
        hud = MBProgressHUD .showAdded(to: vc.view, animated: true)
        if label != "" {
            hud!.label.text = label
        }
        hud!.mode = .indeterminate
        hud!.animationType = .zoomIn
        hud!.bezelView.color = .clear
        hud!.contentColor = COLORS.PRIMARYDARK
        hud!.bezelView.style = .solidColor
    }
    
    func hideLoadingView() {
       if let hud = hud {
           hud.hide(animated: true)
       }
    }
    
    func showToast(_ message : String) {
        self.view.makeToast(message)
    }
    
    func removeNode4me4finish(){
        requestPath.child("u" + "\(thisuser.user_id ?? 0)").child("u" + "\(self.partner_model.user_id ?? 0)").removeValue()
    }
}

enum MsgType: String {
    case text = "text"
    case gif = "gif"
    case image = "image"
}

