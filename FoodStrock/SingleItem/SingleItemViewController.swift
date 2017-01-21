//
//  SingleItemViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 16/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking

class SingleItemViewController: UIViewController {
    
    
    var PassingItemId:String = ""
    
    
    @IBOutlet weak var ItemImage: UIImageView!
    
    @IBOutlet weak var Veg: UIImageView!
    
    @IBOutlet weak var ItemName: UILabel!
    
    @IBOutlet weak var ItemDesc: UILabel!
    
    @IBOutlet weak var ItemPrice: UILabel!
    
    @IBOutlet weak var ItemQuantity: UILabel!
    
    @IBOutlet weak var TotalPrice: UILabel!
    
    var onlineItemId:String = ""
    var onlineItemImage:String = ""
    var onlineVeg:String = ""
    var onlineItemName:String = ""
    var onlineItemDesc:String = ""
    var onlineItemPrice:String = ""
    var onlineItemQuantity:String = ""
    var TotalItemPrice:String = ""
    var single_counter: Int = 1
    
    @IBAction func AddToCart(_ sender: Any) {
        
        self.Add_To_Cart()
        
        
        
//        self.performSegue(withIdentifier: "SingleToItems", sender: self)
        
    }
    
    @IBAction func AddQuantity(_ sender: Any) {
        
        if(single_counter < 10)
        {
            single_counter += 1
            self.ItemQuantity.text = String(self.single_counter)
            
            let rate = single_counter * Int(self.ItemPrice.text!)!
            self.TotalPrice.text = String(rate)
        }
        
        
    }
    
    @IBAction func RemoveQuantity(_ sender: Any) {
        
        if(single_counter > 1)
        {
            single_counter -= 1
            self.ItemQuantity.text = String(self.single_counter)
            
            let rate = single_counter * Int(self.ItemPrice.text!)!
            self.TotalPrice.text = String(rate)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController!.navigationBar.barTintColor = Universal.AppColor
//        self.navigationController!.navigationBar.isTranslucent = false
        
        self.PassingItemId = Universal.PassingItemId
        self.AsyncTask()
    }
    
    
    func AsyncTask(){
        
        
//                SwiftSpinner.show("Please Wait")
        
        let url = URL(string: "\(Universal.host)single_item.php")!
        
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "itemid", values: self.PassingItemId))
        let myDictionary = Dictionary(keyValuePairs: array.map{($0.key, $0.value)})
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: myDictionary, options: [])
        } catch {
            // No-operation
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(url, withMethod: .post, parameters: myDictionary).responseData { response in
            //            debugPrint("All Response Info: \(response)")
            if let data = response.result.value {
                
                
                let json = JSON(data: data)
                
                //                print("AAappapapapa  Item  \(json["item"][0]["ItemId"])")
                
                for item in json["item"].arrayValue {
                    
                    
                    //                    print("\(item["ItemId"])")
                    
                    self.onlineItemId = "\(item["ItemId"])"
                    self.onlineItemName = "\(item["ItemName"])"
                    self.onlineItemDesc = "\(item["Description"])"
                    self.onlineItemImage = "\(Universal.imagepath)item/\(item["ItemImage"])"
                    self.onlineVeg = "\(item["veg"])"
                    self.onlineItemPrice = "\(item["ItemPrice"])"
                    
                    self.ItemName.text = self.onlineItemName
                    self.ItemDesc.text = self.onlineItemDesc
                    self.ItemPrice.text = self.onlineItemPrice
                    self.TotalPrice.text = self.onlineItemPrice
                    
                    let URL = NSURL(string: self.onlineItemImage)
                    let placeholder = UIImage(named: "black.jpg")!
                    self.ItemImage.setImageWith(URL as! URL, placeholderImage: placeholder)
                    
                    if(self.onlineVeg == "0")
                    {
                        self.Veg.image = UIImage(named: "veg.jpg")
                    }
                    else if(self.onlineVeg == "1")
                    {
                        self.Veg.image = UIImage(named: "nonveg.jpg")
                    }
                    
                }
                
                
            }
            DispatchQueue.main.async {
                
                self.delay(seconds: 1.0) { () -> () in
                    SwiftSpinner.hide()
                    //                    print("Item Delay")
                }
            }
            
        }
        
    }
    
    func Add_To_Cart(){
        
        
        
        let url = URL(string: "\(Universal.host)add_to_cart.php")!
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "itemid", values: self.PassingItemId))
        array.append(keyValue.init(keys: "userid", values: Universal.UserId))
        array.append(keyValue.init(keys: "quantity", values: self.ItemQuantity.text!))
        let myDictionary = Dictionary(keyValuePairs: array.map{($0.key, $0.value)})
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: myDictionary, options: [])
        } catch {
            // No-operation
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(url, withMethod: .post, parameters: myDictionary).responseData { response in
            
            if let data = response.result.value {
                
                
                let json = JSON(data: data)
                
                if("\(json["message"])" == "Success")
                {
                    self.showDialogue(title: "Success", msg: "Item Added to Cart Successfully")
                }
                else if("\(json["message"])" == "Limit-Exit")
                {
                    self.showDialogue(title: "Max", msg: "You already added 10 Quantity")
                }
                
            }
            DispatchQueue.main.async {
                
                self.delay(seconds: 1.0) { () -> () in
                    SwiftSpinner.hide()
                    //                    print("Item Delay")
                }
            }
            
        }
        
    }
    
    
    func showDialogue(title:String,msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
            self.performSegue(withIdentifier: "SingleToItems", sender: self)
        }

        
        // add an action (button)
        alert.addAction(cancelAction)
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        self.delay(seconds: 5.0) { () -> () in
            
            self.performSegue(withIdentifier: "SingleToItems", sender: self)
            
        }
        
    }

    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
