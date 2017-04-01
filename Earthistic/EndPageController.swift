//
//  EndPageController.swift
//  Earthistic
//
//  Created by Sobura on 2/4/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

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
    @IBAction func onTapOKButton(sender: AnyObject) {


        let myControllers = self.navigationController?.viewControllers
        
        for mController in myControllers!
        {
            if mController is ViewController
            {
                self.navigationController?.popToViewController(mController, animated: true)
                return
            }
        }
    }
}
