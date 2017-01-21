//
//  ItemViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 13/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var PassingSubCategoryId:String = ""
    var PassingItemId:String = ""
    
    var onlineItemId = [String]()
    var onlineItemLabel = [String]()
    var onlineItemImage = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController!.navigationBar.barTintColor = Universal.AppColor
//        self.navigationController!.navigationBar.isTranslucent = false
        
        self.PassingSubCategoryId = Universal.PassingSubCategoryId
//        print("Item View Controller \(self.PassingSubCategoryId)")
//        print("Items View Did Load")
        self.AsyncTask()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.onlineItemId.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let mycell = self.tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        
        mycell.ItemLabel.text = self.onlineItemLabel[indexPath.row]
        
        let URL = NSURL(string: self.onlineItemImage[indexPath.row])
        let placeholder = UIImage(named: "black.jpg")!
        
        mycell.ItemImage.setImageWith(URL as! URL, placeholderImage: placeholder)
        
        
        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Row \(indexPath.row + 1) Selected")
        
        self.PassingItemId =  self.onlineItemId[indexPath.row]
        performSegue(withIdentifier: "PerticularItem", sender: self)
//                    print("PassingItemId = \(self.PassingItemId)")
    }
    
    func AsyncTask(){
        
        
        //        SwiftSpinner.show("Please Wait")
        
        let url = URL(string: "\(Universal.host)item.php")!
        
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "subcategoryid", values: self.PassingSubCategoryId ))
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
                
                self.onlineItemId.removeAll()
                self.onlineItemImage.removeAll()
                self.onlineItemLabel.removeAll()
                
//                print("AAappapapapa  Item  \(json["item"][0]["ItemId"])")
                
                for item in json["item"].arrayValue {
                    
                    
//                    print("\(item["ItemId"])")
                    self.onlineItemId.append("\(item["ItemId"])")
                    self.onlineItemLabel.append("\(item["ItemName"])")
                    self.onlineItemImage.append("\(Universal.imagepath)item/\(item["ItemImage"])")
                    
                }
//                print("\(self.onlineItemImage)")
                
                
                
                
            }
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
                self.delay(seconds: 1.0) { () -> () in
                    //SwiftSpinner.hide()
//                    print("Item Delay")
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
        if (segue.identifier == "PerticularItem") {
            let svc = segue.destination as! SingleItemViewController;
            
            svc.PassingItemId = self.PassingItemId
            
            Universal.PassingItemId = self.PassingItemId
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.PassingSubCategoryId = Universal.PassingSubCategoryId
        //        print("Item View Controller \(self.PassingSubCategoryId)")
//        print("Items View Will Appear Function")
        self.AsyncTask()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
