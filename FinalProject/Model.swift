//
//  Model.swift
//  FinalProject
//
//  Created by Romano on 18/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//notification
class ModelNotificationBase<T>{
    var name:String?
    
    init(name:String){
        self.name = name
    }
    
    func observe(callback:@escaping (T?)->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(name!), object: nil, queue: nil) { (data) in
            if let data = data.userInfo?["data"] as? T {
                callback(data)
            }
        }
    }
    
    func employee(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
    
    func job(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
    
    func match(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
}

class ModelNotification{
    static let JobList = ModelNotificationBase<[Job]>(name: "JobListNotificatio")
    
    static let EmployeeList = ModelNotificationBase<[Employee]>(name: "EmployeeListNotificatio")
    
    static let MatchList = ModelNotificationBase<[Match]>(name: "MatchListNotificatio")
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
}

class Model{
    static let instance = Model()
    
    lazy private var modelSql:ModelSql? = ModelSql()
    
    private init(){
        
    }
    
    //function that cleans all observes
    func clear(){
        ModelFirebaseJobs.clearObservers()
    }
    
    
    func addCompany(company:Company, password: String, email: String ){
        ModelFirebaseCompany.addNewCompany(company: company, password: password, email: email, completionBlock: { (error) in
            
        })
        
    }
    
    func addEmployee(employee:Employee, password: String, email: String) {
        ModelFirebaseEmployee.addNewEmployee(employee: employee, password: password, email: email, completionBlock: { (error) in
            
        })
    }
    
    //save company profile image
    func saveImageCompany(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        ModelFirebaseCompany.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    //save employee profile image
    func saveImageEmployee(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        ModelFirebaseEmployee.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    //get employer image
    func getImageCompany(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        if(url != nil){
            let localImageName = url!.lastPathComponent
            if let image = self.getImageFromFile(name: localImageName){
                callback(image)
            }else{
                //2. get the image from Firebase
                ModelFirebaseCompany.getImageFromFirebase(url: urlStr, callback: { (image) in
                    if (image != nil){
                        //3. save the image localy
                        self.saveImageToFile(image: image!, name: localImageName)
                    }
                    //4. return the image to the user
                    callback(image)
                })
            }
        }
    }
    
    //get employee image
    func getImageEmployee(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        if(url != nil){
            let localImageName = url!.lastPathComponent
            if let image = self.getImageFromFile(name: localImageName){
                callback(image)
            }else{
                //2. get the image from Firebase
                ModelFirebaseEmployee.getImageFromFirebase(url: urlStr, callback: { (image) in
                    if (image != nil){
                        //3. save the image localy
                        self.saveImageToFile(image: image!, name: localImageName)
                    }
                    //4. return the image to the user
                    callback(image)
                })
            }
        }
    }
    
    
    //save profile image to local db
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    //get profile image from local db
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    
    
    
    func getEmployeeById(id:String, callback:@escaping (Employee?)->Void){
        
        ModelFirebaseEmployee.getEmployeeById(id: id, callback:{ (employee) in
            if(employee != nil)
            {
                callback(employee)
            }
        })
    }
    
    func getCompanyById(id:String, callback:@escaping (Company?)->Void){
        
        ModelFirebaseCompany.getCompanyById(id: id, callback:{ (company) in
            if(company != nil)
            {
                callback(company)
                //"Model--- get employer by id --- not nil")
            }
            else{
                //("Model--- get employer by id --- nil")
                callback(nil)
            }
            
        })
    }
    
    
    //function that gets the job list and update all the observs
    func getAllJobsAndObserve(callback:@escaping ([Job]?)->Void){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Job.JOB_TABLE)
        
        // get all updated records from firebase
        ModelFirebaseJobs.getAllJobsAndObserve(lastUpdateDate, callback: { (jobs) in
            //update the local db
            print("got \(jobs.count) new records from FB")
            var lastUpdate:Date?
            for job in jobs{
                job.addJobToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = job.lastUpdate
                }else{
                    if lastUpdate!.compare(job.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = job.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Job.JOB_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            
            let totalList = Job.getAllJobsFromLocalDb(database: self.modelSql?.database)
            print("\(totalList)")
            
            callback(totalList)
            //ModelNotification.JobList.job(data: totalList)
            
            
        })
    }
    
    
    
    //function that gets the job list and update all the observs
    func getAllEmployeesAndObserve(callback:@escaping ([Employee]?)->Void){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Employee.EMPLOYEE_TABLE)
        
        // get all updated records from firebase
        ModelFirebaseEmployee.getAllEmployeesAndObserve(lastUpdateDate, callback: { (employees) in
            //update the local db
            print("got \(employees.count) new records from FB")
            var lastUpdate:Date?
            for employee in employees{
                employee.addEmployeeToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = employee.lastUpdate
                }else{
                    if lastUpdate!.compare(employee.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = employee.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Employee.EMPLOYEE_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            
            let totalList = Employee.getAllEmployeesFromLocalDb(database: self.modelSql?.database)
            print("\(totalList)")
            
            callback(totalList)
            
            //ModelNotification.EmployeeList.employee(data: totalList)
            
            
        })
    }
    
    //function that gets the job list and update all the observs
    func getAllMatchAndObserve(){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Match.MATCH_TABLE)
        
        // get all updated records from firebase
        ModelFirebase.getAllMatchAndObserve(lastUpdateDate, callback: { (matches) in
            //update the local db
            print("got \(matches.count) new records from FB")
            var lastUpdate:Date?
            for match in matches{
                match.addMatchToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = match.lastUpdate
                }else{
                    if lastUpdate!.compare(match.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = match.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Match.MATCH_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            
            let totalList = Match.getAllMatchFromLocalDb(database: self.modelSql?.database)
            print("\(totalList)")
            
            ModelNotification.MatchList.match(data: totalList)
            
            
        })
    }

    
    
    
    public func checkIfUserExist(email: String, callback:@escaping (String?)->Void)
    {
        var userEmailCheck: String?
        
        ModelFirebase.checkIfExistByEmail(email: email, callback: { (answer) in
            userEmailCheck = answer!
            if(userEmailCheck?.compare("Email exist") == ComparisonResult.orderedSame)
            {
                print("email")
                callback("not avail")
            }
            else
            {
                print("avail")
                callback("avail")
            }
            
        })
    }
    
    public func login(email: String, password: String, callback:@escaping (Bool?)->Void)
    {
        ModelFirebase.authentication(email: email, password: password, callback: { (answer) in
            callback(answer)
        })
    }
    
    
    func loggedIn(callback:@escaping (String?)->Void){
        ModelFirebase.loggedIn(callback: { (ans) in
            callback(ans)
        })
        
    }
    
    func updateEmployee(employee: Employee, callback:@escaping (Bool)->Void)
    {
        ModelFirebaseEmployee.updateEmployee(employee: employee, callback: { (answer) in
            callback (answer)
        })
        
    }
    
    func updateCompany(company: Company, callback:@escaping (Bool)->Void)
    {
        ModelFirebaseCompany.updateCompany(company: company, callback: { (answer) in
            callback (answer)
        })
        
    }
    
    
    
    
    public func checkEmail(email: String, callback:@escaping (Bool?)->Void)
    {
        var userEmailCheck: String?
        ModelFirebase.checkIfExistByEmail(email: email, callback: { (answer) in
            userEmailCheck = answer!
            if(userEmailCheck?.compare("Email exist") == ComparisonResult.orderedSame)
            {
                ModelFirebase.sendResetPassword(email: email)
                callback(true)
            }
            else
            {
                callback(false)
            }
        })
    }
    
    
    
    //logout
    public func logOut(callback:@escaping (Bool?)->Void)
    {
        ModelFirebase.logOut(callback: { (answer) in
            callback(answer)
        })
    }
    
    //add new post
    func addNewJob(job: Job,callback:@escaping (Bool?)->Void){
        
        ModelFirebaseJobs.addNewJob(job: job, callback: { (answer) in
            callback(answer)
        })
        
    }
    
    
    //save image post
    func saveJobImage(image:UIImage, companyID:String,jobID: String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        ModelFirebaseJobs.saveImageToFirebase(image: image, companyID: companyID, jobID: jobID, callback: { (url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: jobID)
            }
            //3. notify the user on complete
            callback(url)
        })
        
    }
    
    
    //get job image
    func getImageJob(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        if(url != nil){
            let localImageName = url!.lastPathComponent
            if let image = self.getImageFromFile(name: localImageName){
                callback(image)
            }else{
                //2. get the image from Firebase
                ModelFirebaseJobs.getImageFromFirebase(url: urlStr, callback: { (image) in
                    if (image != nil){
                        //3. save the image localy
                        self.saveImageToFile(image: image!, name: localImageName)
                    }
                    //4. return the image to the user
                    callback(image)
                })
            }
        }
    }
    
    //update the user parameters
    func updateJob(job: Job, callback:@escaping (Bool)->Void)
    {
        ModelFirebaseJobs.updateJob(job: job, callback: { (answer) in
            callback (answer)
        })
        
    }
    
    func saveJobLike(jobId:String,  callback:@escaping (Bool)->Void)
    {
        ModelFirebaseJobs.saveJobLike(jobId: jobId) { (answer) in
            callback(answer)
        }
    }
    
    func deleteJobLike(jobId:String,  callback:@escaping (Bool)->Void)
    {
        ModelFirebaseJobs.deleteJobLike(jobId: jobId) { (answer) in
            callback(answer)
        }
    }
    
    func saveEmployeeLike(employeeId:String ,jobId:String,  callback:@escaping (Bool)->Void)
    {
        ModelFirebaseEmployee.saveEmployeeLike(employeeId:employeeId, jobId: jobId) { (answer) in
            callback(answer)
        }
    }
    
    func deleteEmployeeLike(employeeId:String ,jobId:String,  callback:@escaping (Bool)->Void)
    {
        ModelFirebaseEmployee.deleteEmployeeLike(employeeId:employeeId, jobId: jobId) { (answer) in
            callback(answer)
        }
    }
    
    func getEmployeeLike(jobId:String,  callback:@escaping (EmployeeLike?)->Void)
    {
        ModelFirebaseEmployee.getEmployeeLike(jobId: jobId) { (answer) in
            callback(answer)
        }
    }
    
    func getJobLike(employeeId:String, jobId:String,  callback:@escaping (JobLike?)->Void)
    {
        ModelFirebaseJobs.getJobLike(employeeId: employeeId,jobId: jobId) { (answer) in
            callback(answer)
        }
    }
    
    func saveMatch(jobId:String, employeeId:String, jobName:String, employeeName:String, companyId:String, callback:@escaping (Bool)->Void)
    {
        let match = Match(jobId: jobId, employeeId: employeeId, jobName: jobName, employeeName: employeeName, matchId: employeeId.appending(jobId), companyId: companyId)
        ModelFirebase.saveMatch(match: match)
        { (answer) in
            callback(answer)
        }
    }
    
    func deleteMatch(jobId:String, employeeId:String,  callback:@escaping (Bool)->Void)
    {
        let matchId = employeeId.appending(jobId)
        ModelFirebase.deleteMatch(matchId: matchId) { (answer) in
            callback(answer)
        }
    }
    
    func saveShowed(uID:String ,showedId:String)
    {
        let show = Show(showedId: showedId, userId: uID)
        ModelFirebase.saveShowed(show: show)
    }

    func getAllShow(id:String,callback:@escaping ([Show])->Void)
    {
      ModelFirebase.getAllShow(id: id) { (showes) in
            callback(showes)
        }
    }
    
    public func checkIfChatExist(id:String, callback:@escaping (Bool?)->Void)
    {
        ModelFirebaseChat.checkIfChatExist(id: id) { (answer) in
            callback(answer)
        }
        
    }
    
    public func saveChat(chat: Chat,callback:@escaping (Bool?)->Void)
    {
        ModelFirebaseChat.saveChat(chat: chat) { (answer) in
            callback(answer)
        }
    }
    
    public func FitEmployee(job:Job, employee:Employee)->Int
    {
        let salary = PickersFile.instance.getSalary()
        var answer = 0
        if(job.jobType != employee.profession)
        {
            answer = answer+20000
        }
        if(job.availability != employee.availability)
        {
            answer = answer+10
        }
        if(job.education != employee.education)
        {
            answer = answer+100
        }
        if(job.jobLocation != employee.placeWork)
        {
            answer = answer+50
        }
        if(job.languages != employee.languages)
        {
            answer = answer+15
        }
        if(job.move != employee.move)
        {
            answer = answer+30
        }
        let workHoursEmployee:Int? = Int(employee.workHours)
        let workHoursJob:Int? = Int(job.hours)
        if(workHoursEmployee != workHoursJob)
        {
            if(workHoursEmployee! < workHoursJob!)
            {
                answer = answer+40
            }
            else
            {
                if((answer - 40) < 0)
                {
                    answer = 0
                }
                else
                {
                    answer = answer-40
                }
               
            }
        }
        let workExperienceEmployee:Int? = Int(employee.workExperience)
        let workExperienceJob:Int? = Int(job.workExperience)
        if(workExperienceEmployee != workExperienceJob)
        {
            if(workExperienceEmployee! < workExperienceJob!)
            {
                answer = answer+60
            }
            else
            {
                if((answer - 60) < 0)
                {
                    answer = 0
                }
                else
                {
                    answer = answer-60
                }
            }
        }
        var indexEmployee:Int = -1
        var indexJob:Int = -1
        for index in 0..<salary.count
        {
            if((job.salary == salary[index]) && (indexJob == (-1)))
            {
                indexJob = index
            }
            if((employee.salary == salary[index]) && (indexEmployee == (-1)))
            {
                indexEmployee = index
            }
        
        }
        if (indexEmployee != indexJob)
        {
            if(indexEmployee < indexJob)
            {
                if((answer - (indexJob - indexEmployee)*100) < 0)
                {
                    answer = 0
                }
                else
                {
                    answer = answer - (indexJob - indexEmployee)*100
                }
            }
            else
            {
                answer = answer + (indexEmployee - indexJob)*100
            }
        
        }
        return answer
    }

    func deleteJob(jobID: String, matchList:[Match])  {
        ModelFirebaseJobs.deleteJob(jobID: jobID, matchList: matchList)
        
 
    }
   
    
    
    
}





