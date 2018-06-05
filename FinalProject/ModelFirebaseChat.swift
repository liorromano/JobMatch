//
//  ModelFirebaseChat.swift
//  FinalProject
//
//  Created by Romano on 06/05/2018.
//  Copyright © 2018 Romano. All rights reserved.


import Foundation
import Firebase

class ModelFirebaseChat{
    
    static func addNewJob(job: Job,callback:@escaping (Bool)->Void){
        print("add new post- model firebase post")
        let jobId = job.jobId
        let ref = Database.database().reference().child("Jobs").child(jobId!)
        ref.setValue(job.toJson())
        ref.setValue(job.toJson()){(error, dbref) in
            if (error != nil)
            {
                callback(false)
            }
            else
            {
                callback(true)
            }
        }
        
        
    }
    

    static func getAllJobsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Job])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var jobs = [Job]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let job = Job(json: json)
                        jobs.append(job)
                    }
                }
            }
            callback(jobs)
        }
        let ref = Database.database().reference().child("Jobs")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(DataEventType.value, with: handler)
        }else{
            ref.observe(DataEventType.value, with: handler)
        }
    }
    
    static func clearObservers(){
        let ref = Database.database().reference().child("Jobs")
        ref.removeAllObservers()
    }
    
    
    static func checkIfChatExist(id:String,callback:@escaping (Bool?)->Void)
    {
            Database.database().reference().child("Chats").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                let chat = Chat(json: value as! Dictionary<String, Any>)
                callback(true)
            }
            else
            {
                callback(false)
            }
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    static func saveChat(chat: Chat,callback:@escaping (Bool?)->Void){
        
        let ref = Database.database().reference().child("Chats").child(chat.key!)
        ref.setValue(chat.toJson())
        ref.setValue(chat.toJson()){(error, dbref) in
            if (error != nil)
            {
                callback(false)
            }
            else
            {
                callback(true)
            }
        }

    }

}
