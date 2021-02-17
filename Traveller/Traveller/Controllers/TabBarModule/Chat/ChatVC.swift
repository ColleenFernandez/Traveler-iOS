//
//  ChatVC.swift
//  Traveller
//
//  Created by top Dev on 11.02.2021.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class ChatVC: BaseVC {
    
    @IBOutlet weak var col_allChats: UICollectionView!
    var ds_allChats = [AllChatModel]()
    var userlistHandle: UInt?
    let meid = "\(thisuser.user_id ?? 0)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: Constants.SCREEN_WIDTH, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.col_allChats.collectionViewLayout = layout
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let userlistHandle = userlistHandle{
            FirebaseAPI.removeUserlistObserver(userRoomid: "u" + meid, userlistHandle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Chat"
        let roomid = "u" + meid
        self.userlistListner(roomid)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userlistListner(_ userRoomid : String)  {
        self.ds_allChats.removeAll()
        self.col_allChats.reloadData()
            userlistHandle = FirebaseAPI.getUserList(userRoomid : userRoomid ,handler: { (userlist) in
            if let userlist = userlist{
                guard userlist.id != nil else{
                    return
                }
            }
            if let userlist = userlist{
                self.ds_allChats.append(userlist)
                print(self.ds_allChats.count)
                self.col_allChats.reloadData()
            }
        })
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.tag
        let ref = Database.database().reference()
        let meid = "\(thisuser.user_id ?? 0)"
        let partnerid = "\(self.ds_allChats[index].id ?? -1)"
        let chatting_room = thisuser.user_id > self.ds_allChats[index].id! ? partnerid + "_" + meid : meid + "_" + partnerid
        let melist = "u" + meid
        let partnerlist = "u" + partnerid
        ref.child("list").child(melist).child(partnerlist).removeValue{
            error, _ in
            print(error as Any)
        }
        ref.child("list").child(partnerlist).child(melist).removeValue{
            error, _ in
            print(error as Any)
        }
        ref.child("message").child(chatting_room).removeValue{
            error, _ in
            print(error as Any)
        }
        self.ds_allChats.remove(at: index)
        self.col_allChats.reloadData()
    }
    
    @IBAction func declineBtnClicked(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.tag
        //let timeNow = Int(NSDate().timeIntervalSince1970) * 1000
        let ref = Database.database().reference()
        let meid = "\(thisuser.user_id ?? 0)"
        let userchattingRoom = "u" + meid
        let partnerid = "u" + "\(self.ds_allChats[index].id!)"
        ref.child("list").child(userchattingRoom).child(partnerid).child("isBlock").setValue("true")
        /*self.showLoadingView(vc: self)
        ApiManager.addBlockUsers(blocks: self.ds_allChats[index].id!) { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                //dump(blockusers,name: "thisisblockusers")
                DispatchQueue.main.async {
                    self.ds_allChats.remove(at: index)
                    self.ds_recentChats.remove(at: index)
                    self.col_recentChats.reloadData()
                    self.col_allChats.reloadData()
                }
            }
        }*/
        DispatchQueue.main.async {
            self.ds_allChats.remove(at: index)
            self.col_allChats.reloadData()
        }
    }
    
    @IBAction func spaceBtnClicked(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.tag
        self.ds_allChats[index].showOverlay = false
        var indexPaths = [IndexPath]()
        indexPaths.removeAll()
        indexPaths.append(IndexPath.init(row: index, section: 0))
        col_allChats.reloadItems(at: indexPaths)
    }
    
}

extension ChatVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ds_allChats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllChatCell", for: indexPath) as! AllChatCell
        cell.entity = self.ds_allChats[indexPath.row]
        //cell.delegate = self
        //cell.addBlurToView()
        let leftSwipe = MySwipeGesture(target: self, action: #selector(handleSwipeLeft(_:)))
        leftSwipe.direction = .left
        leftSwipe.cell = cell
        cell.addGestureRecognizer(leftSwipe)
        cell.btn_spaceBtn.tag = indexPath.row
        cell.btn_delete.tag = indexPath.row
        cell.btn_decline.tag = indexPath.row
        return cell
    }
    
    @objc func handleSwipeLeft(_ sender:MySwipeGesture) {
        if (sender.direction == .left) {
            print("swipe left")
            if let cell = sender.cell as? AllChatCell{
                cell.uiv_overlay.isHidden = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let partner = self.ds_allChats[indexPath.row]
        let tovc = self.createVC("MessageSendVC") as! MessageSendVC
        tovc.partner_model = UserModel(user_id: partner.id!, user_name: partner.userName ?? "", user_photo: partner.userAvatar ?? "")
        let navigationcontroller = UINavigationController.init(rootViewController: tovc)
        navigationcontroller.modalPresentationStyle = .fullScreen
        self.present(navigationcontroller, animated: false, completion: nil)
    }
}

extension ChatVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.size.width
        let h: CGFloat = 100
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class MySwipeGesture: UISwipeGestureRecognizer {
    var cell: UICollectionViewCell?
}

