//
//  ForgetViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/28/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
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


class ForgetViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passResetBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    var bTextViewMove: Bool = false
    var nTextViewMoveDistance: Int = 0
    var keyboardSize: CGSize = CGSize(width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        passResetBtn.layer.cornerRadius = 7
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard()
    {
        view.endEditing(true)
    }

    @IBAction func onTapBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func onTapResetButton(_ sender: AnyObject) {
        if emailTextField.text?.characters.count < 1 || passwordTextFiled.text?.characters.count < 1 || confirmTextField.text?.characters.count < 1
        {
            let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if passwordTextFiled.text?.characters.count < 6 {
            let alertController = UIAlertController(title: "Caution", message: "Password should be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        if (passwordTextFiled.text != confirmTextField.text) {
            let alertController = UIAlertController(title: "Caution", message: "Password not matched.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "new_password" : passwordTextFiled.text!
        ]
        MyAlamofire.POST(RESET_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { (result, responseObject)
            in
            if(result){
                print(result)
            }
        }

    }
}
