import UIKit
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


class ForgetViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passResetBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    var bTextViewMove: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passResetBtn.layer.cornerRadius = 7
    }

    @IBAction func onTapBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onTapResetButton(_ sender: AnyObject) {
        if emailTextField.text?.characters.count < 1,  passwordTextFiled.text?.characters.count < 1, confirmTextField.text?.characters.count < 1 {
            self.showOkAlert(customTitle: "Caution", customMessage: "Please complete all required fields.")
            return
        }
        if passwordTextFiled.text?.characters.count < 6 {
            self.showOkAlert(customTitle: "Caution", customMessage: "Password should be at least 6 characters")
            return
        }

        if passwordTextFiled.text != confirmTextField.text {
            self.showOkAlert(customTitle: "Caution", customMessage: "Password not matched.")
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "new_password" : passwordTextFiled.text!
        ]
        _ = MyAlamofire.POST(RESET_API, parameters: params as [String : AnyObject],showLoading: true, showSuccess: false,showError: true)
            {
                (result, responseObject) in
                if(result)
                {
                    self.showOkAlert(customTitle: "Info", customMessage: "Success to reset Password")
                }
                else
                {
                    self.showOkAlert(customTitle: "Warning", customMessage: "Failed to reset Password")
                }
            }
    }
}
