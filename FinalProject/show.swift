//
//  Match.swift
//  FinalProject
//
//  Created by Romano on 28/04/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Show{
    
    var showedId:String
    var userId:String
    var lastUpdate:Date?
    
    
    init(showedId:String, userId:String){
        
        self.showedId = showedId
        self.userId = userId
    }
    
    
    init(json:Dictionary<String,Any>){
        
        showedId = json["showedId"] as! String
        userId = json["userId"] as! String
        if let user = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(user)
        }
    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["showedId"] = showedId
        json["userId"] = userId
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
}
