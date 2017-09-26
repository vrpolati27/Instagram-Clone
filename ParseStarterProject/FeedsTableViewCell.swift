//
//  FeedsTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Vinay Reddy Polati on 9/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
