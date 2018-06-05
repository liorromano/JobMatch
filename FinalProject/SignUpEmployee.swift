//
//  SignUpEmployee.swift
//  FinalProject
//
//  Created by admin on 01/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class SignUpEmployee: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //var spinner: UIActivityIndicatorView?
    var imageUrl:String?
    var selectedImage:UIImage?
    var checkIfExist:String?
    
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
    
    //Employee image
    @IBOutlet weak var employeeImage: UIImageView!
    
    //Employee details
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var languages: UITextField!
    @IBOutlet weak var move: UITextField!
    @IBOutlet weak var profession: UITextField!
    @IBOutlet weak var workExperience: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var placeWork: UITextField!
    
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var workHours: UITextField!
    @IBOutlet weak var availability: UITextField!
    //scroll view
    @IBOutlet weak var SignUpScrollView: UIScrollView!
    @IBOutlet weak var SignUpContentView: UIView!
    
    //reset default size
    var SignUpScrollViewHeight : CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //round ava
        employeeImage.layer.cornerRadius = employeeImage.frame.size.width / 2
        employeeImage.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(SignUpEmployee.loadImg))
        avaTap.numberOfTapsRequired = 1
        employeeImage.isUserInteractionEnabled = true
        employeeImage.addGestureRecognizer(avaTap)
        
        //create picker
        jobPicker = UIPickerView()
        jobPicker.tag = 1
        jobPicker.dataSource = self
        jobPicker.delegate = self
        jobPicker.backgroundColor = UIColor.groupTableViewBackground
        jobPicker.showsSelectionIndicator = true
        profession.inputView = jobPicker
        
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
        
        //create picker
        agePicker = UIPickerView()
        agePicker.tag = 10
        agePicker.dataSource = self
        agePicker.delegate = self
        agePicker.backgroundColor = UIColor.groupTableViewBackground
        agePicker.showsSelectionIndicator = true
        age.inputView = agePicker
        
        //create picker
        genderPicker = UIPickerView()
        genderPicker.tag = 11
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        gender.inputView = genderPicker
        
        
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
        self.employeeImage.image = selectedImage
        self.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signUpClick(_ sender: Any) {
        if (email.text!.isEmpty || fullName.text!.isEmpty || password.text!.isEmpty || confirmPassword.text!.isEmpty || salary.text!.isEmpty || placeWork.text!.isEmpty || education.text!.isEmpty || age.text!.isEmpty || workExperience.text!.isEmpty || profession.text!.isEmpty || move.text!.isEmpty || languages.text!.isEmpty || gender.text!.isEmpty || workHours.text!.isEmpty || availability.text!.isEmpty) {
            
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
                        Model.instance.saveImageEmployee(image: image, name: self.email.text!){(url) in
                            self.imageUrl = url
                            
                            
                            let employee = Employee(userName:self.email.text!, fullName:self.fullName.text!, imageUrl:self.imageUrl, gender:self.gender.text!, languages:self.languages.text!, move:self.move.text!, profession:self.profession.text!,workExprience:self.workExperience.text!,age:self.age.text!,education:self.education.text!,placeWork:self.placeWork.text!,salary:self.salary.text!, workHours: self.workHours.text!, availability: self.availability.text!)
                            
                            Model.instance.addEmployee(employee: employee, password: self.password.text!, email: self.email.text!)
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
                        
                        /*let employee = Employee(userName:self.email.text!, fullName:self.fullName.text!, imageUrl:self.imageUrl, gender:self.gender.text!, languages:self.languages.text!, move:self.move.text!, profession:self.profession.text!,workExprience:self.workExperience.text!,age:self.age.text!,education:self.education.text!,placeWork:self.placeWork.text!,salary:self.salary.text!, workHours: self.workHours.text!, availability: self.availability.text!)
                         Model.instance.addEmployee(employee: employee, password: self.password.text!, email: self.email.text!)
                         //self.spinner?.stopAnimating()
                         alert.close()
                         self.resetForm()
                         //self.alerts(writeTitle: "Confirmation", writeMessage: "new user was added")
                         //self.performSegue(withIdentifier: "employeeAfterSignUpSegue", sender: nil)
                         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                         let newViewController = storyBoard.instantiateViewController(withIdentifier: "start")
                         self.present(newViewController, animated: true, completion: nil)*/
                        alert.close()
                        self.alerts(writeTitle: "Error", writeMessage: "please insert picture")
                    }
                }
                else if(self.checkIfExist?.compare("not avail") == ComparisonResult.orderedSame){
                    alert.close()
                    self.alerts(writeTitle: "Error", writeMessage: "email already taken")
                }
                
            })
            
        }
    }
    
    @IBAction func cacnelButton(_ sender: Any) {
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
        self.employeeImage.image = UIImage(named: "UserPicture")
        self.languages.text = nil
        self.move.text = nil
        self.profession.text = nil
        self.workExperience.text = nil
        self.age.text = nil
        self.education.text = nil
        self.placeWork.text = nil
        self.salary.text = nil
        self.password.text = nil
        self.confirmPassword.text = nil
        self.email.text = nil
        self.fullName.text = nil
        self.gender.text = nil
        self.availability.text = nil
        self.workHours.text = nil
        
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
            profession.text = jobsType[row]
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
        if(pickerView.tag == 10)
        {
            age.text = ageType[row]
            self.view.endEditing(true)
            
        }
        if(pickerView.tag == 11)
        {
            gender.text = genderType[row]
            self.view.endEditing(true)
            
        }
        
        
    }
    
}
