//
//  HomeProductDataBase.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 23/01/23.
//

import Foundation
import SQLite3
import UIKit


class HomeProductDataBase {
      init(){
    //calling functions
        db = openDatabase()
        createTable()
        
    }
//Database path
    let dbPath: String = "GDRB HomeProductEcommerce.sqlite"
    
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
        let createTableString = "CREATE TABLE IF NOT EXISTS HomeProductDetails(productid INTEGER PRIMARY KEY AUTOINCREMENT,productname TEXT,productprice TEXT,productcategory TEXT,productDiscription TEXT,productRating TEXT,productImage BLOB );"
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
        let insertStatementString = "INSERT INTO HomeProductDetails (productname, productprice, productcategory, productDiscription, productRating, productImage ) VALUES (?, ?, ?, ?, ?, ?);"
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
    func retrieveProducts(withCategory category: String) -> [HomeProductDetails] {
        var products: [HomeProductDetails] = []
        
        let query = """
            SELECT * FROM HomeProductDetails
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
                    let product = HomeProductDetails(productname: productName, productprice: productPrice, productcategory: productCategory, productid: Int(productId), productDiscription: productDescription, productRating: productRating, image: image!)
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
   
    
    func insertData() {
           if dataInserted {
               return
           }
           
        insert( productname: "Samsung Galaxy S21", productprice: "799909.00", productcategory: "Electronics", productDiscription: "6.2-inch Dynamic AMOLED display. Exynos 2100 / Qualcomm Snapdragon 888 processor. Triple rear camera system. 8GB RAM, 128GB storage. 4000mAh battery. Android 11 OS.", productRating: "4.7", image: UIImage(named: "s21")!)
        
        insert( productname: "Iphone 14(Blue, 128GB)", productprice : "74900", productcategory : "Electronics",
                productDiscription : "15.40 cm (6.1-inch) Super Retina XDR display. Advanced camera system for better photos in any light. Cinematic mode now in 4K Dolby Vision up to 30 fps. Action mode for smooth, steady, handheld videos. Vital safety technology — Crash Detection calls for help when you can’t", productRating : "4.6", image: UIImage(named: "mobile11")! )
        
        insert(productname:"Iphone 13(Blue, 128GB)", productprice : "94900", productcategory : "Electronics",
               productDiscription : "15.40 cm (6.1-inch) Super Retina XDR display.Advanced camera system for better photos in any light.Cinematic mode now in 4K Dolby Vision up to 30 fps.Action mode for smooth, steady, handheld videos. Vital safety technology — Crash Detection calls for help when you can’t", productRating: "4.6", image: UIImage(named: "mobile2")!)
        
        insert( productname: "Samsung s9((Blue, 128GB)",  productprice : "54900",  productcategory: "Electronics",
                productDiscription :"15.40 cm (6.1-inch) Super Retina XDR display. Advanced camera system for better photos in any light. Cinematic mode now in 4K Dolby Vision up to 30 fps. Action mode for smooth, steady, handheld videos. Vital safety technology — Crash Detection calls for help when you can’t",productRating: "4.6", image: UIImage(named: "s9")!  )
        
        insert( productname: "Redmi 4a(Blue, 64GB)", productprice : "7900", productcategory: "Electronics",
                productDiscription: "15.40 cm (6.1-inch) Super Retina XDR display. Advanced camera system for better photos in any light. Cinematic mode now in 4K Dolby Vision up to 30 fps. Action mode for smooth, steady, handheld videos. Vital safety technology — Crash Detection calls for help when you can’t",  productRating : "4.6", image: UIImage(named: "redmi")!  )
        
        insert( productname: "POLO T-shirt", productprice : "299", productcategory : "Fashion",
                productDiscription: "50% Polyester & 50% Cotton. Ribbed double-needle sleeve. Soft fashion knit collar. 3 high gloss solid buttons. Double-needle cross stitch for sleeve and bottom hem. Protective film on the embroidered logo is water soluble.Wash before use.",productRating: "4.6", image: UIImage(named: "tshirt")!)
        insert( productname: "X-Men shirt", productprice: "499", productcategory : "Fashion",
                productDiscription: "50% Polyester & 50% Cotton. Ribbed double-needle sleeve. Soft fashion knit collar. 3 high gloss solid buttons. Double-needle cross stitch for sleeve and bottom hem. Protective film on the embroidered logo is water soluble.Wash before use.",productRating: "4.5", image: UIImage(named: "shirt")!)
        insert( productname: "Blue Jeans", productprice: "799",productcategory : "Fashion",
                productDiscription: "50% Polyester & 50% Cotton. 3 high gloss solid buttons. Double-needle cross stitch for sleeve and bottom hem. Protective film on the embroidered logo is water soluble.Wash before use.", productRating: "4.5", image: UIImage(named: "jeans")!)
        insert( productname:"Shirt", productprice:  "299", productcategory : "Fashion",
                productDiscription: "50% Polyester & 50% Cotton. Ribbed double-needle sleeve. Soft fashion knit collar. 3 high gloss solid buttons. Double-needle cross stitch for sleeve and bottom hem. Protective film on the embroidered logo is water soluble.Wash before use.",productRating: "4.5", image: UIImage(named: "image17")!)
        insert( productname: "Dolo 650", productprice : "150", productcategory : "Medicine",productDiscription: "Dolo-650 tablet is a very common medicine and often prescribed alone or with one or two medicine to relieve symptoms of fever, nerve pain, and pain during periods, backache, toothache, sore throat, muscle aches, strains and sprains, common colds, migraine, long-term mild to moderate pain, inflammation due to arthritis", productRating: "4.7", image: UIImage(named: "image15")!)
        insert( productname: "Cough Bronchial Syrup", productprice : "342",productcategory : "Medicine",productDiscription: "For Restful Sleep. Cough Suppressant. Expectorant. Homeopathic. Relieves Coughs. Clears Bronchial Congestion", productRating: "4.8", image: UIImage(named: "syrup")!)
        
        insert( productname: "Diarest O2(Tablets)", productprice : "320", productcategory : "Medicine",productDiscription: "Dolo-650 tablet is a very common medicine and often prescribed alone or with one or two medicine to relieve symptoms of fever, nerve pain, and pain during periods, backache, toothache, sore throat, muscle aches, strains and sprains, common colds, migraine, long-term mild to moderate pain, inflammation due to arthritis", productRating: "4.6", image: UIImage(named: "dairest")!)
        insert( productname: "Gastrolin", productprice : "220",productcategory : "Medicine",
                productDiscription: "Dolo-650 tablet is a very common medicine and often prescribed alone or with one or two medicine to relieve symptoms of fever, nerve pain, and pain during periods, backache, toothache, sore throat, muscle aches, strains and sprains, common colds, migraine, long-term mild to moderate pain, inflammation due to arthritis",productRating: "4.6", image: UIImage(named: "medicine6")!)
        insert( productname: "Biryani(4 Person)", productprice : "580", productcategory : "Food",productDiscription: "Biryani is a mixed rice dish originating among the Muslims of South Asia. It is made with Indian spices, vegetables, rice, and usually some type of meat (chicken, beef, goat, lamb, prawn, and fish), or in some cases without any meat, and sometimes, in addition, eggs and potatoes.",productRating: "4.8", image: UIImage(named: "biryani")!)
        insert( productname: "Biryani(2 Person)", productprice :"380",productcategory: "Food", productDiscription: "Biryani is a mixed rice dish originating among the Muslims of South Asia. It is made with Indian spices, vegetables, rice, and usually some type of meat (chicken, beef, goat, lamb, prawn, and fish), or in some cases without any meat, and sometimes, in addition, eggs and potatoes.",productRating: "4.8", image: UIImage(named: "foodtrack7")!)
        insert( productname: "Shahi Panner(4 Person)", productprice : "480", productcategory : "Food",productDiscription: "Shahi Paneer is a popular and delicious North Indian dish that is known for its rich and creamy texture. It is made with paneer, which is a type of Indian cottage cheese, cooked in a flavorful and aromatic tomato-based gravy. The term \"Shahi\" refers to royalty or the royal touch, indicating that this dish is considered regal and fit for special occasions.", productRating: "4.8", image: UIImage(named: "shahipaneer")!)
        insert( productname: "Coca-Cola", productprice :"180", productcategory : "Groceries",productDiscription: "The primary taste of Coca-Cola is thought to come from vanilla and cinnamon, with trace amounts of essential oils, and spices such as nutmeg.",productRating:"4.8", image: UIImage(named: "cola")!)
        insert( productname: "Cooking Oil (15L)", productprice : "2400", productcategory : "Groceries",productDiscription: "Vegetable oils, or vegetable fats, are oils extracted from seeds or from other parts of fruits. Like animal fats, vegetable fats are mixtures of triglycerides. Soybean oil, grape seed oil, and cocoa butter are examples of seed oils, or fats from seeds.",productRating: "4.3", image: UIImage(named: "groceries")!)
        insert( productname: "Toor Dal(1KG)", productprice :"220", productcategory : "Groceries",productDiscription: "Toor dal, also known as arhar dal or split pigeon peas, is a popular and widely consumed lentil variety in Indian cuisine. It is highly nutritious, rich in protein, fiber, and various vitamins and minerals. Toor dal has a mild, nutty flavor and a creamy texture when cooked.", productRating: "4.3", image: UIImage(named: "toordal")!)

        
           // Add more insert statements for your data
           
           dataInserted = true
       }
    //read Data in Database
    func read() -> [HomeProductDetails] {
        let queryStatementString = "SELECT * FROM HomeProductDetails;"
        var queryStatement: OpaquePointer? = nil
        var HomeProduct : [HomeProductDetails] = []
       
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
                    HomeProduct.append(HomeProductDetails(productname: productname, productprice: productprice, productcategory: productcategory, productid: Int(productid), productDiscription: productDiscription, productRating: productRating, image: image!))
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
    
   
    
}
