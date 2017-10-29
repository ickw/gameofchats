//
//  Message.swift
//  gameofchats
//
//  Created by daiki ichikawa on 2017/10/27.
//  Copyright © 2017年 Daiki Ichikawa. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }

}
