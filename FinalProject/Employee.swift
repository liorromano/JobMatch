//
//  User.swift
//  FinalProject
//
//  Created by Romano on 18/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase
class Employee{
    
    var userName:String
    var fullName:String
    var imageUrl:String?
    var lastUpdate:Date?
    var uID:String?
    var gender:String?
    var languages:String
    var move:String
    var profession: String
    var workExperience: String
    var age: String
    var education: String
    var placeWork: String
    var salary: String
    var workHours: String
    var availability: String

    
    init(userName:String, fullName:String, imageUrl:String? = nil, uID:String? = nil, gender:String? = nil, languages:String, move:String, profession:String,workExprience:String,age:String,education:String,placeWork:String,salary:String, workHours:String, availability: String){
        self.userName=userName
        self.fullName=fullName
        self.imageUrl = imageUrl
        self.uID = uID
        self.gender = gender
        self.age = age
        self.education = education
        self.placeWork = placeWork
        self.profession = profession
        self.languages = languages
        self.workExperience = workExprience
        self.salary = salary
        self.move = move
        self.workHours = workHours
        self.availability = availability
    }
    
    
    init(json:Dictionary<String,Any>){
        userName = json["userName"] as! String
        fullName = json["fullName"] as! String
        uID = json["uID"] as? String
        languages = json["languages"] as! String
        move = json["move"] as! String
        profession = json["profession"] as! String
        workExperience = json["workExperience"] as! String
        age = json["age"] as! String
        education = json["education"] as! String
        placeWork = json["placeWork"] as! String
        workHours = json["workHours"] as! String
        availability = json["availability"] as! String
        salary = json["salary"] as! String
        if let gen = json["gender"] as? String{
            gender = gen
        }
        
        if let im = json["imageUrl"] as? String{
            imageUrl = im
        }
        
        if let user = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(user)
        }
    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["userName"] = userName
        json["fullName"] = fullName
        json["gender"] = gender
        json["uID"] = uID
        json["languages"] = languages
        json["move"] = move
        json["profession"] = profession
        json["workExperience"] = workExperience
        json["age"] = age
        json["education"] = education
        json["placeWork"] = placeWork
        json["workHours"] = workHours
        json["availability"] = availability
        json["salary"] = salary
        if (imageUrl != nil){
            json["imageUrl"] = imageUrl!
        }
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
    
}
