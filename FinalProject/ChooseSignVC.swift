//
//  ChooseSignVC.swift
//  FinalProject
//
//  Created by admin on 01/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit

class ChooseSignVC: UIViewController {
    
    @IBOutlet weak var signUpEmployee: UIImageView!
    @IBOutlet weak var signUpCompany: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        signUpCompany.tag = 1
        signUpEmployee.tag = 2
        
        let employeeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        signUpEmployee.isUserInteractionEnabled = true
        signUpEmployee.addGestureRecognizer(employeeGestureRecognizer)
        
        let companyGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        signUpCompany.isUserInteractionEnabled = true
        signUpCompany.addGestureRecognizer(companyGestureRecognizer)
        
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(tappedImage.tag == 1)
        {
            self.performSegue(withIdentifier: "signUpCompanySegue", sender: nil)
        }
        else if(tappedImage.tag == 2)
        {
            self.performSegue(withIdentifier: "signUpEmployeeSegue", sender: nil)
        }

    }
    
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
