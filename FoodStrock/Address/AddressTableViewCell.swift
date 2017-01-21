//
//  AddressTableViewCell.swift
//  FoodStrock
//
//  Created by Parth Soni on 20/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AddName: UILabel!
    
    @IBOutlet weak var AddMobile: UILabel!
    
    @IBOutlet weak var AddLine1: UILabel!
    
    @IBOutlet weak var AddLine2: UILabel!
    
    @IBOutlet weak var AddCityState: UILabel!
    
    @IBOutlet weak var AddCountryPincode: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
