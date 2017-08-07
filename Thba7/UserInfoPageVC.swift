//
//  UserInfoPageVC.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/7/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit


private struct OrderInfo {
    var animaleImage: UIImageView?
    var animaleNameOrdered: String?
    var size: String?
    var cutType: String?
    var countity: String?
}

class UserInfoPageVC: UIViewController {

    var passedOrderData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------------------------")
        print(passedOrderData)
        print("--------------------------")
    }
}
