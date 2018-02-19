//
//  PitcherTableViewCell.swift
//  Bierdeckel
//
//  Created by Werner on 19.02.18.
//  Copyright © 2018 WeRoServices. All rights reserved.
//

import UIKit

class PitcherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var pitcherName: UILabel!
    @IBOutlet weak var pitcherUhrzeit: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
