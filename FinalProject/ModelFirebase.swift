//
//  ModelFirebase.swift
//  FinalProject
//
//  Created by Noi Gilad on 02/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase{

static func checkIfExistByEmail(email:String, callback:@escaping (String?)->Void)
{
    Auth.auth().fetchProviders(forEmail: email) { (string, error) in
        if (string != nil) {
            print ("email not avail")
            callback("Email exist")
            
        } else {
            print ("email avail")
            callback("Email avail")
            
        }
        
    }
}

static func sendResetPassword(email: String)
{
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        
    }
    
}

    static func loggedIn(callback:@escaping (String?)->Void){
        callback(Auth.auth().currentUser?.uid)
        
    }
    
static public func authentication(email: String, password: String, callback:@escaping (Bool?)->Void)
{
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        if(user != nil)
        {
            print("user autenticated")
            callback(true)
        }
        else{
            print ("there was an error")
            callback (false)
        }
    }
    
}
    
    //log out
   static  func logOut(callback:@escaping (Bool?)->Void)
    {
        try! Auth.auth().signOut()
        callback(true)
        
    }
    
    
    static func getAllMatchAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Match])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var matches = [Match]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let match = Match(json: json)
                        matches.append(match)
                    }
                }
            }
            callback(matches)
        }
        let ref = Database.database().reference().child("Match")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(DataEventType.value, with: handler)
        }else{
            ref.observe(DataEventType.value, with: handler)
        }
    }

    static func saveMatch(match: Match,callback:@escaping (Bool)->Void){
        print("add new match- model firebase")
        let matchId = match.matchId
        let ref = Database.database().reference().child("Match").child(matchId)
        ref.setValue(match.toJson())
        ref.setValue(match.toJson()){(error, dbref) in
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
    
    static func deleteMatch(matchId: String, callback:@escaping (Bool)->Void)
    {
            let ref = Database.database().reference().child("Match").child(matchId)
            ref.removeValue(completionBlock: { (error, dbref) in
                callback(true)
            })
        }
    
    static func saveShowed(show:Show)
    {
        let ref = Database.database().reference().child("Showed").child(show.userId).child(show.showedId)
        ref.setValue(show.toJson())
    }
    
    static func getAllShow(id:String,callback:@escaping ([Show])->Void){
        
            Database.database().reference().child("Showed").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                var showes = [Show]()
                for child in snapshot.children.allObjects{
                    if let childData = child as? DataSnapshot{
                        if let json = childData.value as? NSDictionary{
                            let show = Show(json: json as! Dictionary<String, Any>)
                            showes.append(show)
                        }
                    }
                }
                callback(showes)
            })
            
        
    }
    
}
