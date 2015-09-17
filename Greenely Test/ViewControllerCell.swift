//
//  ViewControllerCell.swift
//  Greenely Test
//
//  Created by Giwrgos Gens on 17/09/15.
//  Copyright © 2015 Rene Gens. All rights reserved.
//

import UIKit

class ViewControllerCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameViewers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
