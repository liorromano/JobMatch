//
//  editVC.swift
//  FinalProject
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit

class editCompanyVC: UIViewController ,UIPickerViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var spinner: UIActivityIndicatorView?
    var company: Company?
    
    //UI objects
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    //button
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //pickerView & pickerData
    
    var selectedImage:UIImage?
    
    
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        
        //round ava
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
        self.imageProfile.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(SignUpEmployee.loadImg))
        avaTap.numberOfTapsRequired = 1
        self.imageProfile.isUserInteractionEnabled = true
        self.imageProfile.addGestureRecognizer(avaTap)

        
        
        
        //spinner configuration
        spinner = UIActivityIndicatorView()
        spinner?.center = self.view.center
        spinner?.hidesWhenStopped = true
        spinner?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(spinner!)
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        initiliaze()
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    func alerts(writeTitle: String, writeMessage: String)
    {
        let alert = UIAlertController(title: writeTitle, message: writeMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    public func initiliaze()
    {   print("initiliaze")
        self.spinner?.startAnimating()
        Model.instance.loggedIn(callback: { (uID) in
            if(uID != nil)
            {   print("uid ok")
                Model.instance.getCompanyById(id: uID!, callback: { (company) in
                    self.company = company!
                    if(company != nil){
                        Model.instance.getImageCompany(urlStr: (company?.imageUrl)!, callback: { (image) in
                            if (image != nil)
                            {
                                self.imageProfile.image = image
                                self.companyName.text = company?.companyName
                                self.address.text = company?.companyLocation
                                self.phone.text = company?.companyPhone
                                self.spinner?.stopAnimating()
                            }
                        })
                        
                    }
                    else
                    {
                        //self.initParamtersEmployer(user)
                    }
                    
                })
            }
            
        })
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
        self.imageProfile.image = selectedImage
        self.dismiss(animated: true, completion: nil);
    }
    
    
    //alert message function
    func alert(error: String, message: String){
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert,animated: true, completion: nil)
    }
    
    
    
    @IBAction func back_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    //clicked save button
    @IBAction func save_Clicked(_ sender: Any) {
        spinner?.startAnimating()
        if ( companyName.text!.isEmpty || address.text!.isEmpty || phone.text!.isEmpty ) {
            
            //show alert massage
            alerts(writeTitle: "Please", writeMessage: "fill in fields")
            spinner?.stopAnimating()
        }
        else{
            if let image = self.selectedImage{
                Model.instance.saveImageCompany(image: image, name: (company?.companyName)!, callback: { (url) in
                    if(url != nil)
                    {
                        self.company?.imageUrl = url!
                        self.company?.companyName = self.companyName.text!
                        
                        self.company?.companyLocation = self.address.text!
                        
                        self.company?.companyPhone = self.phone.text!
                        
                        Model.instance.updateCompany(company: self.company!, callback: { (answer) in
                            if(answer == false)
                            {
                                self.spinner?.stopAnimating()
                                self.alert(error: "Error", message: "Can't save parameters")
                            }
                            else
                            {
                                self.spinner?.stopAnimating()
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                        
                    }
                    else
                    {
                        self.alert(error: "Error", message: "Can't save picture")
                    }
                })
            }
            else{
                
                self.company?.companyName = self.companyName.text!
                
                self.company?.companyLocation = self.address.text!
                
                self.company?.companyPhone = self.phone.text!
                
                
                Model.instance.updateCompany(company: self.company!, callback: { (answer) in
                    if(answer == false)
                    {
                        self.spinner?.stopAnimating()
                        self.alert(error: "Error", message: "Can't save parameters")
                    }
                    else
                    {
                        self.spinner?.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
                
            }
        }
    }
}
