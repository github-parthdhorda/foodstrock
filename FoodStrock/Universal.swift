//
//  MyClass.swift
//  Expandable
//
//  Created by Csoft Technology on 07/09/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit


extension Dictionary {
    public init(keyValuePairs: [(Key, Value)]) {
        self.init()
        for pair in keyValuePairs {
            self[pair.0] = pair.1
        }
    }
}

class Universal{
    
    static let imagepath="http://parthdhorda.co/app/images/"
    static let host = "http://www.parthdhorda.co/app/web/"
    
    static var AppColor = UIColor( red: CGFloat(255/255.0), green: CGFloat(34/255.0), blue: CGFloat(53/255.0), alpha: CGFloat(1.0) )
    
    static var PassingCategoryId:String = ""
    static var PassingSubCategoryId:String = ""
    static var PassingItemId:String = ""
    static var UserId:String = "1"
    static var PassingAddressId:String = ""
    
    
    static  func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func isConnectedToNetwork() -> Bool {
        
       return true
        
    }

    
    
    
}
