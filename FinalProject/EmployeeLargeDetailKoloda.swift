//
//  EmployeeLargeDetailKoloda.swift
//  FinalProject
//
//  Created by Romano on 27/04/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit

class EmployeeLargeDetailKoloda: UIViewController, UINavigationControllerDelegate {
    
    
    var employee: Employee?
    
    //profile picture
    @IBOutlet weak var profilePicture: UIImageView!
    //profile details labels
    @IBOutlet weak var workExperience: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var transport: UILabel!
    @IBOutlet weak var languages: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var areaOfWork: UILabel!
    @IBOutlet weak var education: UILabel!
   

    @IBOutlet weak var workHours: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var fullName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.clipsToBounds = true
        
        initiliaze()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func initiliaze(){
        
                self.workExperience.text = employee?.workExperience
                self.profession.text = employee?.profession
                self.transport.text = employee?.move
                self.languages.text = employee?.languages
                self.age.text = employee?.age
                self.gender.text = employee?.gender
                self.areaOfWork.text = employee?.placeWork
                self.education.text = employee?.education
                self.workHours.text = employee?.workHours
                self.availability.text = employee?.availability
                self.email.text = employee?.userName
                self.fullName.text = employee?.fullName
                if (employee?.imageUrl != nil)
                {
                    Model.instance.getImageEmployee(urlStr: (employee?.imageUrl)!, callback: { (image) in
                        self.profilePicture.image = image
                    })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initiliaze()
    }
    
}

