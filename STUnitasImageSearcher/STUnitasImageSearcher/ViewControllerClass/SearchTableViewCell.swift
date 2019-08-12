//
//  SearchTableViewCell.swift
//  STUnitasImageSearcher
//
//  Created by 강진석 on 11/08/2019.
//  Copyright © 2019 jskang. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var searchImageView: UIImageView!
    @IBOutlet var collectionLabel: UILabel!
    
    @IBOutlet var siteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
