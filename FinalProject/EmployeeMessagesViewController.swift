//
//  ProfileCollectionVC.swift
//  FinalProject
//
//  Created by Romano on 13/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit


class EmployeeMessagesViewController: UICollectionViewController {
    
    
    var cid:String?
    var cname:String?
    var key:String?
    
    
    var match:Match?
    var uid:String?
    //refresher variable
    var refresher: UIRefreshControl!
    
    var matchList = [Match]()
    var observerId:Any?
    
    var spinner: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //spinner configuration
        spinner = UIActivityIndicatorView()
        spinner?.center = (self.collectionView?.center)!
        spinner?.hidesWhenStopped = true
        spinner?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        collectionView?.addSubview(spinner!)
        
        
        ModelNotification.MatchList.observe{(list) in
            if(list != nil)
            {
                self.matchList.removeAll()
                let matches = list! as [Match]
                Model.instance.loggedIn(callback: { (uID) in
                    self.uid = uID
                    for match in matches
                    {
                        if(match.employeeId == uID)
                        {
                            self.matchList.append(match)
                        }
                    }
                    self.spinner?.stopAnimating()
                    self.collectionView?.reloadData()
                })
                
                
            }
        }
        
        
        /* ModelNotification.FollowList.observe{(list) in
         if(list != nil)
         {
         self.followers.removeAll()
         self.following.removeAll()
         let follows = list! as [Follow]
         Model.instance.loggedinUser(callback: { (uID) in
         for follow in follows
         {
         if((follow.followerUID == uID) && (follow.deleted == "false"))
         {
         self.followers.append(follow)
         }
         else if((follow.followingUID == uID) && (follow.deleted == "false"))
         {
         self.following.append(follow)
         }
         }
         self.spinner?.stopAnimating()
         self.collectionView?.reloadData()
         })
         
         
         }
         }*/
        
        
        spinner?.startAnimating()
        Model.instance.getAllMatchAndObserve()
        // Model.instance.getAllFollowsAndObserve()
        
        
    }
    
    
    deinit{
        if (observerId != nil){
            ModelNotification.removeObserver(observer: observerId!)
        }
    }
    
    
    func postsListDidUpdate(notification:NSNotification){
        self.matchList = notification.userInfo?["match"] as! [Match]
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.collectionView?.reloadData()
                
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
            return self.view as! UICollectionReusableView
    }
    
    //refreshing func
    func refresh(){
        collectionView?.reloadData()
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matchList.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatcell", for: indexPath as IndexPath) as! MessagesTableCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = UIColor(red: 0.4902, green: 0.698, blue: 0.8314, alpha: 1.0)
        cell.layer.borderColor = borderColor.cgColor
        Model.instance.getCompanyById(id: matchList[indexPath.row].companyId) { (company) in
            Model.instance.getImageCompany(urlStr: (company?.imageUrl)!, callback: { (image) in
                cell.picturePost.image = image
                cell.fullName.text = company?.companyName
                cell.JobNameLbl.text = self.matchList[indexPath.row].jobName
                cell.date.text = self.matchList[indexPath.row].lastUpdate?.stringValue
            })
        }
        
        return cell
    }
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "EmployeeChatSegue"
        {
                let chatVc = segue.destination as! ChatViewController
                chatVc.chatkey = self.key
                chatVc.displayName = self.cname
                chatVc.ID = self.cid
        }
        
    }
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.cid = self.matchList[indexPath.row].employeeId
        self.cname = self.matchList[indexPath.row].employeeName
        self.key = self.matchList[indexPath.row].matchId
        
        Model.instance.checkIfChatExist(id: self.matchList[indexPath.row].matchId) { (answer) in
            if (answer == false)
            {

                let selectedChat = Chat(cid: self.matchList[indexPath.row].employeeId, bid: self.matchList[indexPath.row].jobId, cname: self.matchList[indexPath.row].employeeName, bname: self.matchList[indexPath.row].jobName,key: self.matchList[indexPath.row].matchId)
                Model.instance.saveChat(chat: selectedChat, callback: { (answer) in
                    if(answer == false)
                    {
                        print("save chat completed")
                    }
                    else
                    {
                        print("save chat failed")
                    }
                })
                self.performSegue(withIdentifier: "EmployeeChatSegue", sender: selectedChat)
            }
            else{
                let selectedChat = Chat(cid: self.matchList[indexPath.row].employeeId, bid: self.matchList[indexPath.row].jobId, cname: self.matchList[indexPath.row].employeeName, bname: self.matchList[indexPath.row].jobName,key:self.matchList[indexPath.row].matchId)
                self.performSegue(withIdentifier: "EmployeeChatSegue", sender: selectedChat)
            }
            //self.performSegue(withIdentifier: "chatSegue", sender: nil)
        }
            
        
    }

   /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.chatkey = chat.key
            chatVc.displayName = chat.cname
            chatVc.ID = chat.cid
        }
    }*/
    
}

/*
print("chat doesn't exist")
let cref=self.ref.child("chats").childByAutoId()

let chatItem = [
    "cname":self.cname,
    "cid":Auth.auth().currentUser?.uid,
    "bname":self.businessData[indexPath.row].name,
    "bid":self.businessData[indexPath.row].key
]

// 3
chat_key=cref.key
cref.setValue(chatItem)
*/

