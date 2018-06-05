//
//  Job.swift
//  FinalProject
//
//  Created by Romano on 26/03/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Job{
    
    
    var jobId:String?
    var jobName: String
    var jobLocation:String
    var imageUrl:String
    var lastUpdate:Date?
    var description:String
    var hours:String
    var uID:String
    var companyName:String?
    var jobType:String
    var languages:String
    var move:String
    var workExperience: String
    var education: String
    var salary: String
    var availability: String
    var deleted: String?
    
    init(JobLocation:String, ImageUrl:String, Hours:String, Description:String ,uID:String,jobID:String? = nil, jobName: String, jobType:String, companyName:String? = nil,languages:String, move:String,  workExperience:String, education:String,salary:String,availability:String, deleted:String? = "false"){
        
        self.jobLocation = JobLocation
        self.imageUrl = ImageUrl
        self.hours = Hours
        self.description = Description
        self.uID = uID
        self.jobId = jobID!
        self.jobName = jobName
        self.jobType = jobType
        self.companyName = companyName!
        self.languages = languages
        self.move = move
        self.workExperience = workExperience
        self.education = education
        self.salary = salary
        self.availability = availability
        self.deleted = deleted
    }
    
    
    init(json:Dictionary<String,Any>){
        
        jobName = json["jobName"] as! String
        jobLocation = json["jobLocation"] as! String
        imageUrl = json["imageUrl"] as! String
        hours = json["hours"] as! String
        description = json["description"] as! String
        jobType = json["jobType"] as! String
        jobId = json["jobId"] as? String
        companyName = json["companyName"] as? String
        languages = json["languages"] as! String
        move = json["move"] as! String
        workExperience = json["workExperience"] as! String
        education = json["education"] as! String
        salary = json["salary"] as! String
        availability = json["availability"] as! String
        deleted = json["deleted"] as? String
        uID = json["uID"] as! String
        if let user = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(user)
        }

    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["jobName"] = jobName
        json["jobLocation"] = jobLocation
        json["imageUrl"] = imageUrl
        json["hours"] = hours
        json["description"] = description
        json["jobType"] = jobType
        json["jobId"] = jobId
        json["uID"] = uID
        json["companyName"] = companyName
        json["languages"] = languages
        json["move"] = move
        json["workExperience"] = workExperience
        json["education"] = education
        json["salary"] = salary
        json["availability"] = availability
        json["deleted"] = deleted
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
    
}
