//
//  SaveViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/31/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
import Stripe
class SaveViewController: UIViewController, UIActionSheetDelegate {
    var bTextViewMove: Bool = false
    var nTextViewMoveDistance: Int = 0
    var keyboardSize: CGSize = CGSizeMake(0, 0)
    var month : UInt = 0
    var year : UInt = 0
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var CVCTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    var monthTxt : [String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var yearTxt : [String] = ["2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
    var yearTxt1 : [String] = ["17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var YearBtn: UIButton!
    override func viewDidLoad() {
        saveBtn.layer.cornerRadius = 7
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func onTapMonthBtn(sender: AnyObject)
    {
        let actionSheet = UIActionSheet(title: "Month", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "01","02","03","04","05","06","07","08","09","10","11","12")
      
        actionSheet.tag = 0
        actionSheet.showInView(self.view)
    }
    @IBAction func onTapYear(sender: AnyObject)
    {
        let actionSheet = UIActionSheet(title: "Year", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030")
        actionSheet.tag = 1
        actionSheet.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if actionSheet.tag == 0 {
            if buttonIndex >= 1{
                MonthBtn.setTitle(monthTxt[buttonIndex - 1], forState: .Normal)
                month = UInt(monthTxt[buttonIndex - 1])!
            }
           
        }else{
            if buttonIndex >= 1{
                YearBtn.setTitle(yearTxt[buttonIndex - 1], forState: .Normal)
                year = UInt(yearTxt1[buttonIndex - 1])!
            }
        }
    }
    @IBAction func onTapSaveBtn(sender: AnyObject) {
        let stripCard = STPCard()
            // Send the card info to Strip to get the token
            stripCard.number = cardNumberTextField.text
            stripCard.cvc = CVCTextField.text
            stripCard.expMonth = month
            stripCard.expYear = year
        if (cardNumberTextField.text?.characters.count < 1 || CVCTextField.text?.characters.count < 1)
        {
            let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        do{
        try stripCard.validateCardReturningError()
            STPAPIClient.sharedClient().createTokenWithCard(stripCard, completion: { (token, error) -> Void in
                
                if error != nil {
                    return
                    print("error")
                }
                
                self.postStripeToken(token!)
                print(token)
                
            })
        }
        catch
        {
          print(error)
        }
    }
    func postStripeToken(token : STPToken) {
        let user_token = MemberModel.sharedInstance.user_Token
        let params = [
            "token" : user_token,
            "stripe_token" : token,
            "index" : MemberModel.sharedInstance.sequence
        ]
        MyAlamofire.POST(PAYMENT_API, parameters: params,showLoading: true,showSuccess: false,showError: true,search:false) { (result, responseObject)
            in
            print(responseObject)
            print(result)
            if(result){
                
                let res = responseObject.objectForKey("result") as! Int
                if res == 1
                {
                    self.performSegueWithIdentifier("ToEndPage", sender: self)
                }else
                {
                    let alertController = UIAlertController(title: "Caution", message: "Network Error. Try again", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            else{
                let alertController = UIAlertController(title: "Caution", message: "Connection is lost", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onTapBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func dismissKeyboard()
    {
        view.endEditing(true)
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

}
