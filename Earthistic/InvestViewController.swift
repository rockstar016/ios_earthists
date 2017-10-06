//
//  InvestViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/26/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit
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

var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
class InvestViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var InvestTxtLabel: UILabel!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var causeLabel: UILabel!
    var bTextViewMove: Bool = false
    var nTextViewMoveDistance: Int = 0
    var keyboardSize: CGSize = CGSize(width: 0, height: 0)
    var causeKind : [[String]] = [["Choose Love","Water is Life"],["Race Equity"],["Gender Equity"],["Sustainable Liviing"],["Healthy Living"],["Income Equity"],["Wildlife Equity"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookBtn.layer.cornerRadius = 7
        loginBtn.layer.cornerRadius = 7
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 388)
        memberNameLabel.text = MemberModel.sharedInstance.name
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: "You've chosen to invest in " + MemberModel.sharedInstance.name + ".\nHere is where your money will be going")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        InvestTxtLabel.attributedText = attrString
        InvestTxtLabel.textAlignment = .center
        causeDetect()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    func dismissKeyboard()
    {
        view.endEditing(true)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    func causeDetect(){
        let index = MemberModel.sharedInstance.sequence
        var str : String = ""
        for i in causeKind[index] {
            str = str + i + "\n"
            causeLabel.text = str
        }
    }
    @IBAction func onTapBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onTapLoginBtn(_ sender: AnyObject) {
        if (emailTextField.text?.characters.count < 1 || passwordTextField.text?.characters.count < 1) {
            let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!
        ]
        MyAlamofire.POST(LOGIN_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { (result, responseObject)
            in
            if(result){
                let result = responseObject.object(forKey: "result") as! Bool
                if result == false{
                    let alertController = UIAlertController(title: "Caution", message: "Login Faild.", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                else{
                    let token = responseObject.object(forKey: "data") as! String
                    MemberModel.sharedInstance.user_Token = token
                    self.performSegue(withIdentifier: "ToLinkPage", sender: self)
                }
            }
        }

    }
    @IBAction func onTapForgetBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToForgetPage", sender: self)
    }

    @IBAction func onTapSignUpBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToSignUpPage", sender: self)
    }
    @IBAction func onTapFacebookBtn(_ sender: AnyObject) {
        fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email", "user_friends","public_profile"], from: self){ (result, error) -> Void in
            if (error != nil){
                
                //self.facebookBtn.setOn(false, animated: true)
            }
            else if(result?.isCancelled)!
            {
                
            }
            else
            {
                self.getFBUserData()
            }
        }
    }
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            MyAlamofire.showIndicator()
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                MyAlamofire.hideIndicator()
                if (error == nil){
                    //everything works print the user data
                    //
                    
                    if result != nil {
                        let response = result as AnyObject
                        let email = response.object(forKey: "email") as! String
                        let params = [
                            "email" : email
                        ]
                        MyAlamofire.POST(FACEBOOK_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { (result, responseObject)
                            in
                            if(result){

                                let res = responseObject.object(forKey: "result") as? Bool
                                if res == true {
                                    let token = responseObject.object(forKey: "data") as! String
                                    MemberModel.sharedInstance.user_Token = token
                                    self.performSegue(withIdentifier: "ToLinkPage", sender: self)
                                }else
                                {
                                    let alertController = UIAlertController(title: "Caution", message: "Login Faild.", preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                    return
                                }
                            }
                        }
                    }
                }
                else
                {

                }
            })
        }
    }
}
