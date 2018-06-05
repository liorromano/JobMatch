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

class ModelFirebaseCompany{
    
    
    static func addNewCompany(company: Company, password: String, email: String, completionBlock:@escaping (Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) {
            (uID, error) in
            company.uID = uID?.uid
            let myRef = Database.database().reference().child("Companies").child(company.uID!)
            myRef.setValue(company.toJson())
            myRef.setValue(company.toJson()){(error, dbref) in
                completionBlock(error)
            }

        }
    }
    
    
    //save image to firebase
    static func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = Storage.storage().reference(forURL:
            "gs://finalprojectjobmatch.appspot.com/Companies/").child(name)
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

   static func getCompanyById(id:String, callback:@escaping (Company?)->Void){
   
        Database.database().reference().child("Companies").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let value = snapshot.value as? NSDictionary{
              let company = Company(json: value as! Dictionary<String, Any>)
                callback(company)
            }
            else
            {
                
                callback(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    

    static func updateCompany(company: Company, callback:@escaping (Bool)->Void)
    {
        Database.database().reference().child("Companies").child(company.uID!).updateChildValues(company.toJson(), withCompletionBlock: { (error, DatabaseReference) in
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
 
    //log out
    static func logOut(callback:@escaping (Bool?)->Void)
    {
        try! Auth.auth().signOut()
        callback(true)
        
    }

}
