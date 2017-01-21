//
//  LoginViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 11/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet weak var txt_Password: UITextField!
    
    var loginType:String = ""
    
    
    @IBAction func btn_Login(_ sender: Any) {
    
        
        loginType="Normal";
        
        if(!Universal.isConnectedToNetwork()){
            showDialogue(title: "Required", msg: "Internet not available");                 return
        }
        else if(self.txt_Email.text=="" || self.txt_Password.text==""){
            showDialogue(title: "Required", msg: "Please enter username and password.");   return
        }
        else if(!Universal.isValidEmail(testStr: self.txt_Email.text!)){
            showDialogue(title: "Required", msg: "Enter valid E-mail");                     return
        }
        else{
            
            self.AsyncTask()
            
        }

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()



        if let key = UserDefaults.standard.string(forKey: "status"){
            
            if(key == "Yes_Login")
            {
                print("Key\(key)")
            }
            
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    func AsyncTask(){
    
        
//        SwiftSpinner.show("Please Wait")

        let url = URL(string: "\(Universal.host)login.php")!
        
        let email = self.txt_Email.text!
        let password = self.txt_Password.text!

        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "email", values:email ))
        array.append(keyValue.init(keys: "password", values:password ))
        let myDictionary = Dictionary(keyValuePairs: array.map{($0.key, $0.value)})
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"

        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: myDictionary, options: [])
        } catch {
            // No-op
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(url, withMethod: .post, parameters: myDictionary).responseData { response in
//            debugPrint("All Response Info: \(response)")
            if let data = response.result.value {
                
                
                let json = JSON(data: data)
                
                print("Cust ID       \(json["data"][0]["CustId"])")
                
                for item in json["data"].arrayValue {
                    
                    
                    Universal.UserId = "\(item["CustId"])"
                    UserDefaults.standard.setValue("\(item["CustId"])", forKey: "CustomerId")
                    UserDefaults.standard.setValue("\(item["CustFirstname"])", forKey: "CustFirstname")
                    UserDefaults.standard.setValue("\(item["CustLastname"])", forKey: "CustLastname")
                    UserDefaults.standard.setValue("\(item["CustEmailid"])", forKey: "CustEmailid")
                    UserDefaults.standard.setValue("\(item["CustMob"])", forKey: "CustMob")
                    UserDefaults.standard.setValue("\(item["ProfilePic"])", forKey: "ProfilePic")
                    
                    UserDefaults.standard.setValue("Yes_Login", forKey: "status")
                    
                    UserDefaults.standard.synchronize()

                }
                
                if(json["message"] == "Success")
                {
                    print(json["message"])
                    self.movetoanotherview(UIButton.self)
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    //  self.movetoanotherview(sender: UIButton())
                    
                }
                
//                SwiftSpinner.hide()
                
            }
            
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func movetoanotherview(_ sender: AnyObject)
    {
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "CategoryViewSegue", sender: self)
        }
    }
    
    func showDialogue(title:String,msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }

    

}
