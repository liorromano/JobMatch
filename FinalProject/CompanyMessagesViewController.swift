//
//  CompanyMessagesViewController.swift
//  FinalProject
//
//  Created by Romano on 07/05/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit


class CompanyMessagesViewController: UICollectionViewController {
    
    
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
                        if((match.companyId == uID) && (match.deleted == "false"))
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
        //Model.instance.getAllJobsAndObserve()
        
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
        Model.instance.getEmployeeById(id: matchList[indexPath.row].employeeId) { (employee) in
            Model.instance.getImageEmployee(urlStr: (employee?.imageUrl)!, callback: { (image) in
                cell.picturePost.image = image
                cell.fullName.text = employee?.fullName
                cell.JobNameLbl.text = self.matchList[indexPath.row].jobName
                cell.date.text = self.matchList[indexPath.row].lastUpdate?.stringValue
            })
        }
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "CompanyChatSegue"
        {
            let chatVc = segue.destination as! ChatViewController
            chatVc.chatkey = self.key
            chatVc.displayName = self.cname
            chatVc.ID = self.cid
        }
        
    }
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Model.instance.getCompanyById(id: self.matchList[indexPath.row].companyId) { (company) in
            self.cid = self.matchList[indexPath.row].companyId
            self.cname = company?.companyName
            self.key = self.matchList[indexPath.row].matchId
        }

        Model.instance.checkIfChatExist(id: self.matchList[indexPath.row].matchId) { (answer) in
            if (answer == false)
            {
                
                let selectedChat = Chat(cid: self.matchList[indexPath.row].jobId, bid: self.matchList[indexPath.row].employeeId, cname: self.matchList[indexPath.row].jobName, bname: self.matchList[indexPath.row].employeeName,key: self.matchList[indexPath.row].matchId)
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
                self.performSegue(withIdentifier: "CompanyChatSegue", sender: selectedChat)
            }
            else{
               let selectedChat = Chat(cid: self.matchList[indexPath.row].jobId, bid: self.matchList[indexPath.row].employeeId, cname: self.matchList[indexPath.row].jobName, bname: self.matchList[indexPath.row].employeeName,key: self.matchList[indexPath.row].matchId)
                self.performSegue(withIdentifier: "CompanyChatSegue", sender: selectedChat)
            }
            
        }
        
        
    }
    
}
