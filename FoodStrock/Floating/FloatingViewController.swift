//
//  FloatingViewController.swift
//  FoodStrock
//
//  Created by Parth Soni on 20/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {
    
    var fab = KCFloatingActionButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.layoutFAB()
    }
    
    
    func layoutFAB() {
        fab.buttonImage = UIImage(named: "Menu")
        //        let item = KCFloatingActionButtonItem()
        //        item.buttonColor = UIColor.blue
        //        item.circleShadowColor = UIColor.red
        //        item.titleShadowColor = UIColor.blue
        //        item.title = "Menu"
        //        item.handler = { item in
        //
        //        }
        
        fab.addItem("I got a icon", icon: UIImage(named: "veg"))
        { item in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            
            self.present(controller, animated: true, completion: nil)
            
        }
        fab.addItem("Address", icon: UIImage(named: "addressicon"))
        { item in
//            self.performSegue(withIdentifier: "AddressView", sender: self)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            
            self.present(controller, animated: true, completion: nil)
            
        }
        
        fab.addItem("I got a handler", icon: UIImage(named: "icMap"))
        { item in
            //            self.performSegue(withIdentifier: "TestingSegue", sender: self)
        }
        
        self.view.addSubview(fab)
        
    }
    
    func KCFABOpened(_ fab: KCFloatingActionButton) {
        print("FAB Opened")
    }
    
    func KCFABClosed(_ fab: KCFloatingActionButton) {
        print("FAB Closed")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
