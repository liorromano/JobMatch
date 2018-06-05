//
//  ProfileCollectionVC.swift
//  FinalProject
//
//  Created by Romano on 13/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit


class CompanyCollectionVC: UICollectionViewController {
    
    
    @IBOutlet weak var LogoutBtn: UIBarButtonItem!
    
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

               
        
        spinner?.startAnimating()
        self.collectionView?.reloadData()
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
            //define haeder
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CompanyProfileHeader", for: indexPath) as! CompanyHeaderVC
        headerView.layer.masksToBounds = true
        headerView.layer.cornerRadius = 5
        headerView.layer.borderWidth = 3
        headerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = UIColor(red: 0.9725, green: 0.9725, blue: 0.9765, alpha: 1.0)
        headerView.layer.borderColor = borderColor.cgColor
            //get the user data with connection to firebase
            Model.instance.loggedIn(callback: { (uID) in
                Model.instance.getCompanyById(id:uID! ) { (user) in
                    headerView.HeaderFullNameLbl.text = user?.companyName
                    headerView.AdressLabel.text = user?.companyLocation
                    headerView.PhoneLabel.text = user?.companyPhone
                    //title at the top of the profile page
                    self.navigationItem.title=user?.companyName
                    if (user?.imageUrl != nil)
                    {
                    Model.instance.getImageCompany(urlStr: (user?.imageUrl)!, callback: { (image) in
                        headerView.HeaderAvaImg.image = image
                    })
                }
                }
               
            })
            self.spinner?.stopAnimating()
            return headerView
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
    
    @IBAction func logOutBtn_clicked(_ sender: Any) {
                spinner?.startAnimating()
               Model.instance.logOut { (ans) in
                if(ans == true)
                {
                    print ("logged out")
                    self.spinner?.stopAnimating()
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(newViewController, animated: true, completion: nil)
                }
                else{
                    print("not logged out")
                    self.spinner?.stopAnimating()
                    let alert = UIAlertController(title: "Error", message: "Can not logout", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "JobDetailSegue"
        {
            let vc = segue.destination as? JobDetail
            vc?.job = self.job
        }
        
    }
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        job = self.jobList[indexPath.row]
        self.performSegue(withIdentifier: "JobDetailSegue", sender: nil)
    }

    
}




