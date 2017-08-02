//
//  HomeCollectionViewCell.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 7/31/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpView()
    }
    
    func setUpView(){
        buyButton.backgroundColor = UIColor(red:0.25, green:0.79, blue:0.46, alpha:1.0)
        // MARK: - CardView Layout
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = false
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
    }
}
