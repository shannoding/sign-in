//
//  EventAttendeeTableViewCell.swift
//  signin
//
//  Created by Shannon Ding on 8/4/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit

class EventAttendeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attendeeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
