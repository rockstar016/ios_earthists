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
    var keyboardSize: CGSize = CGSizeMake(0, 0)
    var causeKind : [[String]] = [["Choose Love","Water is Life"],["Race Equity"],["Gender Equity"],["Sustainable Liviing"],["Healthy Living"],["Income Equity"],["Wildlife Equity"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookBtn.layer.cornerRadius = 7
        loginBtn.layer.cornerRadius = 7
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 388)
        memberNameLabel.text = MemberModel.sharedInstance.name
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: "You've chosen to invest in " + MemberModel.sharedInstance.name + ".\nHere is where your money will be going")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        InvestTxtLabel.attributedText = attrString
        InvestTxtLabel.textAlignment = .Center
        causeDetect()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    func dismissKeyboard()
    {
        view.endEditing(true)
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    func causeDetect(){
        let index = MemberModel.sharedInstance.sequence
        var str : String = ""
        for i in causeKind[index] {
            str = str + i + "\n"
            causeLabel.text = str
        }
    }
    @IBAction func onTapBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onTapLoginBtn(sender: AnyObject) {
        if (emailTextField.text?.characters.count < 1 || passwordTextField.text?.characters.count < 1) {
            let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!
        ]
        MyAlamofire.POST(LOGIN_API, parameters: params,showLoading: true,showSuccess: false,showError: true,search:false) { (result, responseObject)
            in
            if(result){
                let result = responseObject.objectForKey("result") as! Int
                if result == 0{
                    let alertController = UIAlertController(title: "Caution", message: "Login Faild.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                else{
                    let token = responseObject.objectForKey("data") as! String
                    MemberModel.sharedInstance.user_Token = token
                    self.performSegueWithIdentifier("ToLinkPage", sender: self)
                }
            }
        }

    }
    @IBAction func onTapForgetBtn(sender: AnyObject) {
        performSegueWithIdentifier("ToForgetPage", sender: self)
    }

    @IBAction func onTapSignUpBtn(sender: AnyObject) {
        performSegueWithIdentifier("ToSignUpPage", sender: self)
    }
    @IBAction func onTapFacebookBtn(sender: AnyObject) {
        fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["email", "user_friends","public_profile"], fromViewController: self){ (result, error) -> Void in
            if (error != nil){
                
                //self.facebookBtn.setOn(false, animated: true)
                print("dddddddddddddd")
            }
            else if(result.isCancelled)
            {
                print("drdrdrdrdrdr")

            }
            else
            {
                print("ccccccccccccccc")
                self.getFBUserData()


            }
        }
    }
    func getFBUserData()
    {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            MyAlamofire.showIndicator()
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                MyAlamofire.hideIndicator()
                if (error == nil){
                    //everything works print the user data
                    //
                    if result != nil {
                        let email = result.objectForKey("email") as! String
                        let params = [
                            "email" : email
                        ]
                        MyAlamofire.POST(FACEBOOK_API, parameters: params,showLoading: true,showSuccess: false,showError: true,search:false) { (result, responseObject)
                            in
                            if(result){
                                print(responseObject)
                                let res = responseObject.objectForKey("result") as! Int
                                if res == 1 {
                                    let token = responseObject.objectForKey("data") as! String
                                    MemberModel.sharedInstance.user_Token = token
                                    self.performSegueWithIdentifier("ToLinkPage", sender: self)
                                }else
                                {
                                    let alertController = UIAlertController(title: "Caution", message: "Login Faild.", preferredStyle: UIAlertControllerStyle.Alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                                    }
                                    alertController.addAction(okAction)
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                    return
                                }
                            }
                        }
                    }
                }
                else
                {
                    print(error.localizedDescription)
                }
            })
        }
    }
}
