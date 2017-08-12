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

class UserInfoPageVC: UIViewController, UITextFieldDelegate {
    
    var passedOrderData = [String]()
    
    let scrollingView: UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: 2500, height: 1)
        //        v.isUserInteractionEnabled = true
        v.isScrollEnabled = true
        v.showsVerticalScrollIndicator = true
        v.alwaysBounceVertical = true
        v.alwaysBounceHorizontal = false
        return v
    }()
    
    let redView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let blueView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let greenView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let userName: UITextField = {
        let v = UITextField()
        v.placeholder = "الأسم (*)"
        v.keyboardType = .asciiCapable
        v.textAlignment = .right
        return v
    }()
    
    let userAddress: UITextField = {
        let v = UITextField()
        v.placeholder = "العنوان (*)"
        v.keyboardType = .asciiCapable
        v.textAlignment = .right
        return v
    }()
    
    let userPhoneNumber: UITextField = {
        let v = UITextField()
        v.placeholder = "رقم الجوال (*)"
        v.keyboardType = .numberPad
        v.textAlignment = .right
        return v
    }()
    
    let userNameSepearator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return v
    }()
    
    let userAddressSepearator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return v
    }()
    
    let userPhoneNumberSepearator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return v
    }()
    
    let deliveryInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "عنوان التوصيل"
        label.textColor = UIColor(red:0.35, green:0.35, blue:0.36, alpha:1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------------------------")
        print(passedOrderData)
        print("--------------------------")
//        self.userName.delegate = self
        // add the scrollingView inside the View
        view.addSubview(scrollingView) // add to rootView
        scrollingView.addSubview(deliveryInfoLabel)
        scrollingView.addSubview(redView) // Red
        redView.addSubview(userName) // userName Insdie RedView
        redView.addSubview(userNameSepearator) // lineSepearator
        redView.addSubview(userAddress) // userAddress Insdie RedView
        redView.addSubview(userAddressSepearator) // lineSepearator
        redView.addSubview(userPhoneNumber) // userPhoneNumber Insdie RedView
//        redView.addSubview(userPhoneNumberSepearator) // lineSepearator
        scrollingView.addSubview(blueView) // Blue
        scrollingView.addSubview(greenView) // Green
        
        
        guard let navSize = self.navigationController?.navigationBar.frame.size.height else {return}
        
        let redViewHeight: CGFloat = 100.0
        
        _ = scrollingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 5 , leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        _ = deliveryInfoLabel.anchor(top: scrollingView.topAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0,widthConstant: 0, heightConstant: redViewHeight / 3)
        
        _ = redView.anchor(top: deliveryInfoLabel.bottomAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: redViewHeight)
        
        // name
        _ = userName.anchor(top: redView.topAnchor, left: redView.leftAnchor, bottom: nil, right: redView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: redViewHeight / 3)
        _ = userNameSepearator.anchor(top: userName.bottomAnchor, left: redView.leftAnchor, bottom: nil, right: redView.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        // Address
        _ = userAddress.anchor(top: userName.bottomAnchor, left: redView.leftAnchor, bottom: nil, right: redView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: redViewHeight / 3)
        _ = userAddressSepearator.anchor(top: userAddress.bottomAnchor, left: redView.leftAnchor, bottom: nil, right: redView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        // Phone Number
        _ = userPhoneNumber.anchor(top: userAddress.bottomAnchor, left: redView.leftAnchor, bottom: nil, right: redView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: redViewHeight / 3)
//        _ = userPhoneNumberSepearator.anchor(top: userPhoneNumber.bottomAnchor, left: redView.leftAnchor, bottom: redView.bottomAnchor, right: redView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        
        _ = blueView.anchor(top: redView.bottomAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat().getScreenWidth(), heightConstant: 400)
        
        _ = greenView.anchor(top: blueView.bottomAnchor, left: scrollingView.leftAnchor, bottom: scrollingView.bottomAnchor, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat().getScreenWidth(), heightConstant: 400)
        
    }
}
