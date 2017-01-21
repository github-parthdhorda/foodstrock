//
//  ItemTableViewCell.swift
//  FoodStrock
//
//  Created by Parth Soni on 13/01/17.
//  Copyright © 2017 Parth Soni. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ItemImage: UIImageView!
    
    @IBOutlet weak var ItemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
