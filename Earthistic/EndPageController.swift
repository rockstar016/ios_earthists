import UIKit
class EndPageController: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 7
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: "Welcome Earthist to the Intelligent Art Movement. We will keep you up to date with what is happening with your cause and artist by the email you provided. We are excited to have you join our community of sharers.")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.sizeToFit()
    }
    
    @IBAction func onTapOKButton(_ sender: AnyObject) {
        if let navigationController = navigationController {
            let myViewControllers = navigationController.viewControllers
            myViewControllers.forEach { myViewController in
                if myViewController is ViewController {
                    self.navigationController?.popToViewController(myViewController, animated: true)
                    return
                }
            }
        }
        
        
    }
}
