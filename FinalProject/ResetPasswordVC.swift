//
//  ResetPasswordVC.swift
//  FinalProject
//
//  Created by Romano on 07/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class ResetPasswordVC: UIViewController {

    // reset password txt
    @IBOutlet weak var ResetPasswordEmailTxt: UITextField!
    
    //buttons
    @IBOutlet weak var ResetPasswordResetBtn: UIButton!

    @IBOutlet weak var ResetPasswordCancelBtn: UIButton!
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        


    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    //reset password clicked
    @IBAction func resetPassword_click(_ sender: Any) {
        
        //hide keyboard
        self.view.endEditing(true)
        
        //email txt field is empty
        if ResetPasswordEmailTxt.text!.isEmpty
        {
            //show alert massage
            alert(error: "Error", message: "Email field is empty")
        }
        else
        {
            Model.instance.checkEmail(email: ResetPasswordEmailTxt.text!, callback: { (answer) in
                if(answer == true)
                {
                    //show alert massage
                    let alert = UIAlertController(title: "Done", message: "Reset Password email sent", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.ResetPasswordEmailTxt.text = nil
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
        
                    //show alert massage
                    let alert = UIAlertController(title: "Error", message: "wrong email", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        
    }
    func alert(error: String, message: String){
        SCLAlertView().showTitle(
            error, // Title of view
            subTitle: message, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .error, // Styles - see below.
            colorStyle: 0xff4d4d,
            colorTextButton: 0xFFFFFF
        )
        
    }

    // cacnel clicked
    @IBAction func cancelResetPassword_click(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
