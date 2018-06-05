//
//  Post+sql.swift
//  FinalProject
//
//  Created by Koral Shmueli on 26/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import Foundation


extension Job{
    static let JOB_TABLE = "JOBS"
    static let JOB_ID = "JOB_ID"
    static let JOB_UID = "JOB_UID"
    static let JOB_NAME = "JOB_NAME"
    static let JOB_IMAGE_URL = "JOB_IMAGE_URL"
    static let JOB_LOCATION = "JOB_LOCATION"
    static let JOB_DESCRIPTION = "JOB_DESCRIPTION"
    static let JOB_HOURS = "JOB_HOURS"
    static let JOB_TYPE = "JOB_TYPE"
    static let JOB_COMPANY_NAME = "JOB_COMPANY_NAME"
    static let JOB_LANGUAGES = "JOB_LANGUAGES"
    static let JOB_MOVE = "JOB_MOVE"
    static let JOB_WORKEXPERIENCE = "JOB_WORKEXPERIENCE"
    static let JOB_EDUCATION = "JOB_EDUCATION"
    static let JOB_SALARY = "JOB_SALARY"
    static let JOB_AVAILABILITY = "JOB_AVAILABILITY"
    static let JOB_DELETED = "JOB_DELETED"
    static let JOB_LAST_UPDATE = "JOB_LAST_UPDATE"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + JOB_TABLE + " ( " + JOB_ID  + " TEXT PRIMARY KEY, "
            + JOB_UID + " TEXT SECONDARY KEY, "
            + JOB_NAME + " TEXT, " + JOB_IMAGE_URL + " TEXT, " + JOB_LOCATION + " TEXT, " + JOB_DESCRIPTION + " TEXT, " + JOB_HOURS + " TEXT, " +  JOB_TYPE + " TEXT, " +  JOB_COMPANY_NAME + " TEXT, " +   JOB_LANGUAGES + " TEXT, " +   JOB_MOVE + " TEXT, " +   JOB_WORKEXPERIENCE + " TEXT, " +   JOB_EDUCATION + " TEXT, " +   JOB_SALARY + " TEXT, " +   JOB_AVAILABILITY + " TEXT, " +   JOB_DELETED + " TEXT, " + JOB_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }

        return true
    }
    
    func addJobToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Job.JOB_TABLE
            + "(" + Job.JOB_ID + ","
            + Job.JOB_UID + ","
            + Job.JOB_NAME + "," + Job.JOB_IMAGE_URL + "," + Job.JOB_LOCATION + "," + Job.JOB_DESCRIPTION + "," + Job.JOB_HOURS + "," + Job.JOB_TYPE + "," + Job.JOB_COMPANY_NAME + ","  + Job.JOB_LANGUAGES + "," + Job.JOB_MOVE + "," + Job.JOB_WORKEXPERIENCE + "," + Job.JOB_EDUCATION + "," + Job.JOB_SALARY + "," + Job.JOB_AVAILABILITY + "," + Job.JOB_DELETED + "," + Job.JOB_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let sql = "INSERT OR REPLACE INTO " + Job.JOB_TABLE
                + "(" + Job.JOB_ID + ","
                + Job.JOB_UID + ","
                + Job.JOB_NAME + "," + Job.JOB_IMAGE_URL + "," + Job.JOB_LOCATION + "," + Job.JOB_DESCRIPTION + "," + Job.JOB_HOURS + "," + Job.JOB_TYPE + "," + Job.JOB_COMPANY_NAME + ","  + Job.JOB_LANGUAGES + "," + Job.JOB_MOVE + "," + Job.JOB_WORKEXPERIENCE + "," + Job.JOB_EDUCATION + "," + Job.JOB_SALARY + "," + Job.JOB_AVAILABILITY + "," + Job.JOB_DELETED + "," + Job.JOB_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"
            print("insert post to db - \(sql)")
            let userId = self.uID.cString(using: .utf8)
            let jobId = self.jobId?.cString(using: .utf8)
            let jobName = self.jobName.cString(using: .utf8)
            var imageUrl = "".cString(using: .utf8)
            imageUrl = self.imageUrl.cString(using: .utf8)
            let location = self.jobLocation.cString(using: .utf8)
            let description = self.description.cString(using: .utf8)
            let hours = self.hours.cString(using: .utf8)
            let jobType = self.jobType.cString(using: .utf8)
            let companyName = self.companyName?.cString(using: .utf8)
            let languages = self.languages.cString(using: .utf8)
            let move = self.move.cString(using: .utf8)
            let workExperience = self.workExperience.cString(using: .utf8)
            let education = self.education.cString(using: .utf8)
            let salary = self.salary.cString(using: .utf8)
            let availability = self.availability.cString(using: .utf8)
            let deleted = self.deleted?.cString(using: .utf8)

            
            sqlite3_bind_text(sqlite3_stmt, 1, jobId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, jobName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, location,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, description,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, hours,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, jobType,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 9, companyName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 10, languages,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 11, move,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 12, workExperience,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 13, education,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 14, salary,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 15, availability,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 16, deleted,-1,nil);
            
            if(imageUrl != nil)
            {
                sqlite3_bind_text(sqlite3_stmt, 4, imageUrl,-1,nil);
            }
            
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 17, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllJobsFromLocalDb(database:OpaquePointer?)->[Job]{
        var jobs = [Job]()
        var sqlite3_stmt: OpaquePointer? = nil
        var sql = ""
        sql = "SELECT * from JOBS ORDER BY JOB_LAST_UPDATE DESC;"
        if (sqlite3_prepare_v2(database,sql,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let userId =  String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,1))
                let jobId =  String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,0))
                let jobName =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                var imageUrl = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let description = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                let location = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let hours = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let jobType = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,7))
                let companyName =  String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,8))
                let languages = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,9))
                let move = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,10))
                let workExperience = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,11))
                let education = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,12))
                let salary = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,13))
                let availability = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,14))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,16))
                if (imageUrl != nil && imageUrl == ""){
                    imageUrl = nil
                }
                let deleted = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,15))
                let job = Job(JobLocation: location!, ImageUrl: imageUrl!, Hours: hours!, Description: description!, uID: userId!, jobID: jobId!, jobName: jobName!, jobType: jobType!, companyName: companyName!, languages: languages!, move:move!, workExperience:workExperience!, education:education!, salary:salary!, availability:availability!, deleted:deleted)
                job.lastUpdate = Date.fromFirebase(update)
                jobs.append(job)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return jobs
    }

}
