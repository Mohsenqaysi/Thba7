//
//  OrderPageVCCell.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/2/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class OrderPageVCCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        testLabel.textAlignment = .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        testLabel.textAlignment = .right
        
    }

}
