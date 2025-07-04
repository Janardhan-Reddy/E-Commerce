//
//  RegistrationDataBase.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 11/01/23.
//

import Foundation
import SQLite3
import UIKit

var shareInstance = RegistrationDataBase()
class RegistrationDataBase {
    init(){
        
        regDatabase = openRegDatabase()
        createRegistrationTable()
        
    }
    //Database path
    let regDatabasePath: String = "GDRB regEcommerce.sqlite"
    
    var regDatabase:OpaquePointer?
    
    func openRegDatabase() -> OpaquePointer?{
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(regDatabasePath)
        print("fileURL-",fileURL)
        var regDatabase: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &regDatabase) != SQLITE_OK {
            
            print("error opening database")
            return nil
        }
        else {
            
            print("Successfully opened connection to database at \(fileURL)")
            return regDatabase
        }
        
    }
    //create a sqlitetable
    func createRegistrationTable() {
        let createRegTableString = "CREATE TABLE IF NOT EXISTS RegistrationUsers(regId INTEGER PRIMARY KEY AUTOINCREMENT,Firstname TEXT,Lastname TEXT,Mobilenumber INTEGER,Email TEXT,Password TEXT,ConfirmPassword TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(regDatabase, createRegTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                
                print("RegistrationUsers table created.")
            } else {
                print("RegistrationUsers table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    class func getInstance() -> RegistrationDataBase{
        if shareInstance.regDatabase == nil{
            shareInstance.regDatabase = OpaquePointer(bitPattern: 0)
        }
        return shareInstance
    }
    //check login exist
    func checkLogin( Email: String  , Password: String)->Bool {
        let dataArray = readRegistarion()
        print(dataArray)
        
        let user = dataArray.filter { regUsers in
            regUsers.Email == Email && regUsers.Password == Password
            
        }
        
        return user.count > 0
        
        
    }
    func checkEmailAlreadyExist(email:String)-> Bool{
        let checkingUser = readRegistarion()
        let user2 = checkingUser.filter { regUsers in
            regUsers.Email == email
            
        }
    
        return user2.count > 0
    }
    //check DataBase Exist
    @IBAction func makePayment(_ sender: Any) {
           
          
              
           }
    //update password
    func updatePassword(oldPassword: String, newPassword: String) -> Bool {
        let updateStatementString = "UPDATE RegistrationUsers SET password = ? WHERE Email = ?;"
           var updateStatement: OpaquePointer? = nil
           
           if sqlite3_prepare_v2(regDatabase, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
               sqlite3_bind_text(updateStatement, 1, (newPassword as NSString).utf8String, -1, nil)
               sqlite3_bind_text(updateStatement, 2, (oldPassword as NSString).utf8String, -1, nil)
             
               
               if sqlite3_step(updateStatement) == SQLITE_DONE {
                   sqlite3_finalize(updateStatement)
                   print("UPDATE password successfully table created.")
                   return true
               }
             
           }
           
           sqlite3_finalize(updateStatement)
           return false
       }
    //update Email
    func updateEmail(oldEmail: String, newEmail: String) -> Bool {
        let updateStatementString = "UPDATE RegistrationUsers SET Email = ? WHERE Email = ?;"
        var updateStatement: OpaquePointer? = nil

        guard sqlite3_prepare_v2(regDatabase, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK else {
            print("Error preparing update statement.")
            return false
        }

        sqlite3_bind_text(updateStatement, 1, (newEmail as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStatement, 2, (oldEmail as NSString).utf8String, -1, nil)

        if sqlite3_step(updateStatement) == SQLITE_DONE {
            sqlite3_finalize(updateStatement)
            print("UPDATE Email successfully.")
            return true
        } else {
            print("Error updating email:", String(cString: sqlite3_errmsg(regDatabase)))
        }

        sqlite3_finalize(updateStatement)
        return false
    }

    // Example usage
   
    
    func DoesRegUsersDbExist(Email:String,Password:String){
        let queryStatementString = "SELECT * FROM RegistrationUsers WHERE Email = '\(Email)' AND Password = '\(Password)';"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(regDatabase, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let userid = sqlite3_column_int(queryStatement, 0)
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                
                print("Query Result:")
                print("\(userid) | \(email) |\(password)"  )
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        
    }
    
    
    
    
    //insert data
    func reginsert(Firstname:String, Lastname:String,Mobilenumber:String,Email:String,Password:String){
        
        let RegistraionPersons = readRegistarion()
        for regperson in RegistraionPersons{
            
            if regperson.Email == Email{
                
                return
            }
        }
        let insertStatementRegString = "INSERT INTO  RegistrationUsers (Firstname, Lastname, Mobilenumber, Email, Password) VALUES (?,?,?,?,?);"
        var insertRegStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(regDatabase, insertStatementRegString, -1, &insertRegStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertRegStatement, 1, (Firstname as NSString).utf8String, -1, nil)
            
            sqlite3_bind_text(insertRegStatement, 2, (Lastname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertRegStatement, 3, (Mobilenumber as NSString).utf8String, -1, nil)
            
            
            
            sqlite3_bind_text(insertRegStatement, 4, (Email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertRegStatement, 5, (Password as NSString).utf8String, -1, nil)
            
            print("\(Firstname) | \(Lastname) |\(Mobilenumber) | \(Email) | \(Password)")
            if sqlite3_step(insertRegStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertRegStatement)
    }
    //read data in database
    func readRegistarion() -> [RegistrationUsers] {
        let queryStatementString = "SELECT * FROM RegistrationUsers;"
        var queryStatement: OpaquePointer? = nil
        var Registraion : [RegistrationUsers] = []
        
        if sqlite3_prepare_v2(regDatabase, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                
               
                
                let Firstname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let Lastname = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let Mobilenumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                let Email = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                
                let Password = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                
                
                Registraion.append(RegistrationUsers(Firstname: Firstname, Lastname: Lastname, Mobilenumber: Mobilenumber, Email: Email, Password: Password))
                
                
                
                print("Query Result:")
                print("\(Firstname) | \(Lastname) |\(Mobilenumber) | \(Email) | \(Password)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Registraion
    }
}
