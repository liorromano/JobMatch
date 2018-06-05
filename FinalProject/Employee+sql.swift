

import Foundation


extension Employee{
    static let EMPLOYEE_TABLE = "EMPLOYEE_TABLE"
    static let EMPLOYEE_UID = "EMPLOYEE_UID"
    static let EMPLOYEE_USERNAME = "EMPLOYEE_USERNAME"
    static let EMPLOYEE_FULLNAME = "EMPLOYEE_FULLNAME"
    static let EMPLOYEE_IMAGE_URL = "EMPLOYEE_IMAGE_URL"
    static let EMPLOYEE_GENDER = "EMPLOYEE_GENDER"
    static let EMPLOYEE_LANGUAGES = "EMPLOYEE_LANGUAGES"
    static let EMPLOYEE_MOVE = "EMPLOYEE_MOVE"
    static let EMPLOYEE_PROFESSION = "EMPLOYEE_PROFESSION"
    static let EMPLOYEE_WORKEXPERIENCE = "EMPLOYEE_WORKEXPERIENCE"
    static let EMPLOYEE_AGE = "EMPLOYEE_AGE"
    static let EMPLOYEE_EDUCATION = "EMPLOYEE_EDUCATION"
    static let EMPLOYEE_PLACEWORK = "EMPLOYEE_PLACEWORK"
    static let EMPLOYEE_SALARY = "EMPLOYEE_SALARY"
    static let EMPLOYEE_WORKHOURS = "EMPLOYEE_WORKHOURS"
    static let EMPLOYEE_AVAILABILITY = "EMPLOYEE_AVAILABILITY"
    static let EMPLOYEE_LAST_UPDATE = "EMPLOYEE_LAST_UPDATE"
    
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + EMPLOYEE_TABLE + " ( " + EMPLOYEE_UID  + " TEXT PRIMARY KEY, "
            + EMPLOYEE_USERNAME + " TEXT SECONDARY KEY, "
            + EMPLOYEE_FULLNAME + " TEXT, " + EMPLOYEE_IMAGE_URL + " TEXT, " + EMPLOYEE_GENDER + " TEXT, " + EMPLOYEE_LANGUAGES + " TEXT, " + EMPLOYEE_MOVE + " TEXT, " + EMPLOYEE_PROFESSION + " TEXT, " +  EMPLOYEE_WORKEXPERIENCE + " TEXT, " +  EMPLOYEE_AGE + " TEXT, "  +  EMPLOYEE_EDUCATION + " TEXT, " +  EMPLOYEE_PLACEWORK + " TEXT, " +  EMPLOYEE_SALARY + " TEXT, " +  EMPLOYEE_WORKHOURS + " TEXT, " +  EMPLOYEE_AVAILABILITY + " TEXT, " + EMPLOYEE_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addEmployeeToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Employee.EMPLOYEE_TABLE
            + " ( " + Employee.EMPLOYEE_UID  + ","
            + Employee.EMPLOYEE_USERNAME + ","
            + Employee.EMPLOYEE_FULLNAME + "," + Employee.EMPLOYEE_IMAGE_URL + "," + Employee.EMPLOYEE_GENDER + "," + Employee.EMPLOYEE_LANGUAGES + "," + Employee.EMPLOYEE_MOVE + "," + Employee.EMPLOYEE_PROFESSION + "," +  Employee.EMPLOYEE_WORKEXPERIENCE + "," +  Employee.EMPLOYEE_AGE + ","  +  Employee.EMPLOYEE_EDUCATION + "," +  Employee.EMPLOYEE_PLACEWORK + "," +  Employee.EMPLOYEE_SALARY + "," +  Employee.EMPLOYEE_WORKHOURS + "," +  Employee.EMPLOYEE_AVAILABILITY + ","  + Employee.EMPLOYEE_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let sql = "INSERT OR REPLACE INTO " + Employee.EMPLOYEE_TABLE
                + " ( " + Employee.EMPLOYEE_UID  + ","
                + Employee.EMPLOYEE_USERNAME + ","
                + Employee.EMPLOYEE_FULLNAME + "," + Employee.EMPLOYEE_IMAGE_URL + "," + Employee.EMPLOYEE_GENDER + "," + Employee.EMPLOYEE_LANGUAGES + "," + Employee.EMPLOYEE_MOVE + "," + Employee.EMPLOYEE_PROFESSION + "," +  Employee.EMPLOYEE_WORKEXPERIENCE + "," +  Employee.EMPLOYEE_AGE + ","  +  Employee.EMPLOYEE_EDUCATION + "," +  Employee.EMPLOYEE_PLACEWORK + "," +  Employee.EMPLOYEE_SALARY + "," +  Employee.EMPLOYEE_WORKHOURS + "," +  Employee.EMPLOYEE_AVAILABILITY + ","  + Employee.EMPLOYEE_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"
            print("insert post to db - \(sql)")
            let uId = self.uID?.cString(using: .utf8)
            let userName = self.userName.cString(using: .utf8)
            let fullName = self.fullName.cString(using: .utf8)
            var imageUrl = "".cString(using: .utf8)
            imageUrl = self.imageUrl?.cString(using: .utf8)
            let gender = self.gender?.cString(using: .utf8)
            let languages = self.languages.cString(using: .utf8)
            let move = self.move.cString(using: .utf8)
            let profession = self.profession.cString(using: .utf8)
            let workExperience = self.workExperience.cString(using: .utf8)
            let age = self.age.cString(using: .utf8)
            let education = self.education.cString(using: .utf8)
            let placeWork = self.placeWork.cString(using: .utf8)
            let salary = self.salary.cString(using: .utf8)
             let workHours = self.workHours.cString(using: .utf8)
             let availability = self.availability.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, uId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, fullName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, gender,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, languages,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, move,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, profession,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 9, workExperience,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 10, age,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 11, education,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 12, placeWork,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 13, salary,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 14, workHours,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 15, availability,-1,nil);
            
            if(imageUrl != nil)
            {
                sqlite3_bind_text(sqlite3_stmt, 4, imageUrl,-1,nil);
            }
            
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 16, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllEmployeesFromLocalDb(database:OpaquePointer?)->[Employee]{
        var employees = [Employee]()
        var sqlite3_stmt: OpaquePointer? = nil
        var sql = ""
        sql = "SELECT * from EMPLOYEE_TABLE;"
        if (sqlite3_prepare_v2(database,sql,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                
                let uId = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,0))
                let userName = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,1))
                let fullName = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,2))
                var imageUrl = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let gender = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,4))
                let languages = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,5))
                let move = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,6))
                let profession = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,7))
                let workExperience = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,8))
                let age = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,9))
                let education = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,10))
                let placeWork = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,11))
                let salary = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,12))
                let workHours = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,13))
                let availability = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt,14))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,15))
                
                if (imageUrl != nil && imageUrl == ""){
                    imageUrl = nil
                }
                let employee = Employee(userName:userName!, fullName:fullName!, imageUrl:imageUrl, uID:uId, gender:gender, languages:languages!, move:move!, profession:profession! ,workExprience:workExperience! ,age:age!,education:education!,placeWork:placeWork!,salary:salary!,workHours:workHours!, availability:availability!)
                employee.lastUpdate = Date.fromFirebase(update)
                employees.append(employee)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return employees
    }
    
}
