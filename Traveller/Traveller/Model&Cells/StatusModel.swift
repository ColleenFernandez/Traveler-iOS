//
//  StatusModel.swift
//  DatingKinky
//
//  Created by top Dev on 8/10/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
class StatusModel {
    
    var online : String
    var sender_id : String
    var timesVal : String
    
    
    init(online : String,sender_id : String, timesVal : String) {
        self.online = online
        self.sender_id = sender_id
        self.timesVal = timesVal
    }
    
    init() {
        self.online = ""
        self.sender_id = ""
        self.timesVal = ""
    }
}


class VerifyModel {
    var receiver_status : String
    var receiver_video_value : String
    var sender_status : String
    var sender_video_value : String
    
    init(receiver_status : String,receiver_video_value : String, sender_status : String, sender_video_value: String) {
        self.receiver_status = receiver_status
        self.receiver_video_value = receiver_video_value
        self.sender_status = sender_status
        self.sender_video_value = sender_video_value
    }
    
    init() {
        self.receiver_status = "0"
        self.receiver_video_value = ""
        self.sender_status = "0"
        self.sender_video_value = ""
    }
}
