//
//  SubCategoryTableViewCell.swift
//  FoodStrock
//
//  Created by Parth Soni on 12/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SubCategoryImage: UIImageView!
    
    @IBOutlet weak var SubCategoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
