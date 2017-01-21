//
//  AddressAddUpdateViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 20/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddressAddUpdateViewController: FloatingViewController {
    
    
    var PassingAddressId:String = ""
    var Action:String = ""
    
    
    @IBOutlet weak var NameText: NextResponderTextField!
    
    @IBOutlet weak var MobileNumberText: NextResponderTextField!
    
    @IBOutlet weak var AddLine1Text: NextResponderTextField!
    
    @IBOutlet weak var AddLine2Text: NextResponderTextField!
    
    @IBOutlet weak var CityText: NextResponderTextField!
    
    @IBOutlet weak var StateText: NextResponderTextField!
    
    @IBOutlet weak var CountryText: NextResponderTextField!
    
    @IBOutlet weak var PincodeText: NextResponderTextField!
    
    
    @IBOutlet weak var AddUpdateButton: UIButton!
    
    @IBAction func AddUpdateButton(_ sender: Any) {
        
        if(self.Action == "Update")
        {
            self.AddUpdateButton.setTitle("Update Address", for: .normal)
            self.UpdateAddress()
        }
        else if(self.Action == "Add")
        {
            self.AddUpdateButton.setTitle("Add Address", for: .normal)
            self.AddAddress()
        }
        
    }
    
    @IBAction func DeleteAddress(_ sender: Any) {
        
        self.DeleteAddress()
        
    }
    
    
    
    
    var onlineName:String = ""
    var onlineMobileNumber:String = ""
    var onlineAddLine1:String = ""
    var onlineAddLine2:String = ""
    var onlineCity:String = ""
    var onlineState:String = ""
    var onlineCountry:String = ""
    var onlinePincode:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.Action == "Update")
        {
            self.AddUpdateButton.setTitle("Update Address", for: .normal)
            self.FetchAddress()
        }
        else if(self.Action == "Add"){
            self.AddUpdateButton.setTitle("Add Address", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UpdateAddress(){
        
        let url = URL(string: "\(Universal.host)address_update.php")!
        
        self.onlineName = self.NameText.text!
        self.onlineAddLine1 = self.AddLine1Text.text!
        self.onlineAddLine2 = self.AddLine2Text.text!
        self.onlineCity = self.CityText.text!
        self.onlineState = self.StateText.text!
        self.onlineCountry = self.CountryText.text!
        self.onlinePincode = self.PincodeText.text!
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "addressid", values: self.PassingAddressId ))
        array.append(keyValue.init(keys: "name", values: self.onlineName))
        array.append(keyValue.init(keys: "mobile", values: self.onlineMobileNumber))
        array.append(keyValue.init(keys: "addressline1", values: self.onlineAddLine1))
        array.append(keyValue.init(keys: "addressline2", values: self.onlineAddLine2))
        array.append(keyValue.init(keys: "city", values: self.onlineCity))
        array.append(keyValue.init(keys: "state", values: self.onlineState))
        array.append(keyValue.init(keys: "country", values: self.onlineCountry))
        array.append(keyValue.init(keys: "pincode", values: self.onlinePincode))
        
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
                
                if(json["message"] == "success")
                {
                    self.showDialogue(title: "Success", msg: "Address is Updated")
                }
                
                
                UserDefaults.standard.synchronize()
                
                
            }
            DispatchQueue.main.async {
                
                
            }
            
        }
        
    }
    
    
    func FetchAddress(){
        
        let url = URL(string: "\(Universal.host)address_single.php")!
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "addressid", values: self.PassingAddressId ))
        
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
                
                for item in json["address"].arrayValue {
                    
                    self.onlineName = "\(item["Name"])"
                    self.onlineMobileNumber = "\(item["MobileNumber"])"
                    self.onlineAddLine1 = "\(item["AddressLine1"])"
                    self.onlineAddLine2 = "\(item["AddressLine2"])"
                    self.onlineCity = "\(item["city"])"
                    self.onlineState = "\(item["state"])"
                    self.onlineCountry = "\(item["country"])"
                    self.onlinePincode = "\(item["Pincode"])"
                    
                    self.NameText.text = self.onlineName
                    self.MobileNumberText.text = self.onlineMobileNumber
                    self.AddLine1Text.text = self.onlineAddLine1
                    self.AddLine2Text.text = self.onlineAddLine2
                    self.CityText.text = self.onlineCity
                    self.StateText.text = self.onlineState
                    self.CountryText.text = self.onlineCountry
                    self.PincodeText.text = self.onlinePincode
                    
                }
                
                
                UserDefaults.standard.synchronize()
                
                
            }
            DispatchQueue.main.async {
                
                
            }
            
        }
        
    }
    
    func AddAddress(){
        
        let url = URL(string: "\(Universal.host)address_add.php")!
        
        self.onlineName = self.NameText.text!
        self.onlineAddLine1 = self.AddLine1Text.text!
        self.onlineAddLine2 = self.AddLine2Text.text!
        self.onlineCity = self.CityText.text!
        self.onlineState = self.StateText.text!
        self.onlineCountry = self.CountryText.text!
        self.onlinePincode = self.PincodeText.text!
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "userid", values: Universal.UserId ))
        array.append(keyValue.init(keys: "name", values: self.onlineName))
        array.append(keyValue.init(keys: "mobile", values: self.onlineMobileNumber))
        array.append(keyValue.init(keys: "addressline1", values: self.onlineAddLine1))
        array.append(keyValue.init(keys: "addressline2", values: self.onlineAddLine2))
        array.append(keyValue.init(keys: "city", values: self.onlineCity))
        array.append(keyValue.init(keys: "state", values: self.onlineState))
        array.append(keyValue.init(keys: "country", values: self.onlineCountry))
        array.append(keyValue.init(keys: "pincode", values: self.onlinePincode))
        
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
                
                if(json["message"] == "Success")
                {
                    self.showDialogue(title: "Success", msg: "Address is Added")
                }
                
                
                UserDefaults.standard.synchronize()
                
                
            }
            DispatchQueue.main.async {
                
                
            }
            
        }
        
    }
    
    
    func DeleteAddress(){
        
        let url = URL(string: "\(Universal.host)address_delete.php")!
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "addressid", values: self.PassingAddressId ))
        
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
                
                if(json["message"] == "Success")
                {
                    self.NameText.text = ""
                    self.MobileNumberText.text = ""
                    self.AddLine1Text.text = ""
                    self.AddLine2Text.text = ""
                    self.CityText.text = ""
                    self.StateText.text = ""
                    self.CountryText.text = ""
                    self.PincodeText.text = ""
                    
                    self.showDialogue(title: "Deleted", msg: "Address Deleted Successfully")
                }
                
                UserDefaults.standard.synchronize()
                
                
            }
            DispatchQueue.main.async {
                
                
            }
            
        }
        
    }

    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    
    func showDialogue(title:String,msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
            self.performSegue(withIdentifier: "AddressViewController", sender: self)
        }
        
        // add an action (button)
        alert.addAction(cancelAction)
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        self.delay(seconds: 5.0) { () -> () in
            
            self.performSegue(withIdentifier: "AddressViewController", sender: self)
            
        }
        
    }

    
    

}
