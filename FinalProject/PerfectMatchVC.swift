//
//  PerfectMatchVC.swift
//  FinalProject
//
//  Created by Romano on 15/05/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class PerfectMatchVC: UIViewController {
    
    
    @IBOutlet weak var imageBtn: UIButton!

    //spinner configuration
    
    var perfectMatch:[Employee?]?
    var observerId:Any?
    var jobList = [Job]()
    var employeeList = [Employee]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert1 = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "", colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)
        let alert2 = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "", colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)
        
       /* ModelNotification.JobList.observe{(list) in
            if(list != nil)
            {
                
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn { (uid) in
                    for job in jobs
                    {
                        if ((job.uID == uid) && (job.deleted != "true"))
                        {
                            self.jobList.append(job)
                        }
                        
                    }
                    
                }
                
            }
            alert1.close()
            /*let alert3 = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "",duration: 10.0, colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)*/
        }*/
        
        /*ModelNotification.EmployeeList.observe{(list) in
            if(list != nil)
            {
                self.employeeList = list! as [Employee]
                
            }
            alert2.close()
            /*let alert4 = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "",duration: 10.0, colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)*/
        }*/
        
        Model.instance.getAllJobsAndObserve {(list) in
            if(list != nil)
            {
                
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn { (uid) in
                    for job in jobs
                    {
                        if ((job.uID == uid) && (job.deleted != "true"))
                        {
                            self.jobList.append(job)
                        }
                        
                    }
                    
                }
                
            }
            alert1.close()
            /*let alert3 = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "",duration: 10.0, colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)*/
        }
        
        Model.instance.getAllEmployeesAndObserve { (list) in
            if(list != nil)
            {
                self.employeeList = list! as [Employee]
                
            }
            alert2.close()
        }
        
    }
    
    
    deinit{
        if (observerId != nil){
            ModelNotification.removeObserver(observer: observerId!)
        }
    }
    
    func ListDidUpdate(notification:NSNotification){
        //self.employeeList = notification.userInfo?["employee"] as! [Employee]
        self.jobList = notification.userInfo?["job"] as! [Job]
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "perfectMatchCollectionSegue"
        {
         
            let vc = segue.destination as? PerfectMatchCollectionVC
            vc?.perfectMatch = perfectMatch!
        }
        
    }
    
    @IBAction func imageBtn_Clicked(_ sender: Any) {
        
        let genethic = GenthicAlgorithem()
        genethic.runGeneticAlgorithm(jobs: jobList, employees: employeeList) { (employees) in
            self.perfectMatch = employees
            self.performSegue(withIdentifier: "perfectMatchCollectionSegue", sender: nil)
            
        }

        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
