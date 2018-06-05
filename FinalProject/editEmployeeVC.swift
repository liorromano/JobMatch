//
//  editEmployeeVC.swift
//  FinalProject
//
//  Created by Noi Gilad on 29/03/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class editEmployeeVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

 
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
    
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var fullNameLabel: UITextField!
    @IBOutlet weak var professionLabel: UITextField!
    @IBOutlet weak var workExprienceLabel: UITextField!
    @IBOutlet weak var areaOfWorkLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var educationLabel: UITextField!
   
    @IBOutlet weak var workHours: UITextField!
    @IBOutlet weak var availability: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var languagesLabel: UITextField!
    @IBOutlet weak var transportLabel: UITextField!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    var selectedImage:UIImage?
    
    var spinner: UIActivityIndicatorView?
    

    
    override func viewDidLoad() {
        
        
            print("view did load")
            super.viewDidLoad()
            
            //round ava
            self.image.layer.cornerRadius = self.image.frame.size.width / 2
            self.image.clipsToBounds = true
            
            //declare select image tap
            let avaTap = UITapGestureRecognizer(target: self, action: #selector(SignUpEmployee.loadImg))
            avaTap.numberOfTapsRequired = 1
            self.image.isUserInteractionEnabled = true
            self.image.addGestureRecognizer(avaTap)
            

        
        //create picker
        jobPicker = UIPickerView()
        jobPicker.tag = 1
        jobPicker.dataSource = self
        jobPicker.delegate = self
        jobPicker.backgroundColor = UIColor.groupTableViewBackground
        jobPicker.showsSelectionIndicator = true
        professionLabel.inputView = jobPicker
        
        //create picker
        countryPicker = UIPickerView()
        countryPicker.tag = 2
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.backgroundColor = UIColor.groupTableViewBackground
        countryPicker.showsSelectionIndicator = true
        areaOfWorkLabel.inputView = countryPicker
        
        //create picker
        languagesPicker = UIPickerView()
        languagesPicker.tag = 3
        languagesPicker.dataSource = self
        languagesPicker.delegate = self
        languagesPicker.backgroundColor = UIColor.groupTableViewBackground
        languagesPicker.showsSelectionIndicator = true
        languagesLabel.inputView = languagesPicker
        
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
        transportLabel.inputView = yesNoPicker
        
        //create picker
        workExperiencePicker = UIPickerView()
        workExperiencePicker.tag = 7
        workExperiencePicker.dataSource = self
        workExperiencePicker.delegate = self
        workExperiencePicker.backgroundColor = UIColor.groupTableViewBackground
        workExperiencePicker.showsSelectionIndicator = true
        workExprienceLabel.inputView = workExperiencePicker
        
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
        educationLabel.inputView = educationPicker
        
        //create picker
        agePicker = UIPickerView()
        agePicker.tag = 10
        agePicker.dataSource = self
        agePicker.delegate = self
        agePicker.backgroundColor = UIColor.groupTableViewBackground
        agePicker.showsSelectionIndicator = true
        ageLabel.inputView = agePicker
        
        //create picker
        genderPicker = UIPickerView()
        genderPicker.tag = 11
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        gender.inputView = genderPicker
        
        

            
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
            
        
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }

    
    
    public func initiliaze()
    {   print("initiliaze")
        self.spinner?.startAnimating()
        Model.instance.loggedIn { (uID) in
            if(uID != nil)
            {   print("uid ok")
                Model.instance.getEmployeeById (id: uID!, callback: { (user) in
                    
                    if(user?.imageUrl != nil)
                    {
                        Model.instance.getImageEmployee (urlStr: (user?.imageUrl)!, callback: { (imageEmployee) in
                            
                            
                            self.image.image = imageEmployee
                            self.fullNameLabel.text?.append((user?.fullName)!)
                            self.professionLabel.text?.append((user?.profession)!)
                            self.workExprienceLabel.text?.append((user?.workExperience)!)
                            self.areaOfWorkLabel.text?.append((user?.placeWork)!)
                            self.ageLabel.text?.append((user?.age)!)
                            self.educationLabel.text?.append((user?.education)!)
                            self.salary.text?.append((user?.salary)!)
                            self.languagesLabel.text?.append((user?.languages)!)
                            self.transportLabel.text?.append((user?.move)!)
                            self.availability.text?.append((user?.availability)!)
                            self.workHours.text?.append((user?.workHours)!)
                            self.gender.text?.append((user?.gender)!)
                            
                            self.spinner?.stopAnimating()
                            super.viewDidLoad()
                        })
                    }
                    else
                    {
                        
                        
                         self.fullNameLabel.text = user?.fullName
                         self.professionLabel.text = user?.profession
                         self.workExprienceLabel.text = user?.workExperience
                         self.areaOfWorkLabel.text = user?.placeWork
                         self.ageLabel.text = user?.age
                         self.educationLabel.text = user?.education
                         self.salary.text = user?.salary
                         self.languagesLabel.text = user?.languages
                         self.transportLabel.text = user?.move
                        self.availability.text?.append((user?.availability)!)
                        self.workHours.text?.append((user?.workHours)!)
                        self.gender.text?.append((user?.gender)!)
                        
                        self.spinner?.stopAnimating()
                        super.viewDidLoad()
                    }
                })
            }
        }
        
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
        self.image.image = selectedImage
        self.dismiss(animated: true, completion: nil);
    }
    
    
    //alert message function
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
    
    
    
    //clicked save button
    @IBAction func save_Clicked(_ sender: Any) {
        spinner?.startAnimating()
        if ( fullNameLabel.text!.isEmpty || professionLabel.text!.isEmpty || workExprienceLabel.text!.isEmpty || areaOfWorkLabel.text!.isEmpty || ageLabel.text!.isEmpty || educationLabel.text!.isEmpty || salary.text!.isEmpty || languagesLabel.text!.isEmpty || transportLabel.text!.isEmpty || availability.text!.isEmpty || workHours.text!.isEmpty || (gender.text?.isEmpty)!) {
            
            //show alert massage
            alert(error: "Please", message: "fill in fields")
            spinner?.stopAnimating()
        }
        else{
            //get the user data with connection to firebase
            Model.instance.loggedIn(callback: { (uID) in
                
                Model.instance.getEmployeeById(id:uID! ) { (user) in
                    if let image = self.selectedImage{
                        Model.instance.saveImageEmployee(image: image, name: (user?.userName)!){(url) in
                            if(url != nil)
                            {
                                user?.imageUrl = url
                                
                                if(self.fullNameLabel.text != user?.fullName)
                                {
                                    user?.fullName = self.fullNameLabel.text!
                                }
                                if(self.salary.text != user?.salary)
                                {
                                    user?.salary = self.salary.text!
                                }
                                if(self.educationLabel.text != user?.education)
                                {
                                    user?.education = self.educationLabel.text!
                                }
                                if(self.areaOfWorkLabel.text != user?.placeWork)
                                {
                                    user?.placeWork = self.areaOfWorkLabel.text!
                                }
                                if(self.ageLabel.text != user?.age)
                                {
                                    user?.age = self.ageLabel.text!
                                }
                                if(self.workExprienceLabel.text != user?.workExperience)
                                {
                                    user?.workExperience = self.workExprienceLabel.text!
                                }
                                if(self.professionLabel.text != user?.profession)
                                {
                                    user?.profession = self.professionLabel.text!
                                }
                                if(self.transportLabel.text != user?.move)
                                {
                                    user?.move = self.transportLabel.text!
                                }
                                if(self.languagesLabel.text != user?.languages)
                                {
                                    user?.languages = self.languagesLabel.text!
                                }
                                if(self.availability.text != user?.availability)
                                {
                                    user?.availability = self.availability.text!
                                }
                                if(self.workHours.text != user?.workHours)
                                {
                                    user?.workHours = self.workHours.text!
                                }
                                if(self.gender.text != user?.gender)
                                {
                                    user?.gender = self.gender.text!
                                }
                                
                                Model.instance.updateEmployee(employee: user!, callback: { (answer) in
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
                    else
                    {
                        if(self.fullNameLabel.text != user?.fullName)
                        {
                            user?.fullName = self.fullNameLabel.text!
                        }
                        if(self.salary.text != user?.salary)
                        {
                            user?.salary = self.salary.text!
                        }
                        if(self.educationLabel.text != user?.education)
                        {
                            user?.education = self.educationLabel.text!
                        }
                        if(self.areaOfWorkLabel.text != user?.placeWork)
                        {
                            user?.placeWork = self.areaOfWorkLabel.text!
                        }
                        if(self.ageLabel.text != user?.age)
                        {
                            user?.age = self.ageLabel.text!
                        }
                        if(self.workExprienceLabel.text != user?.workExperience)
                        {
                            user?.workExperience = self.workExprienceLabel.text!
                        }
                        if(self.professionLabel.text != user?.profession)
                        {
                            user?.profession = self.professionLabel.text!
                        }
                        if(self.transportLabel.text != user?.move)
                        {
                            user?.move = self.transportLabel.text!
                        }
                        if(self.languagesLabel.text != user?.languages)
                        {
                            user?.languages = self.languagesLabel.text!
                        }
                        if(self.availability.text != user?.availability)
                        {
                            user?.availability = self.availability.text!
                        }
                        if(self.workHours.text != user?.workHours)
                        {
                            user?.workHours = self.workHours.text!
                        }
                        if(self.gender.text != user?.gender)
                        {
                            user?.gender = self.gender.text!
                        }
                        
                        Model.instance.updateEmployee(employee: user!, callback: { (answer) in
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
            })
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
        if(pickerView.tag == 10)
        {
            return ageType.count
        }
        if(pickerView.tag == 11)
        {
            return genderType.count
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
        if(pickerView.tag == 10)
        {
            return ageType[row]
        }
        if(pickerView.tag == 11)
        {
            return genderType[row]
        }
        
        return ""
    }
    //picker did selected the some value from it
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1)
        {
            professionLabel.text = jobsType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 2)
        {
            areaOfWorkLabel.text = countryType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 3)
        {
            languagesLabel.text = languagesType[row]
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
            transportLabel.text = yesNoType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 7)
        {
            workExprienceLabel.text = workExperienceType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 8)
        {
            workHours.text = workHoursType[row]
            self.view.endEditing(true)
        }
        if(pickerView.tag == 9)
        {
            educationLabel.text = educationType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 10)
        {
            ageLabel.text = ageType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 11)
        {
            gender.text = genderType[row]
            self.view.endEditing(true)
            
        }
        
        
    }


    @IBAction func backClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    

    
   
}

