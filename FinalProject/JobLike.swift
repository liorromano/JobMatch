//
//  JobLike.swift
//  FinalProject
//
//  Created by Romano on 28/04/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase


class JobLike{

    var jobId:String
    var employeeId:String
    var lastUpdate:Date?
    
    
    init(jobId:String, employeeId:String){
        
        self.jobId = jobId
        self.employeeId = employeeId

    }
    
    
    init(json:Dictionary<String,Any>){
        
        employeeId = json["employeeId"] as! String
        jobId = json["jobId"] as! String
        if let user = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(user)
        }
        
    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["employeeId"] = employeeId
        json["jobId"] = jobId
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }

}
