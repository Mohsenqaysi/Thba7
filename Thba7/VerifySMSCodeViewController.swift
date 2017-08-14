//
//  VerifySMSCodeViewController.swift
//  SMS Verifying
//
//  Created by Mohsen Qaysi on 8/14/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import SinchVerification

class VerifySMSCodeViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var verification: Verification!
    var applicationKey = "48b2c223-0c89-4876-9f0c-913d99ef135a"
    var number = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        phoneNumberLabel.text = number
        self.codeTextField.delegate = self
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        self.loader.isHidden = false
        self.loader.startAnimating()
        guard let code = codeTextField.text, codeTextField.text != "" else {
            print("Code Number is Worng")
            return
        }
        verification.verify(code) { (staus, err) in
            if err != nil {
                print("Code Number is Worng")
                self.statusLabel.text = " الكود المدخل غير صحيح"
                self.loader.isHidden = true
                self.loader.stopAnimating()
            } else {
                print("staus succsued: \(staus)")
                self.statusLabel.text = " تم التسجيل بنجاح"
                self.statusLabel.textColor = .green
                self.performSegue(withIdentifier: "unwindToUserInfoPageVC", sender: self)
            }
        }
        self.loader.isHidden = true
        self.loader.stopAnimating()
    }
}


extension VerifySMSCodeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
