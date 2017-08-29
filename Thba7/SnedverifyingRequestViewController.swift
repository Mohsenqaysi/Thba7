//
//  SnedVerifyingRequestViewController.swift
//  SMS Verifying
//
//  Created by Mohsen Qaysi on 8/14/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class SnedVerifyingRequestViewController: UIViewController {
    
    let segueKey = "goToCodeVerifyPage"
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var countryCode = "353"
    var formatedNumber = ""
    let appID = "sejrLD_Wnr6HwJPHNbYVS29XvPO1gu" // Get it from the Nnifonic Website
    let masseage = "كود التفعيل - Activiation Code: "

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        self.phoneNumberTextField.delegate = self
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loader.isHidden = true
        self.loader.startAnimating()
    }
    
    @IBAction func sendButtonSMS(_ sender: Any) {
        
        self.loader.isHidden = false
        self.loader.startAnimating()
        
        guard let number = phoneNumberTextField.text, phoneNumberTextField.text != "" else {
            print("Phone Number is Worng")
            self.loader.startAnimating()
            return
        }
        
        formatedNumber = countryCode.appending(number)
        print("Formated #: \(formatedNumber)")
        handelCodeVerificationRequeste(userNumber: formatedNumber)
    }
    
    func handelCodeVerificationRequeste(userNumber: String){
        let url = URL(string: "http://api.unifonic.com/rest/Verify/GetCode")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "AppSid=\(appID)&Recipient=\(userNumber)&Body=\(masseage)".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response , let data = data {
                let status = JSON(response)
                let result = JSON(data)
                print("Status: \(status)\nResult: \(result)")
                if result["success"].stringValue == "true" {
                    print(result["success"].stringValue)
                    DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.segueKey, sender: self)
                    }
                }else{
                    print("Someting went worng")
                }
            } else {
                print(error!)
            }
        }
        task.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueKey {
            if let vc = segue.destination as? VerifySMSCodeViewController {
                vc.number = formatedNumber
                self.loader.isHidden = true
                self.loader.stopAnimating()
            }
        }
    }
}

extension SnedVerifyingRequestViewController : UITextFieldDelegate {
    
    func phoneNumberTextField(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let numberInput = phoneNumberTextField.text else { return true }
        let newLength = numberInput.characters.count + string.characters.count - range.length
        return newLength <= 9
    }
}
