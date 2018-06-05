//
//  ModelFirebaseUsers.swift
//  FinalProject
//
//  Created by Romano on 18/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ModelFirebaseEmployee{
    
    
    static func addNewEmployee(employee: Employee, password: String, email: String, completionBlock:@escaping (Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) {
            (uID, error) in
            employee.uID = uID?.uid
            let myRef = Database.database().reference().child("Employees").child(employee.uID!)
            myRef.setValue(employee.toJson())
            myRef.setValue(employee.toJson()){(error, dbref) in
                completionBlock(error)
            }
            
        }
    }
    
    //save image to firebase
    static func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = Storage.storage().reference(forURL:
            "gs://finalprojectjobmatch.appspot.com/Employees/").child(name)
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
    
    //get the profile image from firebase
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
    
    static func getEmployeeById(id:String, callback:@escaping (Employee?)->Void){
        Database.database().reference().child("Employees").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                let employee = Employee(json: value as! Dictionary<String, Any>)
                print("ModelFirebaseEmployee--- get employee by ID")
                callback(employee)
            }
            else
            {
                callback(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func updateEmployee(employee: Employee, callback:@escaping (Bool)->Void)
    {
        Database.database().reference().child("Employees").child(employee.uID!).updateChildValues(employee.toJson(), withCompletionBlock: { (error, DatabaseReference) in
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
    
    
    static func getAllEmployeesAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Employee])->Void){
        
        let ref = Database.database().reference().child("Employees")
        
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase()).observeSingleEvent(of: .value, with: { (snapshot) in
                var employees = [Employee]()
                for child in snapshot.children.allObjects{
                    if let childData = child as? DataSnapshot{
                        if let json = childData.value as? Dictionary<String,Any>{
                            let employee = Employee(json: json)
                            employees.append(employee)
                        }
                    }
                }
                callback(employees)
                
            })
        }
        else
        {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                var employees = [Employee]()
                for child in snapshot.children.allObjects{
                    if let childData = child as? DataSnapshot{
                        if let json = childData.value as? Dictionary<String,Any>{
                            let employee = Employee(json: json)
                            employees.append(employee)
                        }
                    }
                }
                callback(employees)
                
            })
        }
    }
    //log out
    static func logOut(callback:@escaping (Bool?)->Void)
    {
        try! Auth.auth().signOut()
        callback(true)
        
    }
    
    static func saveEmployeeLike(employeeId:String ,jobId:String, callback:@escaping (Bool)->Void)
    {
        let ref = Database.database().reference().child("Likes").child("Employee").child(employeeId).child(jobId)
        let employeeLike = EmployeeLike(jobId: jobId, employeeId: employeeId)
        ref.setValue(employeeLike.toJson())
        ref.setValue(employeeLike.toJson()){(error, dbref) in
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
    
    static func deleteEmployeeLike(employeeId:String ,jobId:String, callback:@escaping (Bool)->Void)
    {
        let ref = Database.database().reference().child("Likes").child("Employee").child(employeeId).child(jobId)
        ref.removeValue(completionBlock: { (error, dbref) in
            callback(true)
        })
    }
    
    static func getEmployeeLike(jobId:String,  callback:@escaping (EmployeeLike?)->Void){
        Model.instance.loggedIn { (uId) in
            Database.database().reference().child("Likes").child("Employee").child(uId!).child(jobId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get user value
                if let value = snapshot.value as? NSDictionary{
                    let employeeLike = EmployeeLike(json: value as! Dictionary<String, Any>)
                    callback(employeeLike)
                }
                else
                {
                    callback(nil)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}

