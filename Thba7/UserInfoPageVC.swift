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
    
    @IBOutlet var userInfoView: UIView!
    
    let redView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat().getScreenWidth() - 12, height: 200))
        v.backgroundColor = .red
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------------------------")
        print(passedOrderData)
        print("--------------------------")
        userInfoView.addSubview(redView)
    }
}
