
import Foundation
import Firebase
import SwiftyUserDefaults
import FirebaseDatabase
import FirebaseFirestore

class FirebaseAPI {
    
    static let ref = Database.database().reference()
    
    //static let CONV_REFERENCE = ""
    static let MESSAGE = "message"
    static let LIST = "list"
    static let STATUS = "status"
    
     //MARK: - Set/remove Add/change observer
    static func setMessageListener(_ roomId: String, handler:@escaping (_ msg: ChatModel)->()) -> UInt {
        return ref.child(MESSAGE).child(roomId).observe(.childAdded) { (snapshot, error) in
            let path = snapshot.key
            let childref = snapshot.value as? NSDictionary
            //print(childref)
            if let childRef = childref{
                let msg = parseMsg(key: path, snapshot: childRef)
                handler(msg)
            }
        }
    }
    
    static func removeChattingRoomObserver(_ roomId: String, _ handle : UInt) {
        ref.child(MESSAGE).child(roomId).removeObserver(withHandle: handle)
    }
    
    static func getPartnerOnlinestatus(_ path: String, handler:@escaping (_ msg: StatusModel)->()) -> UInt {
        return ref.child(STATUS).child(path).observe(.value) { (snapshot, error) in

            let childref = snapshot.value as? NSDictionary
            if let childRef = childref {
                //print(childRef)
                let msg = parseStatus(childRef)
                handler(msg)
            } else {
            }
        }
    }
    
    static func removePartnerOnlineStatusObserver(_ path: String, _ handle : UInt) {
        ref.child(STATUS).child(path).removeObserver(withHandle: handle)
    }
    
    static func parseStatus(_ snapshot: NSDictionary) -> StatusModel {
        let status = StatusModel()
        //print(snapshot)
        status.online = snapshot["online"] as! String
        status.sender_id = snapshot["sender_id"] as! String
        status.timesVal = snapshot["time"] as! String
        
        return status
    }
    
    static func parseMsg(key: String, snapshot: NSDictionary) -> ChatModel {
        let message = ChatModel()
        message.msg_id = key
        if let image = snapshot["image"] as? String{
            message.image = image
        }
        if let msgContent = snapshot["message"] as? String{
            message.msgContent = msgContent
        }
        if let name = snapshot["name"] as? String{
            message.name = name
        }
        if let photo = snapshot["photo"] as? String{
            message.photo = photo
        }
        if let sender_id = snapshot["sender_id"] as? String{
            message.sender_id = sender_id
        }
        if "\(thisuser.user_id ?? 0)" == message.sender_id{
            message.me = true
        }
        else{
            message.me = false
        }
        if let timestamp = snapshot["time"] as? String{
            message.timestamp = timestamp
        }
        return message
    }
    
    static func getUserList(userRoomid : String, handler:@escaping (_ userList: AllChatModel?)->()) -> UInt{
        return ref.child(LIST).child(userRoomid).observe(.childAdded) { (snapshot, error) in
            let childref = snapshot.value as? NSDictionary
            if let childRef = childref {
                //print(childRef)
                if let userlist = parseUserList(childRef){
                    handler(userlist)
                }
                
            } else {
                handler(nil)
            }
        }
    }
    
    static func removeUserlistObserver(userRoomid: String, _ handle : UInt) {
        ref.child(LIST).child(userRoomid).removeObserver(withHandle: handle)
    }
    
    static func parseUserList(_ snapshot: NSDictionary) -> AllChatModel? {
        if  let id = snapshot["id"] as? String,let first_name = snapshot["sender_first_name"] as? String,let last_name = snapshot["sender_last_name"] as? String, let sender_photo = snapshot["sender_photo"] as? String, let msgtime = snapshot["time"] as? String, let content = snapshot["message"] as? String, let birthday = snapshot["sender_birthday"] as? String{
            let partner = AllChatModel(id: id.toInt() ?? 0, first_name: first_name, last_name: last_name, userAvatar: sender_photo, msgTime: msgtime, content: content, birthday: birthday.toInt() ?? 0)
            return partner
        }else{
            return nil
        }
    }

    // MARK: - send Chat
    static func sendMessage(_ chat:[String:String], _ roomId: String, completion: @escaping (_ status: Bool, _ message: String) -> ()) {
        ref.child(MESSAGE).child(roomId).childByAutoId().setValue(chat) { (error, dataRef) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                print(dataRef)
                let totalPath: String = "\(dataRef)"
//                let totalPathArr = totalPath.split(separator: "/")
//                print(totalPathArr.first)
//                print(totalPathArr.last)
                completion(true, totalPath)
            }
        }
    }
    
    static func sendListUpdate(_ chat:[String:String], _ myid: String,partnerid : String, completion: @escaping (_ status: Bool, _ message: String) -> ()) {

        ref.child(LIST).child(myid).child(partnerid).setValue(chat) { (error, dataRef) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Userlist updated successfully.")
            }
        }
    }
    
    /**static func detectChatRoomValueChanage(userRoomid : String, handler:@escaping (_ msg: ChatModel)->()) -> UInt {
        return ref.child(MESSAGE).child(userRoomid).observe(.childChanged) { (snapshot, error) in

            let childref = snapshot.value as? NSDictionary
            if let childRef = childref {
                //print(childRef)
                let chatModel = parseMsg(childRef)
                handler(chatModel)
            } else {
                handler(ChatModel())
            }
        }
    }*/
    
    static func removeChangeRoomObserver(_ roomId: String, _ handle : UInt) {
        ref.child(MESSAGE).child(roomId).removeObserver(withHandle: handle)
    }
}
