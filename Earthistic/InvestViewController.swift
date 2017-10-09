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
//    var bTextViewMove = false

    var causeKind = [["Choose Love","Water is Life"],["Race Equity"],["Gender Equity"],["Sustainable Liviing"],["Healthy Living"],["Income Equity"],["Wildlife Equity"]]
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
        if emailTextField.text?.characters.count < 1, passwordTextField.text?.characters.count < 1 {
            self.showOkAlert(customTitle: "Caution", customMessage: "Please complete all required fields.")
            return
        }
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!
        ]
        _ = MyAlamofire.POST(LOGIN_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { result, responseObject in
            if result {
                if let res = responseObject.object(forKey: "result") as? Bool, res{
                    let token = responseObject.object(forKey: "data") as! String
                    MemberModel.sharedInstance.user_Token = token
                    self.performSegue(withIdentifier: "ToLinkPage", sender: self)
                }
                else{
                    self.showOkAlert(customTitle: "Caution", customMessage: "Failed to log in")
                }
            }
            else
            {
                self.showOkAlert(customTitle: "Caution", customMessage: "Failed to log in")
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
        
        fbLoginManager.logIn(withReadPermissions: ["email", "user_friends","public_profile"], from: self) { result, error in
            if error != nil {
                
                //self.facebookBtn.setOn(false, animated: true)
            } else if(result?.isCancelled)! {
                
            } else{
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            MyAlamofire.showIndicator()
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { connection, result, error in
                MyAlamofire.hideIndicator()
                if error == nil {
                    if result != nil {
                        let response = result as AnyObject
                        let email = response.object(forKey: "email") as! String
                        let params = [
                            "email" : email
                        ]
                        _ = MyAlamofire.POST(FACEBOOK_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { result, responseObject in
                            if result {
                                if let res = responseObject.object(forKey: "result") as? Bool, res {
                                    let token = responseObject.object(forKey: "data") as! String
                                    MemberModel.sharedInstance.user_Token = token
                                    self.performSegue(withIdentifier: "ToLinkPage", sender: self)
                                }
                                else {
                                   self.showOkAlert(customTitle: "Caution", customMessage: "Failed to log in")
                                    return;
                                }
                            }
                        }
                    }
                    else {
                        self.showOkAlert(customTitle: "Caution", customMessage: "Failed to log in")
                        return;
                    }
                } else {
                    self.showOkAlert(customTitle: "Caution", customMessage: "Failed to log in")
                    return;
                }
            })
        }
    }
}
