//
//  SnedverifyingRequestViewController.swift
//  SMS Verifying
//
//  Created by Mohsen Qaysi on 8/14/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import SinchVerification

class SnedverifyingRequestViewController: UIViewController {
    
    let segueKey = "goToCodeVerifyPage"
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var verification: Verification!
    var applicationKey = "48b2c223-0c89-4876-9f0c-913d99ef135a"
    
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
            return
        }
        verification = SMSVerification(applicationKey, phoneNumber: number)
        //        verification = CalloutVerification(applicationKey, phoneNumber: number, custom: "Mohsen")
        verification.initiate { (respnse, error) in
            
            if error != nil {
                print("SMSVerification Erro Someing is wrong: \(respnse.success)")
                print(error.debugDescription)
            }
            
//            guard let result = respnse.success else {
//                print("Someing is wrong: \(respnse.success)")
//                return
//            }
            
            print("result: \(respnse.success)")
            self.performSegue(withIdentifier: self.segueKey, sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueKey {
            if let vc = segue.destination as? VerifySMSCodeViewController {
                
                guard let number = phoneNumberTextField.text, phoneNumberTextField.text != "" else {
                    print("Phone Number is Worng")
                    return
                }
                vc.verification = self.verification
                vc.number = number
                self.loader.isHidden = true
                self.loader.stopAnimating()
            }
        }
    }
}

extension SnedverifyingRequestViewController : UITextFieldDelegate {
    
    func phoneNumberTextField(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

