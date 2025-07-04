//
//  MyOrdersDetails.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 01/07/23.
//



import Foundation
import UIKit
//HomeProductDetails in Database
class MyOrdersDetails {
    var productname: String = ""
    var productprice: String = ""
    var productcategory: String = ""
    var productDiscription: String = ""
    var productRating:String = ""
    var image:UIImage
    init(productname: String, productprice: String, productcategory: String, productid: Int,productDiscription:String,productRating:String,image:UIImage) {
        self.productname = productname
        self.productprice = productprice
        self.productcategory = productcategory
        self.productDiscription = productDiscription
        self.productRating = productRating
        self.image = image
      
    }
    
    
}

