import UIKit
import Alamofire
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var codeofEmailTextField: UITextField!
    @IBOutlet weak var checkBoxBtn: CheckBox!
    @IBOutlet weak var verificationView: UIView!
    var bTextViewMove = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.layer.cornerRadius = 7
        verificationView.alpha = 0.0
    }
    
    @IBAction func onTapLoginBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapCheckBtn(_ sender: CheckBox) {
        if checkBoxBtn.isChecked == false {
            verificationView.alpha = 1.0
            signUpBtn.setTitle("Register", for: UIControlState())
        }
        if checkBoxBtn.isChecked == true {
            verificationView.alpha = 0.0
            signUpBtn.setTitle("Verify Email Address", for: UIControlState())
        }
    }

    @IBAction func onTapSignUpBtn(_ sender: AnyObject) {
        if verificationView.alpha == 0.0 {
            if emailTextField.text?.characters.count < 1 {
                self.showOkAlert(customTitle: "Caution", customMessage: "Please enter your email.")
                return
            }
            let params = [
                "email" : emailTextField.text!
            ]
            _ = MyAlamofire.POST(SIGNUP1_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { result, responseObject in
                if result {
                    
                    let res = responseObject.object(forKey: "result") as! Bool
                    if res == false {
                        let txt = responseObject.object(forKey: "data") as! NSDictionary
                        let content = txt.object(forKey: "email") as! NSArray
                        self.showOkAlert(customTitle: "Caution", customMessage: (content[0] as? String)!)
                    } else {
                        self.checkBoxBtn.isChecked = true
                        self.verificationView.alpha = 1.0
                    }
                }
                else
                {
                    self.showOkAlert(customTitle: "Caution", customMessage: "Connection error. Try again")
                }
            }
        }
        if self.verificationView.alpha == 1.0 {
            if (emailTextField.text?.characters.count < 1 || passwordTextField.text?.characters.count < 1 || codeofEmailTextField.text?.characters.count < 1) {
                self.showOkAlert(customTitle: "Caution", customMessage: "Please complete all required fields.")
            }
            if passwordTextField.text?.characters.count < 6 {
                self.showOkAlert(customTitle: "Caution", customMessage:  "Password should be at least 6 characters")
            } else {
                let params = [
                    "email" : emailTextField.text!,
                    "email_verification_token" : codeofEmailTextField.text!,
                    "password" : passwordTextField.text!
                ]
               MyAlamofire.POST(SIGNUP2_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { result, responseObject in
                    if result {
                        if let res = responseObject.object(forKey: "result") as? Bool, res {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.showOkAlert(customTitle: "Caution", customMessage: "Failed to Signup")
                        }
                    }
                    else
                    {
                        self.showOkAlert(customTitle: "Caution", customMessage: "Failed to Signup")
                    }
                }
            }
        }
    }
}
