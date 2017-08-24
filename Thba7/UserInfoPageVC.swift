//
//  UserInfoPageVC.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/7/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Firebase
import Spring


//struct OrderInfo {
//    var animaleImage: UIImageView?
//    var animaleNameOrdered: String?
//    var size: String?
//    var cutType: String?
//    var countity: String?
//}

class UserInfoPageVC: UIViewController, UIGestureRecognizerDelegate {
    
    let segueKey = "goToVerifyPage"
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
    
    let userInfoViewContiner: SpringView = {
        let v = SpringView()
        v.backgroundColor = .white
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let orderInfoViewContiner: SpringView = {
        let v = SpringView()
        v.backgroundColor = .blue
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let locationOnMapInfoContinerView: SpringView = {
        let v = SpringView()
        v.backgroundColor = .green
        v.viewCardThemeWithCornerRadius(radius: 7)
        return v
    }()
    
    let userName: UITextField = {
        let v = UITextField()
        v.placeholder = "الأسم (*)"
        v.keyboardType = .asciiCapable
        v.returnKeyType = .done
        v.borderStyle = .roundedRect
        v.textAlignment = .right
        return v
    }()
    
    let userAddress: UITextField = {
        let v = UITextField()
        v.placeholder = "العنوان (*)"
        v.keyboardType = .asciiCapable
        v.returnKeyType = .done
        v.borderStyle = .roundedRect
        v.textAlignment = .right
        return v
    }()
    
    lazy var userPhoneNumber: UIView = {
        let v = UIView()
        //        v. = "رقم الجوال (*)"
        let gestur = UITapGestureRecognizer(target: self, action: #selector(handelPhoneNumber(sender:)))
        gestur.delegate = self
        v.addGestureRecognizer(gestur)
        return v
    }()
    
    
    let userPhoneNumberLabel: SpringLabel = {
        let label = SpringLabel()
        label.text = "رقم الجوال (*)"
        label.textColor = UIColor(red:0.35, green:0.35, blue:0.36, alpha:0.5)
        label.textAlignment = .right
        label.layer.cornerRadius = 7
        label.layer.borderWidth = 1
        label.layer.masksToBounds = false
        label.layer.borderColor = UIColor(red:0.35, green:0.35, blue:0.36, alpha:0.7).cgColor
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    func handelPhoneNumber(sender: UIGestureRecognizer)  {
        print("gesture tap: \(sender.state)")
        self.performSegue(withIdentifier: self.segueKey, sender: sender)
    }
    
    @IBAction func unwindToUserInfoPageVC(segue: UIStoryboardSegue) {
        print("UserInfoPageVC ... form unwind Call")
        if let userVerifedPhoneNumber = segue.source as? VerifySMSCodeViewController {
            userPhoneNumberLabel.text = userVerifedPhoneNumber.number
            print(userVerifedPhoneNumber.number)
        }
    }
    
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
    
    let deliveryInfoLabel: SpringLabel = {
        let label = SpringLabel()
        label.text = "عنوان التوصيل"
        label.textColor = UIColor(red:0.35, green:0.35, blue:0.36, alpha:1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let submitButton: UIButton = {
        let bnt = UIButton(type: .system)
        bnt.backgroundColor = UIColor(red:0.25, green:0.79, blue:0.46, alpha:1.0)
        bnt.viewCardTheme()
        bnt.setTitle("أرسل الطلب", for: UIControlState.normal)
        bnt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bnt.addTarget(self, action: #selector(handelSubmitButton), for: .touchUpInside)
        return bnt
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
        setUpSubmitButton()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    func userInfoContinerView() {
        // MARK: Add views to the ContinerView
        userInfoViewContiner.addSubview(userName) // userName Insdie userInfoViewContiner
        userInfoViewContiner.addSubview(userNameSepearator) // lineSepearator
        userInfoViewContiner.addSubview(userAddress) // userAddress Insdie userInfoViewContiner
        userInfoViewContiner.addSubview(userAddressSepearator) // lineSepearator
        userInfoViewContiner.addSubview(userPhoneNumber) // userPhoneNumber Insdie userInfoViewContiner
        userPhoneNumber.addSubview(userPhoneNumberLabel) // add userPhoneNumberLabel insdie the userPhoneNumber View
        
        self.userName.delegate = self
        self.userAddress.delegate = self
        //        self.handelPhoneNumber
        // name
        _ = userName.anchor(top: userInfoViewContiner.topAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        _ = userNameSepearator.anchor(top: userName.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        // Address
        _ = userAddress.anchor(top: userName.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        _ = userAddressSepearator.anchor(top: userAddress.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        // Phone Number
        _ = userPhoneNumber.anchor(top: userAddress.bottomAnchor, left: userInfoViewContiner.leftAnchor, bottom: nil, right: userInfoViewContiner.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 3, rightConstant: 12, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        _ = userPhoneNumberLabel.anchor(top: userPhoneNumber.topAnchor, left: userPhoneNumber.leftAnchor, bottom: userPhoneNumber.bottomAnchor, right: userPhoneNumber.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: userInfoViewContinerHeight / 3)
        
        //Add done button to userPhoneNumber pad keyboard
        //        userPhoneNumber.inputAccessoryView = toolBarAndDoneButtonUserNumber
        
        // Animation
        // Animation
        deliveryInfoLabel.animation = "fadeInLeft"
        deliveryInfoLabel.delay = 0.5
        deliveryInfoLabel.animate()
        userInfoViewContiner.animation = "fadeInDown"
        userInfoViewContiner.delay = 0.5
        userInfoViewContiner.animate()
    }
    
    func handeluserPhoneNumberDoneButton()  {
        userPhoneNumber.endEditing(true)
    }
    
    func orderInfoContinerView() {
        scrollingView.addSubview(orderInfoViewContiner) // Blue
        _ = orderInfoViewContiner.anchor(top: userInfoViewContiner.bottomAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat().getScreenWidth(), heightConstant: 400)
        
        // Animation
        orderInfoViewContiner.animation = "fadeInLeft"
        orderInfoViewContiner.delay = 0.5
        orderInfoViewContiner.animate()
    }
    
    func userLocationOnMapInfoContinerView() {
        scrollingView.addSubview(locationOnMapInfoContinerView) // Green
        _ = locationOnMapInfoContinerView.anchor(top: orderInfoViewContiner.bottomAnchor, left: scrollingView.leftAnchor, bottom: nil, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat().getScreenWidth(), heightConstant: 400)
        
        // Animation
        locationOnMapInfoContinerView.animation = "fadeInLeft"
        locationOnMapInfoContinerView.delay = 0.3
        locationOnMapInfoContinerView.animate()
    }
    
    func setUpSubmitButton() {
        scrollingView.addSubview(submitButton)
        _ = submitButton.anchor(top: locationOnMapInfoContinerView.bottomAnchor, left: scrollingView.leftAnchor, bottom: scrollingView.bottomAnchor, right: scrollingView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        // Animation
        userInfoViewContiner.animation = "fadeInDown"
        userInfoViewContiner.delay = 0.3
        userInfoViewContiner.animate()
    }
    
    func handelSubmitButton() {
        
        guard let name = userName.text, userName.text != "" else {
            userNameSepearator.enableErrorIndecatorLayer(textField: userName)
            return
        }
        
        userNameSepearator.disableErrorIndecatorLayer(textField: userName)
        guard let addree = userAddress.text, userAddress.text != "" else {
            userAddressSepearator.enableErrorIndecatorLayer(textField: userAddress)
            return
        }
        
        userAddressSepearator.disableErrorIndecatorLayer(textField: userAddress)
        
        //        guard let phoneNumber = userPhoneNumber.text, (userPhoneNumber.text?.characters.count)! == 10 else {
        //            print("Wrong Number")
        //            userPhoneNumberSepearator.enablePhoneNumberErrorIndecatorLayer(textField: userPhoneNumber)
        //            return
        //        }
        
        //        userPhoneNumberSepearator.disablePhoneNumberErrorIndecatorLayer(textField: userPhoneNumber)
        print("\(name) - \(addree) - ") //\(phoneNumber)")
    }
}

extension UserInfoPageVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userPhoneNumber {
            print("I am userPhoneNumber... ")
        }
    }
}

extension UIView {
    
    func enableErrorIndecatorLayer(textField: UITextField) {
        let errorColor: UIColor = UIColor(red:0.83, green:0.00, blue:0.00, alpha:1.0)
        self.layer.backgroundColor = errorColor.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: errorColor])
    }
    
    func disableErrorIndecatorLayer(textField: UITextField) {
        self.layer.backgroundColor = UIColor.white.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func enablePhoneNumberErrorIndecatorLayer(textField: UITextField) {
        let errorColor: UIColor = UIColor(red:0.83, green:0.00, blue:0.00, alpha:1.0)
        textField.text = ""
        let errorMasge = "الرجاء أدخل رقم جوال صحيح"
        textField.attributedPlaceholder = NSAttributedString(string: errorMasge, attributes: [NSForegroundColorAttributeName: errorColor])
    }
    
    func disablePhoneNumberErrorIndecatorLayer(textField: UITextField) {
        textField.textColor = UIColor(red:0.25, green:0.79, blue:0.46, alpha:1.0)
    }
}
