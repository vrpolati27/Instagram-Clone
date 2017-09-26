//
//  UserCellController.swift
//  ParseStarterProject-Swift
//
//  Created by Vinay Reddy Polati on 9/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class UserCellController: UITableViewCell {

    @IBOutlet weak var objectIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
