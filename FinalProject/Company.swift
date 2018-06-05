//
//  Employer.swift
//  FinalProject
//
//  Created by Noi Gilad on 02/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase
class Company{
    
    var companyName: String
    var companyLocation: String
    var companyPhone: String
    var companyEmail: String
    var uID:String?
    var imageUrl:String?
    var lastUpdate:Date?
    var numberOfJobs:Int = 0
    var type: String = "company"
    
    
    
    init(companyName:String, companyLocation:String, companyPhone:String, companyEmail:String, imageUrl:String? = nil, uID:String? = nil){
        self.companyName = companyName
        self.companyLocation = companyLocation
        self.companyPhone = companyPhone
        self.companyEmail = companyEmail
        self.uID = uID
        self.imageUrl = imageUrl
        self.type = "company"
    }
    
    

    
    
    init(json:Dictionary<String,Any>){
        companyName = json["companyName"] as! String
        companyLocation = json["companyLocation"] as! String
        companyPhone = json["companyPhone"] as! String
        companyEmail = json["companyEmail"] as! String
        numberOfJobs=(json["numberOfJobs"] as? Int)!
        uID = json["uID"] as? String
        type = json["type"] as! String
        if let im = json["imageUrl"] as? String{
            imageUrl = im
        }
        
        if let user = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(user)
        }
    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["companyName"] = companyName
        json["companyLocation"] = companyLocation
        json["companyPhone"] = companyPhone
        json["companyEmail"] = companyEmail
        json["numberOfJobs"] = numberOfJobs
        json["type"] = type
        json["uID"] = uID
        if (imageUrl != nil){
            json["imageUrl"] = imageUrl!
        }
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
    
}
