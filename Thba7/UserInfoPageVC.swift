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
    let userInfoViewContinerHeight: CGFloat = 100.0
    
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
    
    let userInfoViewContiner: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let orderInfoViewContiner: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let locationOnMapInfoContinerView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let userName: UITextField = {
        let v = UITextField()
        v.placeholder = "الأسم (*)"
        v.keyboardType = .asciiCapable
        v.returnKeyType = .done
        v.textAlignment = .right
        return v
    }()
    
    let userAddress: UITextField = {
        let v = UITextField()
        v.placeholder = "العنوان (*)"
        v.keyboardType = .asciiCapable
        v.returnKeyType = .done
        v.textAlignment = .right
        return v
    }()
    
    let userPhoneNumber: UITextField = {
        let v = UITextField()
        v.placeholder = "رقم الجوال (*)"
        v.keyboardType = .numberPad
        //        v.adjustsFontSizeToFitWidth = true
        v.textAlignment = .right
        return v
    }()
    
    let toolBarAndDoneButtonUserNumber: UIToolbar = {
        let toolBarAndDoneButtonUserNumber = UIToolbar()
        toolBarAndDoneButtonUserNumber.sizeToFit()
        let barBtnDone = UIBarButtonItem(title: "تم", style: .done, target: self, action: #selector(handeluserPhoneNumberDoneButton))
        toolBarAndDoneButtonUserNumber.setItems([barBtnDone], animated: true) // You can even add cancel button too
        return toolBarAndDoneButtonUserNumber
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
        scrollViewContiner()
    }
    func scrollViewContiner() {
        // Add the scrollingView inside the View
        view.addSubview(scrollingView) // add to rootView
        scrollingView.addSubview(deliveryInfoLabel)
        scrollingView.addSubview(userInfoViewContiner) // userInfoContinerView
        
        _ = scrollingView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 5 , leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        _ = deliveryInfoLabel.anchor(top: scrollingView.topAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0,widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        
        _ = userInfoViewContiner.anchor(top: deliveryInfoLabel.bottomAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: userInfoViewContinerHeight)
        
        // MARK: Add other Subviews
        userInfoContinerView()
        orderInfoContinerView()
        userLocationOnMapInfoContinerView()
        
    }
    
    func userInfoContinerView() {
        // MARK: Add views to the ContinerView
        userInfoViewContiner.addSubview(userName) // userName Insdie userInfoViewContiner
        userInfoViewContiner.addSubview(userNameSepearator) // lineSepearator
        userInfoViewContiner.addSubview(userAddress) // userAddress Insdie userInfoViewContiner
        userInfoViewContiner.addSubview(userAddressSepearator) // lineSepearator
        userInfoViewContiner.addSubview(userPhoneNumber) // userPhoneNumber Insdie userInfoViewContiner
        
        self.userName.delegate = self
        self.userAddress.delegate = self
        self.userPhoneNumber.delegate = self
        
        // name
        _ = userName.anchor(top: userInfoViewContiner.topAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        _ = userNameSepearator.anchor(top: userName.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        // Address
        _ = userAddress.anchor(top: userName.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        _ = userAddressSepearator.anchor(top: userAddress.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        // Phone Number
        _ = userPhoneNumber.anchor(top: userAddress.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 3, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 4)
        
        //Add done button to userPhoneNumber pad keyboard
        userPhoneNumber.inputAccessoryView = toolBarAndDoneButtonUserNumber
    }
    
    func handeluserPhoneNumberDoneButton()  {
        userPhoneNumber.endEditing(true)
    }
    
    func orderInfoContinerView() {
        scrollingView.addSubview(orderInfoViewContiner) // Blue
        _ = orderInfoViewContiner.anchor(top: userInfoViewContiner.bottomAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat().getScreenWidth(), heightConstant: 400)
    }
    
    func userLocationOnMapInfoContinerView() {
        scrollingView.addSubview(locationOnMapInfoContinerView) // Green
        _ = locationOnMapInfoContinerView.anchor(top: orderInfoViewContiner.bottomAnchor, left: scrollingView.leftAnchor, bottom: scrollingView.bottomAnchor, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat().getScreenWidth(), heightConstant: 400)
    }
}

extension UserInfoPageVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
