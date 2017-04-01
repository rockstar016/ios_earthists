//
//  LinkViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/31/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController {
    
    @IBOutlet weak var linkCardBtn: UIButton!
    @IBOutlet weak var botomLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        linkCardBtn.layer.cornerRadius = 7
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attrString = NSMutableAttributedString(string: "Link a Debit/Credit card to your account. Invest $7 in the artist and/or cause of your choice.  We send you an invoice each month to renew your investment and your commitment to IAM. Learn more at our website."
)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.sizeToFit()
        let attrString1 = NSMutableAttributedString(string: "When you join IAM you make a social investment that never stops giving. It All stARTs with YOU."
        )
        attrString1.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString1.length))
        botomLabel.attributedText = attrString1
        botomLabel.sizeToFit()

    }
    @IBAction func onBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onTapLinkBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("ToSavePage", sender: self)
    }
}
