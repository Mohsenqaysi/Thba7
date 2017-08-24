//
//  VerifySMSCodeViewController.swift
//  SMS Verifying
//
//  Created by Mohsen Qaysi on 8/14/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class VerifySMSCodeViewController: UIViewController {
    struct UnwindIdentifier {
        static let unwindTo_PhoneNumber_ID = "unwindTo_UserInfoTableViewController_PhoneNumber"
    }
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var number = ""
    let appID = "sejrLD_Wnr6HwJPHNbYVS29XvPO1gu" // Get it from the Nnifonic Website
    
    let numberVerifedText = "تم تأكيد رقمك ... شكراً"
    let number_Not_VerifedText = "لم تم تأكيد رقمك ... الرجاء أدخال الرقم الصحيح"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        phoneNumberLabel.text = number
        self.codeTextField.delegate = self
    }
    
    func codeVerification() {
        
        
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        self.loader.isHidden = false
        self.loader.startAnimating()
        
        let url = URL(string: "http://api.unifonic.com/rest/Verify/VerifyNumber")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let code = codeTextField.text, codeTextField.text != "" else {
            print("Code Number is Worng")
            return
        }
        request.httpBody = "AppSid=\(appID)&Recipient=\(number)&PassCode=\(code)".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response, let data = data {
                let status = JSON(response)
                let result = JSON(data)
                print("Status: \(status)\nResult: \(result)\n\n")
                if result["success"].stringValue == "true" {
                    print(result["success"].stringValue)
                    DispatchQueue.main.async {
                        self.statusLabel.text = self.numberVerifedText
                        self.performSegue(withIdentifier: UnwindIdentifier.unwindTo_PhoneNumber_ID, sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Someting went worng")
                        self.statusLabel.text = self.number_Not_VerifedText
                        self.loader.isHidden = true
                        self.loader.stopAnimating()
                    }
                }
            } else {
                print(error!)
            }
        }
        task.resume()
        self.loader.isHidden = true
        self.loader.stopAnimating()
    }
}


extension VerifySMSCodeViewController: UITextFieldDelegate {
    
    func phoneNumberTextField(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let numberInput = codeTextField.text else { return true }
        let newLength = numberInput.characters.count + string.characters.count - range.length
        return newLength <= 4
    }
}
