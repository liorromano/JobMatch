//
//  SignInVC.swift
//  FinalProject
//
//  Created by Romano on 07/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class SignInVC: UIViewController {

    var spinner: UIActivityIndicatorView?
    
    //label
    @IBOutlet weak var SignInLabel: UILabel!
    //text fields
    @IBOutlet weak var SignInUsermaneTxt: UITextField!
    @IBOutlet weak var SignInPasswordTxt: UITextField!
    
    //buttons
    @IBOutlet weak var SignInBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var ForgotPasswordBtn: UIButton!
    
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
    
    //click sign in button
    @IBAction func signInBtn_click(_ sender: Any) {
        print("sign in pressed")
        
        //hide keyboard
        self.view.endEditing(true)
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "we sign you in...", colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)
        
        //self.spinner?.startAnimating()
        
        //if textfields are empty
        if SignInUsermaneTxt.text!.isEmpty || SignInPasswordTxt.text!.isEmpty{
            
                //self.spinner?.stopAnimating()
            
                alert.close()
            
            self.alerts(writeTitle: "Please", writeMessage: "fill in fields")
            
        }
        else
        {
           Model.instance.login(email: SignInUsermaneTxt.text!, password: SignInPasswordTxt.text!, callback: { (answer) in
            if(answer == true)
            {
                print ("autenticated")
                //self.spinner?.stopAnimating()
                alert.close()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "profileChooser")
                self.present(newViewController, animated: true, completion: nil)
            }
            else{
                print("not autenticated")
                //self.spinner?.stopAnimating()
                alert.close()
                
                self.alerts(writeTitle: "Error", writeMessage: "please check email and password")
                
             
            }
           })
            
        }
    }
    
    func alerts(writeTitle: String, writeMessage: String)
    {
        SCLAlertView().showTitle(
            writeTitle, // Title of view
            subTitle: writeMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .error, // Styles - see below.
            colorStyle: 0xff4d4d,
            colorTextButton: 0xFFFFFF
        )
        
    }

}
