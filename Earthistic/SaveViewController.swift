//
//  SaveViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/31/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
import Stripe
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

class SaveViewController: UIViewController, UIActionSheetDelegate {
    var bTextViewMove: Bool = false
    var nTextViewMoveDistance: Int = 0
    var keyboardSize: CGSize = CGSize(width: 0, height: 0)
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
    @IBAction func onTapMonthBtn(_ sender: AnyObject)
    {
        let actionSheet = UIActionSheet(title: "Month", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "01","02","03","04","05","06","07","08","09","10","11","12")
      
        actionSheet.tag = 0
        actionSheet.show(in: self.view)
    }
    @IBAction func onTapYear(_ sender: AnyObject)
    {
        let actionSheet = UIActionSheet(title: "Year", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030")
        actionSheet.tag = 1
        actionSheet.show(in: self.view)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if actionSheet.tag == 0 {
            if buttonIndex >= 1{
                MonthBtn.setTitle(monthTxt[buttonIndex - 1], for: UIControlState())
                month = UInt(monthTxt[buttonIndex - 1])!
            }
           
        }else{
            if buttonIndex >= 1{
                YearBtn.setTitle(yearTxt[buttonIndex - 1], for: UIControlState())
                year = UInt(yearTxt1[buttonIndex - 1])!
            }
        }
    }
    @IBAction func onTapSaveBtn(_ sender: AnyObject) {
        let stripCard = STPCardParams()
            // Send the card info to Strip to get the token
        
            stripCard.number = cardNumberTextField.text
            stripCard.cvc = CVCTextField.text
            stripCard.expMonth = month
            stripCard.expYear = year
        if (cardNumberTextField.text?.characters.count < 1 || CVCTextField.text?.characters.count < 1)
        {
            let alertController = UIAlertController(title: "Caution", message: "Please complete all required fields.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        do{
        try stripCard.validateCardReturningError()
            STPAPIClient.shared().createToken(withCard: stripCard, completion: { (token, error) -> Void in
                
                if error != nil {

                    print("error")
                    return
                }
                
                self.postStripeToken(token!)
                print(token as Any)
                
            })
        }
        catch
        {
          print(error)
        }
    }
    func postStripeToken(_ token : STPToken) {
        let user_token = MemberModel.sharedInstance.user_Token
        let params = [
            "token" : user_token,
            "stripe_token" : token,
            "index" : MemberModel.sharedInstance.sequence
        ] as [String : Any]
        MyAlamofire.POST(PAYMENT_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { (result, responseObject)
            in
            print(responseObject)
            print(result)
            if(result){
                
                let res = responseObject.object(forKey: "result") as! Bool
                if res == true
                {
                    self.performSegue(withIdentifier: "ToEndPage", sender: self)
                }else
                {
                    let alertController = UIAlertController(title: "Caution", message: "Network Error. Try again", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                let alertController = UIAlertController(title: "Caution", message: "Connection is lost", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onTapBackBtn(_ sender: AnyObject) {
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

}
