//
//  EventCollectionViewCell.swift
//  signin
//
//  Created by Shannon Ding on 7/21/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventOptionsButton: UIButton!
    
    @IBAction func eventsOptionButtonTapped(_ sender: UIButton) {
        didTapOptionsButtonForCell?(self)
    }
    
    var didTapOptionsButtonForCell: ((EventCollectionViewCell) -> Void)?
}
