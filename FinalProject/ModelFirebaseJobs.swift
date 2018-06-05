//
//  ModelFirebase.swift
//  FinalProject
//
//  Created by Noi Gilad on 02/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebaseJobs{
    
    
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
    
    static func saveImageToFirebase(image:UIImage, companyID: String ,jobID: String, callback:@escaping (String?)->Void){
        let filesRef = Storage.storage().reference(forURL:
            "gs://finalprojectjobmatch.appspot.com/Jobs").child(companyID).child(jobID)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    //get the Job image from firebase
    static func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        
        ref.getData(maxSize: 10000000, completion: {(data, error) in
            if ( data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
    
    static func getAllJobsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Job])->Void){
        
         let ref = Database.database().reference().child("Jobs")

        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase()).observeSingleEvent(of: .value, with: { (snapshot) in
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
            })
        }
        else
        {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
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
            })
 
        }
    }
    
    
    static func clearObservers(){
        let ref = Database.database().reference().child("Jobs")
        ref.removeAllObservers()
    }
    
    //function that update the user in firebase
    static func updateJob(job: Job, callback:@escaping (Bool)->Void)
    {
        Database.database().reference().child("Jobs").child(job.jobId!).updateChildValues(job.toJson(), withCompletionBlock: { (error, DatabaseReference) in
            if((error) != nil)
            {
                callback(false)
            }
            else
            {
                callback(true)
            }
        })
        
    }
    
    static func saveJobLike(jobId:String, callback:@escaping (Bool)->Void)
    {
        Model.instance.loggedIn { (uId) in
            let ref = Database.database().reference().child("Likes").child("Jobs").child(jobId).child(uId!)
            let jobLike = JobLike(jobId: jobId, employeeId: uId!)
            ref.setValue(jobLike.toJson())
            ref.setValue(jobLike.toJson()){(error, dbref) in
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
    
    static func deleteJobLike(jobId:String, callback:@escaping (Bool)->Void)
    {
        Model.instance.loggedIn { (uId) in
            let ref = Database.database().reference().child("Likes").child("Jobs").child(jobId).child(uId!)
            ref.removeValue(completionBlock: { (error, dbref) in
                callback(true)
            })
        }
    }
    
    static func getJobLike(employeeId:String, jobId:String,  callback:@escaping (JobLike?)->Void){
        Database.database().reference().child("Likes").child("Jobs").child(jobId).child(employeeId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                let jobLike = JobLike(json: value as! Dictionary<String, Any>)
                callback(jobLike)
            }
            else
            {
                callback(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    static func deleteJob(jobID: String, matchList:[Match])
    {
        
        let myRef = Database.database().reference().child("Jobs").child(jobID)
        myRef.updateChildValues(["deleted": "true"])
        
        for match in matchList
        {
            let myRef = Database.database().reference().child("Match").child(match.matchId)
            myRef.updateChildValues(["deleted": "true"])
        }
        
        
        
    }
    
    
    
}
