//
//  GroupImageCell.swift
//  signin
//
//  Created by Shannon Ding on 7/18/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit

class GroupImageCell: UICollectionViewCell {
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupOptionsButton: UIButton!
    
    @IBAction func groupOptionsButtonTapped(_ sender: UIButton) {
        didTapOptionsButtonForCell?(self)
    }
    var didTapOptionsButtonForCell: ((GroupImageCell) -> Void)?
}
