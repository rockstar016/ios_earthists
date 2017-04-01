//
//  ForgetViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/28/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passResetBtn: UIButton!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    var bTextViewMove: Bool = false
    var nTextViewMoveDistance: Int = 0
    var keyboardSize: CGSize = CGSizeMake(0, 0)
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

    @IBAction func onTapBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        keyboardSize.height = 250
        
        var textFieldOrigin = textField.superview?.convertPoint(textField.frame.origin, toView: nil)
        textFieldOrigin?.y += textField.frame.size.height
        let textFieldHeight = textField.frame.size.height
        var visibleRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height + 40
        
        if (!CGRectContainsPoint(visibleRect, textFieldOrigin!)) {
            textFieldOrigin!.y -= textField.frame.size.height
            
            let dist = Int(textFieldOrigin!.y - visibleRect.size.height + textFieldHeight)
            animateTextField(textField, up: true, distance: dist)
            bTextViewMove = true
            nTextViewMoveDistance = dist
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (bTextViewMove) {
            animateTextField(textField, up: false, distance: nTextViewMoveDistance)
            bTextViewMove = false
        }
    }
    
    func animateTextField(textField: UITextField, up: Bool, distance: Int) {
        let movementDuration = 0.3
        let movement = (up ? -distance:distance)
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement))
        UIView.commitAnimations()
    }
    @IBAction func onTapResetButton(sender: AnyObject) {
        if emailTextField.text?.characters.count < 1 || passwordTextFiled.text?.characters.count < 1 || confirmTextField.text?.characters.count < 1
        {
            let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if passwordTextFiled.text?.characters.count < 6 {
            let alertController = UIAlertController(title: "Caution", message: "Password should be at least 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }

        if (passwordTextFiled.text != confirmTextField.text) {
            let alertController = UIAlertController(title: "Caution", message: "Password not matched.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "new_password" : passwordTextFiled.text!
        ]
        MyAlamofire.POST(RESET_API, parameters: params,showLoading: true,showSuccess: false,showError: true,search:false) { (result, responseObject)
            in
            if(result){
                print(result)
            }
        }

    }
}
