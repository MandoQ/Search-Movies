//
//  FavoritesTableViewCell.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/8/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
