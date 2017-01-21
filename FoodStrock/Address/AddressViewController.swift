//
//  AddressViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 20/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddressViewController: FloatingViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var PassingAddressId:String = ""
    var PassingAction:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    var onlineAddId = [String]()
    var onlineAddName = [String]()
    var onlineAddMobile = [String]()
    var onlineAddLine1 = [String]()
    var onlineAddLine2 = [String]()
    var onlineAddCityState = [String]()
    var onlineAddCountryPincode = [String]()
    
    
    @IBAction func AddAddress(_ sender: Any) {
        
        self.PassingAction = "Add"
        performSegue(withIdentifier: "AddUpdateAddress", sender: self)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("4")
        self.AsyncTask()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.onlineAddId.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let mycell = self.tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableViewCell
        
        
        mycell.AddName.text = self.onlineAddName[indexPath.row]
        mycell.AddMobile.text = self.onlineAddMobile[indexPath.row]
        mycell.AddLine1.text = self.onlineAddLine1[indexPath.row]
        mycell.AddLine2.text = self.onlineAddLine2[indexPath.row]
        mycell.AddCityState.text = self.onlineAddCityState[indexPath.row]
        mycell.AddCountryPincode.text = self.onlineAddCountryPincode[indexPath.row]
        
        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Row \(onlineAddId[indexPath.row])")
        self.PassingAddressId =  self.onlineAddId[indexPath.row]
        self.PassingAction = "Update"
        performSegue(withIdentifier: "AddUpdateAddress", sender: self)
    }
    
    
    func AsyncTask(){
        
        
        
        let url = URL(string: "\(Universal.host)address.php")!
        
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "userid", values: Universal.UserId ))
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
                
                self.onlineAddId.removeAll()
                self.onlineAddName.removeAll()
                self.onlineAddMobile.removeAll()
                self.onlineAddLine2.removeAll()
                self.onlineAddLine2.removeAll()
                self.onlineAddCityState.removeAll()
                self.onlineAddCountryPincode.removeAll()
                
                
                for item in json["address"].arrayValue {
                    
                    self.onlineAddId.append("\(item["AddressId"])")
                    self.onlineAddName.append("\(item["Name"])")
                    self.onlineAddMobile.append("\(item["MobileNumber"])")
                    self.onlineAddLine1.append("\(item["AddressLine1"])")
                    self.onlineAddLine2.append("\(item["AddressLine2"])")
                    self.onlineAddCityState.append("\(item["city"]) , \(item["state"])")
                    self.onlineAddCountryPincode.append("\(item["country"]) - \(item["Pincode"])")
        
                }
                
                UserDefaults.standard.synchronize()
                
                
            }
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
                self.delay(seconds: 1.0) { () -> () in
                    
                    //                        print("Delay")
                }
            }
            
        }
        
    }
    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "AddUpdateAddress") {
            let svc = segue.destination as! AddressAddUpdateViewController;
            
            svc.PassingAddressId = self.PassingAddressId
            svc.Action = self.PassingAction
            Universal.PassingAddressId = self.PassingAddressId
            
        }
    }

    

}
