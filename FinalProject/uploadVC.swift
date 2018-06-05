//
//  uploadVC.swift
//  FinalProject
//
//  Created by Koral Shmueli on 26/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit
import CoreLocation
import SCLAlertView

class uploadVC: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate,  UINavigationControllerDelegate{
    
    //pickers
    var jobPicker: UIPickerView!
    let jobsType = PickersFile.instance.jobTypes()
    
    var countryPicker: UIPickerView!
    let countryType = PickersFile.instance.getCountryNames()
    
    var languagesPicker: UIPickerView!
    let languagesType = PickersFile.instance.getLanguages()
    
    var salaryPicker: UIPickerView!
    let salaryType = PickersFile.instance.getSalary()
    
    var yesNoPicker: UIPickerView!
    let yesNoType = PickersFile.instance.getYesNo()
    
    var workExperiencePicker: UIPickerView!
    let workExperienceType = PickersFile.instance.getWorkExperience()
    
    var workHoursPicker: UIPickerView!
    let workHoursType = PickersFile.instance.getWorkHours()
    
    var educationPicker: UIPickerView!
    let educationType = PickersFile.instance.getEducation()
    
    var agePicker: UIPickerView!
    let ageType = PickersFile.instance.getAges()
    
    var genderPicker: UIPickerView!
    let genderType = PickersFile.instance.getGender()
    
    @IBOutlet weak var picImage: UIImageView!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var jobType: UITextField!
    @IBOutlet weak var languages: UITextField!
    @IBOutlet weak var move: UITextField!
    @IBOutlet weak var workExperience: UITextField!
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var placeWork: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var workHours: UITextField!
    @IBOutlet weak var availability: UITextField!
    
    
    
    
    var imageUrl:String?
    
    var selectedImage:UIImage?
    
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //function that ask for approval to use location
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
        
        //disable publish button
        //publishButton.isEnabled = false
        //publishButton.backgroundColor = .lightGray
        
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.loadImg))
        avaTap.numberOfTapsRequired = 1
        picImage.isUserInteractionEnabled = true
        picImage.addGestureRecognizer(avaTap)
        
        //create picker
        jobPicker = UIPickerView()
        jobPicker.tag = 1
        jobPicker.dataSource = self
        jobPicker.delegate = self
        jobPicker.backgroundColor = UIColor.groupTableViewBackground
        jobPicker.showsSelectionIndicator = true
        jobType.inputView = jobPicker
        
        //create picker
        countryPicker = UIPickerView()
        countryPicker.tag = 2
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.backgroundColor = UIColor.groupTableViewBackground
        countryPicker.showsSelectionIndicator = true
        placeWork.inputView = countryPicker
        
        //create picker
        languagesPicker = UIPickerView()
        languagesPicker.tag = 3
        languagesPicker.dataSource = self
        languagesPicker.delegate = self
        languagesPicker.backgroundColor = UIColor.groupTableViewBackground
        languagesPicker.showsSelectionIndicator = true
        languages.inputView = languagesPicker
        
        //create picker
        salaryPicker = UIPickerView()
        salaryPicker.tag = 4
        salaryPicker.dataSource = self
        salaryPicker.delegate = self
        salaryPicker.backgroundColor = UIColor.groupTableViewBackground
        salaryPicker.showsSelectionIndicator = true
        salary.inputView = salaryPicker
        
        //create picker
        yesNoPicker = UIPickerView()
        yesNoPicker.tag = 5
        yesNoPicker.dataSource = self
        yesNoPicker.delegate = self
        yesNoPicker.backgroundColor = UIColor.groupTableViewBackground
        yesNoPicker.showsSelectionIndicator = true
        availability.inputView = yesNoPicker
        
        //create picker
        yesNoPicker = UIPickerView()
        yesNoPicker.tag = 6
        yesNoPicker.dataSource = self
        yesNoPicker.delegate = self
        yesNoPicker.backgroundColor = UIColor.groupTableViewBackground
        yesNoPicker.showsSelectionIndicator = true
        move.inputView = yesNoPicker
        
        //create picker
        workExperiencePicker = UIPickerView()
        workExperiencePicker.tag = 7
        workExperiencePicker.dataSource = self
        workExperiencePicker.delegate = self
        workExperiencePicker.backgroundColor = UIColor.groupTableViewBackground
        workExperiencePicker.showsSelectionIndicator = true
        workExperience.inputView = workExperiencePicker
        
        //create picker
        workHoursPicker = UIPickerView()
        workHoursPicker.tag = 8
        workHoursPicker.dataSource = self
        workHoursPicker.delegate = self
        workHoursPicker.backgroundColor = UIColor.groupTableViewBackground
        workHoursPicker.showsSelectionIndicator = true
        workHours.inputView = workHoursPicker
        
        //create picker
        educationPicker = UIPickerView()
        educationPicker.tag = 9
        educationPicker.dataSource = self
        educationPicker.delegate = self
        educationPicker.backgroundColor = UIColor.groupTableViewBackground
        educationPicker.showsSelectionIndicator = true
        education.inputView = educationPicker
        
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
        self.picImage.image = selectedImage
        self.dismiss(animated: true, completion: nil);
        
        //enable publish button
        //publishButton.isEnabled = true
        //publishButton.backgroundColor = UIColor.blue
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //clicked publish button
    @IBAction func publishBtn_clicked(_ sender: Any) {
        
        if (jobTitle.text!.isEmpty || descriptionTxt.text!.isEmpty || jobType.text!.isEmpty || languages.text!.isEmpty || move.text!.isEmpty || workExperience.text!.isEmpty || education.text!.isEmpty || placeWork.text!.isEmpty || salary.text!.isEmpty || workHours.text!.isEmpty || availability.text!.isEmpty) {
            
            //show alert massage
            alerts(writeTitle: "Please", writeMessage: "fill in fields")
        }
            
        else
        {
            if let image = self.selectedImage{
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance).showWait("Wait", subTitle: "we are posting your job...", colorStyle: 0x66b3FF, animationStyle: SCLAnimationStyle.topToBottom)
                
                //spinner?.startAnimating()
                //dissmiss keyboard
                
                self.view.endEditing(true)
                
                
                
                //save the post to firebase
                Model.instance.loggedIn(callback: { (companyID) in
                    Model.instance.getCompanyById(id: companyID!, callback: { (company) in
                        let jobNumber = String((company?.numberOfJobs)!+1)
                        let jobId = (company?.uID?.appending(jobNumber))!
                        Model.instance.saveJobImage(image: image, companyID: companyID!, jobID: jobId, callback: { (url) in
                            self.imageUrl = url
                            let job = Job(JobLocation: self.placeWork.text!, ImageUrl: self.imageUrl!, Hours: self.workHours.text!, Description: self.descriptionTxt.text!, uID: companyID!, jobID: jobId, jobName: self.jobTitle.text!, jobType: self.jobType.text!, companyName: company?.companyName, languages: self.languages.text!, move: self.move.text!, workExperience: self.workExperience.text!, education: self.education.text!, salary: self.salary.text!, availability: self.availability.text!)
                            Model.instance.addNewJob(job: job, callback: { (ans) in
                                if (ans == true)
                                {
                                    company?.numberOfJobs = (company?.numberOfJobs)!+1
                                    Model.instance.updateCompany(company: company!, callback: { (ans) in
                                        if(ans == true)
                                        {
                                            print("true")
                                            self.picImage.image = UIImage(named: "camera")
                                            
                                            self.jobTitle.text = nil
                                            
                                            self.workHours.text = nil
                                            
                                            self.placeWork.text = nil
                                            
                                            self.descriptionTxt.text = nil
                                            
                                            self.jobType.text = nil
                                            
                                            self.languages.text  = nil
                                            self.move.text = nil
                                            self.workExperience.text = nil
                                            self.education.text = nil
                                            self.salary.text = nil
                                            self.availability.text = nil
                                            
                                            //self.publishButton.isEnabled = false
                                            //self.spinner?.stopAnimating()
                                            alert.close()
                                            self.tabBarController!.selectedIndex = 0
                                        }
                                        else
                                        {
                                            //self.spinner?.stopAnimating()
                                            alert.close()
                                            self.alerts(writeTitle: "Error", writeMessage: "can not upload post")
                                        }
                                    })
                                }
                                
                            })
                        })
                        
                        
                    })
                    
                    
                })
            }
            else{
                alerts(writeTitle: "Please", writeMessage: "choose a picture")
            }
        }
    }
    
    
    //picker view methods
    //picker comp numb
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //picker text numb
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1)
        {
            return jobsType.count
        }
        if(pickerView.tag == 2)
        {
            return countryType.count
        }
        if(pickerView.tag == 3)
        {
            return languagesType.count
        }
        if(pickerView.tag == 4)
        {
            return salaryType.count
        }
        if(pickerView.tag == 5)
        {
            return yesNoType.count
        }
        if(pickerView.tag == 6)
        {
            return yesNoType.count
        }
        if(pickerView.tag == 7)
        {
            return workExperienceType.count
        }
        if(pickerView.tag == 8)
        {
            return workHoursType.count
        }
        if(pickerView.tag == 9)
        {
            return educationType.count
        }
        
        return 0
    }
    //picker text config
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1)
        {
            return jobsType[row]
        }
        if(pickerView.tag == 2)
        {
            return countryType[row]
        }
        if(pickerView.tag == 3)
        {
            return languagesType[row]
        }
        if(pickerView.tag == 4)
        {
            return salaryType[row]
        }
        if(pickerView.tag == 5)
        {
            return yesNoType[row]
        }
        if(pickerView.tag == 6)
        {
            return yesNoType[row]
        }
        if(pickerView.tag == 7)
        {
            return workExperienceType[row]
        }
        if(pickerView.tag == 8)
        {
            return workHoursType[row]
        }
        if(pickerView.tag == 9)
        {
            return educationType[row]
        }
        
        
        return ""
    }
    //picker did selected the some value from it
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1)
        {
            jobType.text = jobsType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 2)
        {
            placeWork.text = countryType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 3)
        {
            languages.text = languagesType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 4)
        {
            salary.text = salaryType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 5)
        {
            availability.text = yesNoType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 6)
        {
            move.text = yesNoType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 7)
        {
            workExperience.text = workExperienceType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 8)
        {
            workHours.text = workHoursType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 9)
        {
            education.text = educationType[row]
            self.view.endEditing(true)
            
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
