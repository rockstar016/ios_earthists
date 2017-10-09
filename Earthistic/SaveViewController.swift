import UIKit
import Stripe
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

class SaveViewController: UIViewController {
    
    var bTextViewMove = false
    var nTextViewMoveDistance = 0
    var keyboardSize = CGSize(width: 0, height: 0)
    var month : UInt = 0
    var year : UInt = 0
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var CVCTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var monthTxt = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var yearTxt = ["2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
    @IBOutlet weak var MonthBtn: UIButton!
    @IBOutlet weak var YearBtn: UIButton!
    
    override func viewDidLoad() {
        saveBtn.layer.cornerRadius = 7
        super.viewDidLoad()
    }
    
    @IBAction func onTapMonthBtn(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Month", message: nil, preferredStyle: .actionSheet)
        monthTxt.forEach { moth in
            alertController.addAction(UIAlertAction(title: moth, style: .default) { action in
                if let title = action.title {
                    self.MonthBtn.setTitle(title, for: .normal)
                    self.month = UInt(title)!
                }
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onTapYear(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Year", message: nil, preferredStyle: .actionSheet)
        yearTxt.forEach { year in
            alertController.addAction(UIAlertAction(title: year, style: .default) { action in
                if let title = action.title {
                    self.YearBtn.setTitle(title, for: .normal)
                    self.year = UInt(title)!

                }
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onTapSaveBtn(_ sender: AnyObject) {
        let stripCard = STPCardParams()
        // Send the card info to Strip to get the token
        
        stripCard.number = cardNumberTextField.text
        stripCard.cvc = CVCTextField.text
        stripCard.expMonth = month
        stripCard.expYear = year
        if cardNumberTextField.text?.characters.count < 1, CVCTextField.text?.characters.count < 1 {
            self.showOkAlert(customTitle: "Caution", customMessage: "Please complete all required fields.")
        }
        
        STPAPIClient.shared().createToken(withCard: stripCard, completion: { token, error in
            
            if error != nil {
                
                print("error")
                return
            }
            
            self.postStripeToken(token!)
            print(token as Any)
            
        })

        //        do{
        //        try stripCard.validateCardReturningError()
//                    STPAPIClient.shared().createToken(withCard: stripCard, completion: { (token, error) -> Void in
//
//                        if error != nil {
//        
//                            print("error")
//                            return
//                        }
//        
//                        self.postStripeToken(token!)
//                        print(token as Any)
//
//                    })
        //        }
        //        catch
        //        {
        //          print(error)
        //        }
    }
    
    func postStripeToken(_ token : STPToken) {
        let user_token = MemberModel.sharedInstance.user_Token
        let params = [
            "token" : user_token,
            "stripe_token" : token,
            "index" : MemberModel.sharedInstance.sequence
            ] as [String : Any]
        _ = MyAlamofire.POST(PAYMENT_API, parameters: params as [String : AnyObject], showLoading: true,showSuccess: false,showError: true) { result, responseObject in
            print(responseObject)
            print(result)
            if result {
                if let res = responseObject.object(forKey: "result") as? Bool, res {
                    self.performSegue(withIdentifier: "ToEndPage", sender: self)
                } else {
                    self.showOkAlert(customTitle: "Caution", customMessage: "Network Error. Try again")
                }
            } else {
                self.showOkAlert(customTitle: "Caution", customMessage: "Connection is lost")
            }
        }
    }
    
    @IBAction func onTapBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}
