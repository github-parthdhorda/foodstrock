//
//  SubCategoryViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 12/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking

class SubCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var PassingCategoryId:String = ""
    var PassingSubCategoryId:String = ""
    
    var onlineSubCatId = [String]()
    var onlineSubCatLabel = [String]()
    var onlineSubCatImage = [String]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.PassingCategoryId = Universal.PassingCategoryId
//            print("Sub Category View Controller \(self.PassingCategoryId)")
//        print("SubCategory View Did Load")
        self.AsyncTask()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.onlineSubCatId.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let mycell = self.tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryTableViewCell
        
        
        mycell.SubCategoryLabel.text = self.onlineSubCatLabel[indexPath.row]
        
        let URL = NSURL(string: self.onlineSubCatImage[indexPath.row])
        let placeholder = UIImage(named: "black.jpg")!
        
        mycell.SubCategoryImage.setImageWith(URL as! URL, placeholderImage: placeholder)

        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Row \(indexPath.row + 1) Selected")
        
        self.PassingSubCategoryId =  self.onlineSubCatId[indexPath.row]
        performSegue(withIdentifier: "SubCategory_To_Items", sender: self)
//            print("PassingCategoryId = \(self.PassingCategoryId)")
    }
    
    
    func AsyncTask(){
        
        
        //        SwiftSpinner.show("Please Wait")
        
        let url = URL(string: "\(Universal.host)sub_categories.php")!
      
        
        var array = [keyValue]()
        
        array.append(keyValue.init(keys: "categoryid", values: self.PassingCategoryId ))
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
                
                self.onlineSubCatId.removeAll()
                self.onlineSubCatImage.removeAll()
                self.onlineSubCatLabel.removeAll()
                
//                print("AAappapapapa  SubCategory  \(json["subcategory"][0]["SubCategoryId"])")
                
                for item in json["subcategory"].arrayValue {
                    
                    
//                    print("\(item["SubCategoryId"])")
                    self.onlineSubCatId.append("\(item["SubCategoryId"])")
                    self.onlineSubCatLabel.append("\(item["SubCategoryName"])")
                    self.onlineSubCatImage.append("\(Universal.imagepath)sub_category/\(item["SubCategoryImage"])")
                    
                }
//                print("\(self.onl ineSubCatImage)")
                

                
                
            }
            DispatchQueue.main.async {

                self.tableView.reloadData()
                
                self.delay(seconds: 1.0) { () -> () in
                    //SwiftSpinner.hide()
//                    print("Sub Category Delay")
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
        if (segue.identifier == "SubCategory_To_Items") {
            let svc = segue.destination as! ItemViewController;
            
            svc.PassingSubCategoryId = self.PassingSubCategoryId
            
            Universal.PassingSubCategoryId = self.PassingSubCategoryId
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.PassingCategoryId = Universal.PassingCategoryId
        //            print("Sub Category View Controller \(self.PassingCategoryId)")
//        print("SubCategory View Will Appear")
        self.AsyncTask()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
