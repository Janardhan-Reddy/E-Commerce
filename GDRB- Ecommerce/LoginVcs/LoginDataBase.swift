//
//  LoginDataBase.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 11/01/23.
//

import Foundation
import SQLite3


class LoginDataBase {
   
    
    init(){
    //calling functions
        Database = openDatabase()
        createLoginTable()
        DoesUsersDbExist()
        
    }
//DataBase path
    let DatabasePath: String = "GDRB logEcommerce.sqlite"
    
    var Database:OpaquePointer?
   
    func openDatabase() -> OpaquePointer?{
    
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DatabasePath)
        print("fileURL-",fileURL)
        var Database: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &Database) != SQLITE_OK {
        
            print("error opening database")
            return nil
        }
        else {
        
            print("Successfully opened connection to database at \(fileURL)")
            return Database
        }
       
    }
   //create a table in sqlite
    func createLoginTable() {
        let createLoginTableString = "CREATE TABLE IF NOT EXISTS LoginUsers(Id INTEGER PRIMARY KEY,Username TEXT,password INTEGER );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(Database, createLoginTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
            
                print("LoginUsers table created.")
            } else {
                print("LoginUsers table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
   
   
    //insert data from LoginUsers
    func insert(id:Int, Username:String, password:String){
    
        let loginpersons = readFromLogin()
        for person in loginpersons{

            if person.id == id{

                return
            }
        }
       let insertStatementString = "INSERT INTO LoginUsers (Username, password) VALUES ( ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(Database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (Username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (password as NSString).utf8String, -1, nil)
          
            
           
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    // //querying an existing database table
    func DoesUsersDbExist(){
        let queryStatementString = "SELECT * FROM LoginUsers WHERE Username = 'SrinivauluArigela' ;"
        var queryStatement: OpaquePointer? = nil
       
        if sqlite3_prepare_v2(Database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let userid = sqlite3_column_int(queryStatement, 0)
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
               // print("Query Result:")
               // print("\(userid) | \(username)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
       

    }
    
    //read Data
    func readFromLogin() -> [LoginUsers] {
        let queryStatementString = "SELECT * FROM LoginUsers;"
        var queryStatement: OpaquePointer? = nil
        var Login : [LoginUsers] = []
        if sqlite3_prepare_v2(Database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
               
                let Username = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
               
               
                Login.append(LoginUsers(Username:Username , password: password, id: Int(id)))
                print("Query Result:")
                print("\(id) | \(Username) | \(password)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Login
    }

   
    
}
