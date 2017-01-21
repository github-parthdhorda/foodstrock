//
//  CategoryViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 11/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AFNetworking


class CategoryViewController: FloatingViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var PassingCategoryId:String = ""
    
    var onlineCatId = [String]()
    var onlineCatLabel = [String]()
    var onlineCatImage = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController!.navigationBar.barTintColor = Universal.AppColor
//        self.navigationController!.navigationBar.isTranslucent = false
        
        self.AsyncTask()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.onlineCatId.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let mycell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        
        mycell.CategoryLabel.text = self.onlineCatLabel[indexPath.row]
        
        let URL = NSURL(string: self.onlineCatImage[indexPath.row])
        let placeholder = UIImage(named: "black.jpg")!

        
        mycell.CategoryImage.setImageWith(URL as! URL, placeholderImage: placeholder)
        
        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.PassingCategoryId =  self.onlineCatId[indexPath.row]
        performSegue(withIdentifier: "Category_To_SubCategory", sender: self)
    }

    
    func AsyncTask(){
        
        
        
        let url = URL(string: "\(Universal.host)categories.php")!
        
        
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
                
                self.onlineCatId.removeAll()
                self.onlineCatImage.removeAll()
                self.onlineCatLabel.removeAll()
                
                
                for item in json["category"].arrayValue {
                 
                        self.onlineCatId.append("\(item["CategoryId"])")
                        self.onlineCatLabel.append("\(item["CategoryName"])")
                        self.onlineCatImage.append("\(Universal.imagepath)category/\(item["CategoryImage"])")
                    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "Category_To_SubCategory") {
            let svc = segue.destination as! SubCategoryViewController;
            
            svc.PassingCategoryId = self.PassingCategoryId

            Universal.PassingCategoryId = self.PassingCategoryId
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.AsyncTask()
        
    }
    


}
