//
//  Match.swift
//  FinalProject
//
//  Created by Romano on 28/04/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Match{
    
    var jobId:String
    var jobName:String
    var employeeId:String
    var employeeName:String
    var matchId:String
    var companyId:String
    var deleted: String?
    
    var lastUpdate:Date?
    
    
    init(jobId:String, employeeId:String, jobName:String, employeeName:String, matchId:String, companyId:String, deleted:String? = "false"){
        
        self.jobId = jobId
        self.employeeId = employeeId
        self.jobName = jobName
        self.employeeName = employeeName
        self.matchId = matchId
        self.companyId = companyId
        self.deleted = deleted
    }
    
    
    init(json:Dictionary<String,Any>){
        
        employeeId = json["employeeId"] as! String
        jobId = json["jobId"] as! String
        jobName = json["jobName"] as! String
        employeeName = json["employeeName"] as! String
        matchId = json["matchId"] as! String
        companyId = json["companyId"] as! String
        deleted = json["deleted"] as? String
        if let user = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(user)
        }
    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["employeeId"] = employeeId
        json["jobId"] = jobId
        json["jobName"] = jobName
        json["employeeName"] = employeeName
        json["matchId"] = matchId
        json["companyId"] = companyId
        json["deleted"] = deleted
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
}
