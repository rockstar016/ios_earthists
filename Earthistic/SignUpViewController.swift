//
//  SignUpViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/28/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
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
    var bTextViewMove: Bool = false
    var nTextViewMoveDistance: Int = 0
    var keyboardSize: CGSize = CGSize(width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.layer.cornerRadius = 7
        verificationView.alpha = 0.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func onTapLoginBtn(_ sender: AnyObject) {

        self.navigationController?.popViewController(animated: true)
    }
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardSize.height = 250
        
        var textFieldOrigin = textField.superview?.convert(textField.frame.origin, to: nil)
        textFieldOrigin?.y += textField.frame.size.height
        let textFieldHeight = textField.frame.size.height
        var visibleRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height + 40
        
        if (!visibleRect.contains(textFieldOrigin!)) {
            textFieldOrigin!.y -= textField.frame.size.height
            
            let dist = Int(textFieldOrigin!.y - visibleRect.size.height + textFieldHeight)
            animateTextField(textField, up: true, distance: dist)
            bTextViewMove = true
            nTextViewMoveDistance = dist
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (bTextViewMove) {
            animateTextField(textField, up: false, distance: nTextViewMoveDistance)
            bTextViewMove = false
        }
    }
    func animateTextField(_ textField: UITextField, up: Bool, distance: Int) {
        let movementDuration = 0.3
        let movement = (up ? -distance:distance)
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
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
        if verificationView.alpha == 0.0
        {
            if emailTextField.text?.characters.count < 1 {
                let alertController = UIAlertController(title: "Caution", message: "Please insert your email.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let params = [
                "email" : emailTextField.text!
            ]
            MyAlamofire.POST(SIGNUP1_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { (result, responseObject)
                in
                if(result){
                    print(responseObject)
                    let res = responseObject.object(forKey: "result") as! Bool

                    if res == false
                    {
                        let txt = responseObject.object(forKey: "data") as! NSDictionary
                        let content = txt.object(forKey: "email") as! NSArray
                        let alertController = UIAlertController(title: "Caution", message: content[0] as? String, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else
                    {
                        self.checkBoxBtn.isChecked = true
                        self.verificationView.alpha = 1.0
                    }
                }
            }
        }
        if self.verificationView.alpha == 1.0
        {
            
            if (emailTextField.text?.characters.count < 1 || passwordTextField.text?.characters.count < 1 || codeofEmailTextField.text?.characters.count < 1)
            {
                let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            if passwordTextField.text?.characters.count < 6 {
                let alertController = UIAlertController(title: "Caution", message: "Password should be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let params = [
                    "email" : emailTextField.text!,
                    "email_verification_token" : codeofEmailTextField.text!,
                    "password" : passwordTextField.text!
                ]
                MyAlamofire.POST(SIGNUP2_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { (result, responseObject)
                    in
                    if(result){
                        let result = responseObject.object(forKey: "result") as! Bool
                        if result == false
                        {
                            let alertController = UIAlertController(title: "Caution", message: "SignUp Faild", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {

                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
