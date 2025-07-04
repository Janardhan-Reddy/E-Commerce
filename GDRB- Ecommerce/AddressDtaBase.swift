//
//  AddressDtaBase.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 15/07/23.
//

import UIKit
import SQLite3

class AddressDtaBase{
    init(){
  //calling functions
      db = openDatabase()
      createTable()
      
  }
//Database path
  let dbPath: String = "GDRB AddressProduct.sqlite"
  
  var db:OpaquePointer?
  var dataInserted: Bool = false
  func openDatabase() -> OpaquePointer?{
  
      let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
          .appendingPathComponent(dbPath)
      print("fileURL-",fileURL)
      var db: OpaquePointer? = nil
      if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
      
          print("error opening database")
          return nil
      }
      else {
      
          print("Successfully opened connection to database at \(fileURL)")
          return db
      }
     
  }
 //create a table in sqlite
  func createTable() {
      let createTableString = "CREATE TABLE IF NOT EXISTS AddressDetails(productid INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT,address TEXT,name TEXT,phoneNumber TEXT );"
      var createTableStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
      {
          if sqlite3_step(createTableStatement) == SQLITE_DONE{
          
              print("Address table created.")
          } else {
              print("Address table could not be created.")
          }
      } else {
          print("CREATE TABLE statement could not be prepared.")
      }
      sqlite3_finalize(createTableStatement)
  }
  //insert data
    func insert(email: String, address: String, name: String, phoneNumber: String) {
        let productDetails = read()
        
      
        let insertStatementString = "INSERT INTO AddressDetails(email, address, name, phoneNumber) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (phoneNumber as NSString).utf8String, -1, nil)
            
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
  //retrieveDataFromProductsDB
  func retrieveAddress(withCategory category: String) -> [AddressDetails] {
      var products: [AddressDetails] = []
      
      let query = """
          SELECT * FROM AddressDetails
          WHERE address = '\(category)'
      """
      
      var queryStatement: OpaquePointer?
      
      if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
          while sqlite3_step(queryStatement) == SQLITE_ROW {
              let productId = sqlite3_column_int(queryStatement, 0)
              let email = String(cString: sqlite3_column_text(queryStatement, 1))
              let addresss = String(cString: sqlite3_column_text(queryStatement, 2))
              let name = String(cString: sqlite3_column_text(queryStatement, 3))
              let phoneNumber = String(cString: sqlite3_column_text(queryStatement, 4))
              let product = AddressDetails(email: email, address: addresss, name:name, phoneNumber: phoneNumber)
              products.append(product)

             
          }
          
          sqlite3_finalize(queryStatement)
      } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("Error preparing query statement: \(errorMessage)")
      }
      
      return products
  }
  func retrieveAddressDetails() -> [AddressDetails] {
      var products: [AddressDetails] = []
      
      let query = "SELECT * FROM AddressDetails"
      var queryStatement: OpaquePointer?
      
      if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
          while sqlite3_step(queryStatement) == SQLITE_ROW {
              let productId = sqlite3_column_int(queryStatement, 0)
              let email = String(cString: sqlite3_column_text(queryStatement, 1))
              let address = String(cString: sqlite3_column_text(queryStatement, 2))
              let name = String(cString: sqlite3_column_text(queryStatement, 3))
              let phoneNumber = String(cString: sqlite3_column_text(queryStatement, 4))
              let product = AddressDetails( email: email, address: address, name: name, phoneNumber: phoneNumber)
              products.append(product)

          }
          
          sqlite3_finalize(queryStatement)
      } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("Error preparing query statement: \(errorMessage)")
      }
      
      return products
  }
 
 
  
  
  //read Data in Database
  func read() -> [AddressDetails] {
      let queryStatementString = "SELECT * FROM AddressDetails;"
      var queryStatement: OpaquePointer? = nil
      var HomeProduct : [AddressDetails] = []
     
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
          while sqlite3_step(queryStatement) == SQLITE_ROW {
             
              let productid = sqlite3_column_int(queryStatement, 0)
              
              let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
              let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
              let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
              let phoneNumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
              HomeProduct.append(AddressDetails(email: email, address: address,name: name,phoneNumber: phoneNumber))
                   print("\(productid) | \(email) | \(address)")
                    print("Query Result:")
             
          }
      } else {
          print("SELECT statement could not be prepared")
      }
      
      sqlite3_finalize(queryStatement)
      return HomeProduct
  }
  
  
  func deleteByName(productname:String) {
      let deleteStatementString = "DELETE FROM AddressDetails WHERE name = ?;"
    
      var deleteStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
          sqlite3_bind_text(deleteStatement, 1, (productname as NSString).utf8String, -1, nil)
          if sqlite3_step(deleteStatement) == SQLITE_DONE {
              print("Successfully deleted row.")
          } else {
              print("Could not delete row.")
          }
      } else {
          print("DELETE statement could not be prepared")
      }
      sqlite3_finalize(deleteStatement)
  }

}
