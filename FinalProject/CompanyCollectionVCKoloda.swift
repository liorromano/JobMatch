//
//  ProfileCollectionVC.swift
//  FinalProject
//
//  Created by Romano on 13/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit


class CompanyCollectionVCKoloda: UICollectionViewController {
    
    
    
    var job:Job?
    
    //refresher variable
    var refresher: UIRefreshControl!
    
    var jobList = [Job]()
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
        
        
       /* ModelNotification.JobList.observe{(list) in
            if(list != nil)
            {
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn(callback: { (uID) in
                    for job in jobs
                    {
                        if((job.uID == uID) && (job.deleted == "false"))
                        {
                            self.jobList.append(job)
                        }
                    }
                    self.spinner?.stopAnimating()
                    self.collectionView?.reloadData()
                })
                
                
            }
        }*/
        
        
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
        
        /*Model.instance.getAllJobsAndObserve {(list) in
            if(list != nil)
            {
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn(callback: { (uID) in
                    for job in jobs
                    {
                        if((job.uID == uID) && (job.deleted == "false"))
                        {
                            self.jobList.append(job)
                        }
                    }
                    self.spinner?.stopAnimating()
                    self.collectionView?.reloadData()
                })
                
                
            }
        }*/
        // Model.instance.getAllFollowsAndObserve()
        
        
    }
    
    
    deinit{
        if (observerId != nil){
            ModelNotification.removeObserver(observer: observerId!)
        }
    }
    
    
    func postsListDidUpdate(notification:NSNotification){
        self.jobList = notification.userInfo?["job"] as! [Job]
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.collectionView?.reloadData()
        Model.instance.getAllJobsAndObserve {(list) in
            if(list != nil)
            {
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn(callback: { (uID) in
                    for job in jobs
                    {
                        if((job.uID == uID) && (job.deleted == "false"))
                        {
                            self.jobList.append(job)
                        }
                    }
                    self.spinner?.stopAnimating()
                    self.collectionView?.reloadData()
                })
                
                
            }
        }
        
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
        return self.jobList.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! PictureCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = UIColor(red: 0.4902, green: 0.698, blue: 0.8314, alpha: 1.0)
        cell.layer.borderColor = borderColor.cgColor

        Model.instance.getImageJob(urlStr: self.jobList[indexPath.row].imageUrl, callback: { (image) in
            cell.picturePost.image = image
            cell.JobNameLbl.text = self.jobList[indexPath.row].jobName
        })
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "JobListKolodaSegue"
        {
            let vc = segue.destination as? CompanyKolodaViewController
            vc?.job = self.job
        }
        
    }
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        job = self.jobList[indexPath.row]
        self.performSegue(withIdentifier: "JobListKolodaSegue", sender: nil)
    }
    
    
}




