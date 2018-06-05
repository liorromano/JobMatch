//
//  profile.swift
//  FinalProject
//
//  Created by Koral Shmueli on 04/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit

class employeeProfile: UIViewController, UINavigationControllerDelegate {

    
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
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var fullName: UILabel!

    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
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
        
        Model.instance.loggedIn { (employeeID) in
            Model.instance.getEmployeeById(id: employeeID!, callback: { (employee) in
                self.workExperience.text = employee?.workExperience
                self.profession.text = employee?.profession
                self.transport.text = employee?.move
                self.languages.text = employee?.languages
                self.age.text = employee?.age
                self.gender.text = employee?.gender
                self.areaOfWork.text = employee?.placeWork
                self.education.text = employee?.education
                self.salary.text = employee?.salary
                self.email.text = employee?.userName
                self.fullName.text = employee?.fullName
                self.workHours.text = employee?.workHours
                self.availability.text = employee?.availability
                if (employee?.imageUrl != nil)
                {
                    Model.instance.getImageEmployee(urlStr: (employee?.imageUrl)!, callback: { (image) in
                        self.profilePicture.image = image
                    })
                }
                
            })
        }
        
    }
    
    @IBAction func logoutBtn_clicked(_ sender: Any) {
        Model.instance.logOut { (ans) in
            if(ans == true)
            {
                print ("logged out")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                self.present(newViewController, animated: true, completion: nil)
            }
            else{
                print("not logged out")
              
                let alert = UIAlertController(title: "Error", message: "Can not logout", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initiliaze()
    }

}
