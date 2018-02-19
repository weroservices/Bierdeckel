//
//  AWMTableViewCell.swift
//  Bierdeckel
//
//  Created by Werner on 19.02.18.
//  Copyright © 2018 WeRoServices. All rights reserved.
//

import UIKit

class AWMTableViewCell: UITableViewCell {

    @IBOutlet weak var awmName: UILabel!
    @IBOutlet weak var awmDatum: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
