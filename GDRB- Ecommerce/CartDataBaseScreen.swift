//
//  HomeProductDataBase.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 23/01/23.
//

import Foundation
import SQLite3
import UIKit



class CartDataBaseScreen {
      init(){
    //calling functions
        db = openDatabase()
        createTable()
        
    }
//Database path
    let dbPath: String = "GDRB CartProduct.sqlite"
    
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
        let createTableString = "CREATE TABLE IF NOT EXISTS CartDetails(productid INTEGER PRIMARY KEY AUTOINCREMENT,productname TEXT,productprice TEXT,productcategory TEXT,productDiscription TEXT,productRating TEXT,productImage BLOB );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
            
                print("Users table created.")
            } else {
                print("Users table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    //insert data
    func insert( productname:String, productprice:String,productcategory:String,productDiscription:String,productRating:String,image:UIImage){
    
        let productDetails = read()
        for products in productDetails{
            if products.productname == productname{
                return
             
            }
        }
        let productImage = image.jpegData(compressionQuality: 1.0)
        let insertStatementString = "INSERT INTO CartDetails (productname, productprice, productcategory, productDiscription, productRating, productImage ) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (productname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (productprice as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (productcategory as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (productDiscription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (productRating as NSString).utf8String, -1, nil)
            sqlite3_bind_blob(insertStatement, 6, (productImage! as NSData).bytes, Int32(productImage!.count), nil)
              
           
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
    func retrieveProducts(withCategory category: String) -> [CartDetails] {
        var products: [CartDetails] = []
        
        let query = """
            SELECT * FROM CartDetails
            WHERE productcategory = '\(category)'
        """
        
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let productId = sqlite3_column_int(queryStatement, 0)
                let productName = String(cString: sqlite3_column_text(queryStatement, 1))
                let productPrice = String(cString: sqlite3_column_text(queryStatement, 2))
                let productCategory = String(cString: sqlite3_column_text(queryStatement, 3))
                let productDescription = String(cString: sqlite3_column_text(queryStatement, 4))
                let productRating = String(cString: sqlite3_column_text(queryStatement, 5))
                let imageData = sqlite3_column_blob(queryStatement, 6)
                let imageBytes = sqlite3_column_bytes(queryStatement, 6)

                if let imageData = imageData {
                    let data = Data(bytes: imageData, count: Int(imageBytes))
                    let image = UIImage(data: data)
                    // Use the image as needed
                    let product = CartDetails(productname: productName, productprice: productPrice, productcategory: productCategory, productid: Int(productId), productDiscription: productDescription, productRating: productRating, image: image!)
                    products.append(product)
                   
                } else {
                    // Handle the case when image data is nil (no image available)
                    // For example, you can assign a placeholder image or display an error message
                    let image = UIImage(named: "placeholderImage")
                    // or show an error message
                    print("No image available for product with ID: \(productId)")
                }
               
               
            }
            
            sqlite3_finalize(queryStatement)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing query statement: \(errorMessage)")
        }
        
        return products
    }
    func retrieveProductsDetails() -> [CartDetails] {
        var products: [CartDetails] = []
        
        let query = "SELECT * FROM CartDetails"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let productId = sqlite3_column_int(queryStatement, 0)
                let productName = String(cString: sqlite3_column_text(queryStatement, 1))
                let productPrice = String(cString: sqlite3_column_text(queryStatement, 2))
                let productCategory = String(cString: sqlite3_column_text(queryStatement, 3))
                let productDescription = String(cString: sqlite3_column_text(queryStatement, 4))
                let productRating = String(cString: sqlite3_column_text(queryStatement, 5))
                let imageData = sqlite3_column_blob(queryStatement, 6)
                let imageBytes = sqlite3_column_bytes(queryStatement, 6)

                if let imageData = imageData {
                    let data = Data(bytes: imageData, count: Int(imageBytes))
                    let image = UIImage(data: data)
                    // Use the image as needed
                    let product = CartDetails(productname: productName, productprice: productPrice, productcategory: productCategory, productid: Int(productId), productDiscription: productDescription, productRating: productRating, image: image!)
                    products.append(product)
                   
                } else {
                    // Handle the case when image data is nil (no image available)
                    // For example, you can assign a placeholder image or display an error message
                    let image = UIImage(named: "placeholderImage")
                    // or show an error message
                    print("No image available for product with ID: \(productId)")
                }
               
               
            }
            
            sqlite3_finalize(queryStatement)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing query statement: \(errorMessage)")
        }
        
        return products
    }
   
   
    
    
    //read Data in Database
    func read() -> [CartDetails] {
        let queryStatementString = "SELECT * FROM CartDetails;"
        var queryStatement: OpaquePointer? = nil
        var HomeProduct : [CartDetails] = []
       
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
               
                let productid = sqlite3_column_int(queryStatement, 0)
                
                let productname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let productprice = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let productcategory = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let productDiscription = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let productRating = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let imageData = sqlite3_column_blob(queryStatement, 6)
                let imageBytes = sqlite3_column_bytes(queryStatement, 6)

                if let imageData = imageData {
                    let data = Data(bytes: imageData, count: Int(imageBytes))
                    let image = UIImage(data: data)
                    // Use the image as needed
                    HomeProduct.append(CartDetails(productname: productname, productprice: productprice, productcategory: productcategory, productid: Int(productid), productDiscription: productDiscription, productRating: productRating, image: image!))
                     print("Query Result:")
                     print("\(productid) | \(productname) | \(productprice)| \(productcategory) | \(productDiscription) | \(productRating)")
                } else {
                    // Handle the case when image data is nil (no image available)
                    // For example, you can assign a placeholder image or display an error message
                    let image = UIImage(named: "placeholderImage")
                    // or show an error message
                    print("No image available for product with ID: \(productid)")
                }
               
               
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return HomeProduct
    }
    
    
    func deleteByName(productname:String) {
        let deleteStatementString = "DELETE FROM CartDetails WHERE productName = ?;"
      
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

    func deleteByName() {
        let deleteStatementString = "DELETE  FROM CartDetails;"
      
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
           
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
