//
//  CartDataBase.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 23/01/23.
//

import Foundation
import SQLite3
class CartDataBase {
    init(){
    //calling functions
        Database = openDatabase()
        createCartTable()
      
    }
    
//Database path
    let DatabasePath: String = "GDRB CartEcommerce.sqlite"
    
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
    func createCartTable() {
        let createLoginTableString = "CREATE TABLE IF NOT EXISTS CartDetails(cartid INTEGER PRIMARY KEY,cartname TEXT,cartprice INTEGER,cartcategory TEXT );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(Database, createLoginTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
            
                print("CartDetails table created.")
            } else {
                print("CartDetails table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
   
   
    //insertData
    func insert(cartid:Int, cartname:String,cartprice:Int,cartcategory:String){
    
        let cartCategory = readFromCart()
        for cartDetails in cartCategory{

            if cartDetails.cartid == cartid{

                return
            }
        }
       let insertStatementString = "INSERT INTO CartDetails (cartname, cartprice, cartcategory) VALUES (?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(Database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (cartname as NSString).utf8String, -1, nil)
            print(cartname)
            sqlite3_bind_int(insertStatement, 2, Int32(cartprice))
            sqlite3_bind_text(insertStatement, 3, (cartcategory as NSString).utf8String, -1, nil)
            print(cartcategory)
            
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

    
    //read Data
    func readFromCart() -> [CartDetails] {
        let queryStatementString = "SELECT * FROM CartDetails;"
        var queryStatement: OpaquePointer? = nil
        var Cart : [CartDetails] = []
        if sqlite3_prepare_v2(Database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
               let cartname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let cartid = sqlite3_column_int(queryStatement, 0)
                let cartprice = sqlite3_column_int(queryStatement, 2)
                let cartcategory = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                   print("Query Result:")
                Cart.append(CartDetails(cartname: cartname, cartprice: Int(cartprice), cartcategory: cartcategory, cartid: Int(cartid)))
                
                print("\(cartid) | \(cartname) | \(cartprice) | \(cartcategory)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Cart
    }

   
    
}

