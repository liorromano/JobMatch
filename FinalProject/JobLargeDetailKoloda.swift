//
//  JobLargeDetailKoloda.swift
//  FinalProject
//
//  Created by Romano on 27/04/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class JobLargeDetailKoloda: UIViewController {
    
        @IBOutlet weak var picImage: UIImageView!
        
    
    @IBOutlet weak var jobTitle: UILabel!
        
        @IBOutlet weak var hourTxt: UILabel!
        
        @IBOutlet weak var addressTxt: UILabel!
        
        @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var experience: UILabel!
    @IBOutlet weak var transport: UILabel!
    
    @IBOutlet weak var languages: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var salary: UILabel!
        
    @IBOutlet weak var education: UILabel!
        @IBOutlet weak var jobTypeTxt: UILabel!
        
        
        
        var job: Job?

        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.picImage.layer.cornerRadius = self.picImage.frame.size.width / 2
            self.picImage.clipsToBounds = true
            
            initiliaze()

            
        }

        
        //hide keyboard function
        func hideKeyboardTap() {
            self.view.endEditing(true)
        }
    
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        public func initiliaze()
        {   print("initiliaze")
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "initializing...", colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)
            Model.instance.getImageJob(urlStr: (self.job?.imageUrl)!) { (image) in
                self.picImage.image = image
                self.jobTitle.text = self.job?.jobName
                self.hourTxt.text = self.job?.hours
                self.addressTxt.text = self.job?.jobLocation
                self.descriptionTxt.text = self.job?.description
                self.experience.text = self.job?.workExperience
                self.transport.text = self.job?.move
                self.languages.text = self.job?.languages
                self.availability.text = self.job?.availability
                self.salary.text = self.job?.salary
                self.education.text = self.job?.education
                self.jobTypeTxt.text = self.job?.jobType
                alert.close()
                super.viewDidLoad()
            }
            
        }
    
}

