//
//  Match+sql.swift
//  FinalProject
//
//  Created by Koral Shmueli on 26/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import Foundation


extension Match{
    static let MATCH_TABLE = "MATCH"
    static let MATCH_ID = "MATCH_ID"
    static let JOB_ID = "JOB_ID"
    static let JOB_NAME = "JOB_NAME"
    static let EMPLOYEE_ID = "EMPLOYEE_ID"
    static let EMPLOYEE_NAME = "EMPLOYEE_NAME"
    static let COMPANY_ID = "COMPANY_ID"
    static let MATCH_DELETED = "MATCH_DELETED"
    static let MATCH_LAST_UPDATE = "MATCH_LAST_UPDATE"
    
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + MATCH_TABLE + " ( " + MATCH_ID  + " TEXT PRIMARY KEY,"
            + JOB_ID + " TEXT, "
            + JOB_NAME + " TEXT, " + EMPLOYEE_ID + " TEXT, " + EMPLOYEE_NAME + " TEXT, " + COMPANY_ID + " TEXT, " + MATCH_DELETED + " TEXT, "   + MATCH_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addMatchToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Match.MATCH_TABLE
            + "(" + Match.MATCH_ID + ","
            + Match.JOB_ID + ","
            + Match.JOB_NAME + "," + Match.EMPLOYEE_ID + "," + Match.EMPLOYEE_NAME  + ","  + Match.COMPANY_ID  + "," + Match.MATCH_DELETED  + "," + Match.MATCH_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let sql = "INSERT OR REPLACE INTO " + Match.MATCH_TABLE
                + "(" + Match.MATCH_ID + ","
                + Match.JOB_ID + ","
                + Match.JOB_NAME + "," + Match.EMPLOYEE_ID + "," + Match.EMPLOYEE_NAME  + ","  + Match.COMPANY_ID  + "," + Match.MATCH_DELETED  + "," + Match.MATCH_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?);"
            
            let matchId = self.matchId.cString(using: .utf8)
            let jobId = self.jobId.cString(using: .utf8)
            let jobName = self.jobName.cString(using: .utf8)
            let employeeId = self.employeeId.cString(using: .utf8)
            let employeeName = self.employeeName.cString(using: .utf8)
            let companyId = self.companyId.cString(using: .utf8)
            let deleted = self.deleted?.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, matchId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, jobId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, jobName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, employeeId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, employeeName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, companyId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, deleted,-1,nil);

            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 8, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllMatchFromLocalDb(database:OpaquePointer?)->[Match]{
        var matches = [Match]()
        var sqlite3_stmt: OpaquePointer? = nil
        var sql = ""
        sql = "SELECT * from MATCH;"
        if (sqlite3_prepare_v2(database,sql,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){

                let matchId = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,0))
                let jobId = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,1))
                let jobName = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,2))
                let employeeId = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,3))
                let employeeName = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,4))
                let companyId = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,5))
                let deleted = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,6))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,7))
                
                let match = Match(jobId: jobId!, employeeId: employeeId!, jobName: jobName!, employeeName: employeeName!, matchId: matchId!,companyId: companyId!,deleted: deleted)
                match.lastUpdate = Date.fromFirebase(update)
                matches.append(match)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return matches
    }
    
}
