//
//  RankCell.swift
//  arrow
//
//  Created by david robertson on 11/16/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {

    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
