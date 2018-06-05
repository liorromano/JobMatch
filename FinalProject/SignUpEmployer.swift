//
//  SignUpEmployer.swift
//  FinalProject
//
//  Created by admin on 01/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class SignUpEmployer: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   // var spinner: UIActivityIndicatorView?
    var imageUrl:String?
    var selectedImage:UIImage?
    var checkIfExist:String?
    
    //Employer details

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var comapnyLocation: UITextField!
    @IBOutlet weak var comapnyName: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    
    //Employer image
    @IBOutlet weak var employerImage: UIImageView!
    
    //scroll view
    @IBOutlet weak var SignUpScrollView: UIScrollView!
    @IBOutlet weak var SignUpContentView: UIView!
    
    //reset default size
    var SignUpScrollViewHeight : CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*//spinner configuration
        spinner = UIActivityIndicatorView()
        spinner?.center = self.view.center
        spinner?.hidesWhenStopped = true
        spinner?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(spinner!)*/
        
        
        //round ava
        employerImage.layer.cornerRadius = employerImage.frame.size.width / 2
        employerImage.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(SignUpEmployee.loadImg))
        avaTap.numberOfTapsRequired = 1
        employerImage.isUserInteractionEnabled = true
        employerImage.addGestureRecognizer(avaTap)

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //call picker to select image
    public func loadImg(recognizer: UITapGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.employerImage.image = selectedImage
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        if (email.text!.isEmpty || password.text!.isEmpty || confirmPassword.text!.isEmpty || comapnyName.text!.isEmpty || comapnyLocation.text!.isEmpty || phone.text!.isEmpty) {
            
            //show alert massage
            alerts(writeTitle: "Please", writeMessage: "fill in fields")
        }
        
        if ((password.text!.characters.count) < 6)
        {
            alerts(writeTitle: "Error", writeMessage: "please insert 6 characters password")
        }
        else if(!isValidEmail(testStr: email.text!))
        {
            alerts(writeTitle: "Error", writeMessage: "please insert valid email")
        }
        else if(password.text != confirmPassword.text)
        {
            //show alert massage
            alerts(writeTitle: "Error", writeMessage: "passwords are not the same")
        }
        else
        {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "we sign you up...", colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)
            //self.spinner?.startAnimating()
            
            Model.instance.checkIfUserExist(email: email.text!, callback: { (answer) in
                self.checkIfExist = answer
                if (self.checkIfExist?.compare("avail") == ComparisonResult.orderedSame) {
                    if let image = self.selectedImage{
                        Model.instance.saveImageCompany(image: image, name: self.comapnyName.text!){(url) in
                            self.imageUrl = url
                            let company = Company(companyName: self.comapnyName.text!,companyLocation: self.comapnyLocation.text!,companyPhone: self.phone.text!, companyEmail: self.email.text!, imageUrl: self.imageUrl)
                            Model.instance.addCompany(company: company, password: self.password.text!, email: self.email.text!)
                            //self.spinner?.stopAnimating()
                            alert.close()
                            self.resetForm()
                            //self.alerts(writeTitle: "Confirmation", writeMessage: "new user was added")
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "start")
                            self.present(newViewController, animated: true, completion: nil)

                        }
                    }
                        
                    else{
                        /*let company = Company(companyName: self.comapnyName.text!,companyLocation: self.comapnyLocation.text!,companyPhone: self.phone.text!, companyEmail: self.email.text!)
                        Model.instance.addCompany(company: company, password: self.password.text!, email: self.email.text!)
                        //self.spinner?.stopAnimating()
                        alert.close()
                        self.resetForm()
                        //self.alerts(writeTitle: "Confirmation", writeMessage: "new user was added")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "start")
                        self.present(newViewController, animated: true, completion: nil)*/
                        alert.close()
                        self.alerts(writeTitle: "Error", writeMessage: "please insert picture")

                    }
                }
                else if(self.checkIfExist?.compare("not avail") == ComparisonResult.orderedSame){
                   // self.spinner?.stopAnimating()
                    alert.close()
                    self.alerts(writeTitle: "Error", writeMessage: "email already taken")
                }
                
            })
            
        }

    }
        
        
       
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func resetForm()
    {
        self.employerImage.image = UIImage(named: "UserPicture")
        self.password.text = nil
        self.confirmPassword.text = nil
        self.email.text = nil
        self.comapnyLocation.text = nil
        self.comapnyName.text = nil
        self.phone.text = nil
    }


}
