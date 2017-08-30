//
//  CartOrdersItemsCell.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class CartOrdersItemsCell: UITableViewCell {
    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderCutTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
