//
//  MemberInfoController.swift
//  Earthistic
//
//  Created by Sobura on 1/25/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
import Alamofire

class MemberInfoController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var investBtn: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var nameView: UIView!
//    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var MemberInfoLabel: UIBorderedLabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomButtonContainer: UIStackView!
    @IBOutlet weak var bottomButtonContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var memberInfoHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var header: UIView!
    
    var index : Int = 0
    
    var memberText  = ["Who is she? She is you. She is me. She is everythin' in between. She is everyone. " +
        "She is no one. She is nowhere to be seen. So where can you find her? Where will she be? Keep watchin' our videos and maybe" +
            " you’ll see. The gypc and her wild companion roam free through space and time in love, freedom, truth and delicate beauty. She wanders constantly, fervently, dancin’ in wind, floatin’ on clouds, guided from within. Follow her energy" +
        " and find answers to all questions, keys to all mysteries, treasures you only dreamed you could possess of.",
                                 
//                                 "Luckyiam is the co-founder of The World Famous Living Legends crew & one of the best solo artists on earth. " +
//                                    "He has put out many albums independently and is a major contributor to many different groups like Machina Muerte, " +
//                                    "The Prime w/Sapient and latest project Luck and Lana with the LA DubStep/HipHop collective Kill the Computer. Check out " + "his work on iTunes and SoundCloud.",
        
                                 "I’ve been creating and performing since I could stand, so I could properly project. I come from a family of artists and have had the " +
                                    "fortune of support and encouragement my whole life. I focus on gigs to get by, expanding my artistic basis by collaborating with different sources " +
        "of inspiration, always challenging myself to new levels of expression, excited for what the next day has to bring.",
                                 
                                 
                                 "Jack has been taking photos since he built a pinhole camera aged seven from card. His arresting imagery is created from his" +
                                    " passion for photography and his well known inspired attitude. Jack is based in New" +
                                    " York and London whilst passing his time snapping around the world. For Jack's" +
        " motion work, please visit broxstarfilms.com",
                                 
                                 "My name is Ewa Grochowska, on April 4, 2012 I went from being a victim to a survivor of Domestic Violence.This does not define me" +
                                    " but it has molded me into the person that I have become. In December 2013, I created" +
                                    " Freedom 4 Ewa to advocate for all of us who have been affected by domestic violence. I" +
        " volunteer my time with children living in domestic violence shelters by providing them with art programs.",
                                 
                                 "John Dardenne is a Los Angeles based comedian and writer. He has written jokes for" +
            " @iamwandasykes on FOX, Fresh Perspectives for @becbenit and sketches for @UCBTLA Maude Team." +
            " He has acted in commercials for Nintendo, Digiorno, Comcast and Phillips76. He" +
        " routinely dedicates his time to teaching improv to young ones. He performs routinely around Hollywood.",
                                 
                                 "Dandora Music is a group of young musicians from Dandora, Nairobi-Kenya. Their musical journey began in the year" +
            " 2012 after successfully graduating from Dandora Music School. All the members of" +
            " the group were born and raised in Dandora, growing up in harsh conditions faced with extreme poverty as they were" +
        " from low-income families striving to make ends meet."]
    
    var CauseName = [["CHOOSE LOVE CAUSE BIO","WATER IS LIFE CAUSE BIO"],["GENDER EQUITY CAUSE BIO"],["SUSTAINABLE LIVING CAUSE BIO"],["HEALTHY LIVING CAUSE BIO"],["INCOME EQUITY CAUSE BIO"],["WILDLIFE EQUITY CAUSE BIO"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        investBtn.layer.cornerRadius = 7
        index = MemberModel.sharedInstance.sequence
        nameLabel.text = MemberModel.sharedInstance.name
        nameLabel1.text = MemberModel.sharedInstance.name
        profileImage.image = UIImage(named: MemberModel.sharedInstance.profileImage)
        imageView.image = UIImage(named: MemberModel.sharedInstance.Image)
        
        displayCause()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: memberText[MemberModel.sharedInstance.sequence])
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        MemberInfoLabel.attributedText = attrString
        MemberInfoLabel.setNeedsLayout()
        MemberInfoLabel.layoutIfNeeded()
        MemberInfoLabel.sizeToFit()
        memberInfoHeightConstraint.constant = MemberInfoLabel.frame.height
        let size = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        header.frame.size.height = size.height
        tableView.tableHeaderView = header
        tableView.layoutIfNeeded()
        createButton()
    }
    
    func createButton() {
        buttonView.subviews.forEach { $0.removeFromSuperview() }
        let importBtnView = UIView()
        var btns = [String]()
        switch index {
        case 0:
            btns = ["1", "2"]
            break
        case 1:
            btns = ["1", "2", "3","4","5"]
            break
        case 2:
            btns = ["1", "2", "3","4","5"]
            break
        case 3:
            btns = ["1", "2", "4"]
            break
        case 4:
            btns = ["2","4","5"]
            break
        case 5:
            btns = ["1", "2","4","5"]
            break

        default:
            break
        }
        
        buttonView.layoutIfNeeded()
        let btnCount = btns.count
        let buttonViewHeight = Int(buttonView.frame.height)
        let buttonViewWidht = Int(buttonView.frame.width)
        let btnSize = Int(Double(min(buttonViewHeight, buttonViewWidht / btnCount)) * 0.65)
        let spacing = Int(Double(min(buttonViewHeight, buttonViewWidht / btnCount)) * 0.1)

        for (i, btn) in btns.enumerated() {
            let btnView = UIButton()
            btnView.frame = CGRect(x: (btnSize + spacing) * i, y: (buttonViewHeight - btnSize) / 2, width: btnSize, height: btnSize)
            btnView.setBackgroundImage(UIImage(named: btn), for: .normal)
            btnView.tag = Int(btn)!
            btnView.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
            importBtnView.addSubview(btnView)
        }
        importBtnView.layoutIfNeeded()
        importBtnView.frame = CGRect(x: (buttonViewWidht - ((btnSize + spacing) * btnCount)) / 2, y: 0, width: (btnSize + spacing) * btnCount, height: 50)
        buttonView.addSubview(importBtnView)
        
    }
    
    @objc func btnTapped(_ sender:AnyObject) {
        switch index {
        case 0:
            if sender.tag == 1 {
                let url = URL(string: "https://www.facebook.com/earthistsinc/")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 2 {
                let url = URL(string: "https://www.instagram.com/earthists_inc/")
                UIApplication.shared.openURL(url!)
            }
            break
//        case 1:
//            if sender.tag == 1 {
//                let url = URL(string: "https://www.facebook.com/luckylegends/")
//                UIApplication.shared.openURL(url!)
//            }
//            if sender.tag == 2 {
//                let url = URL(string: "https://www.instagram.com/luckydoot1/")
//                UIApplication.shared.openURL(url!)
//            }
//            if sender.tag == 3 {
//                let url = URL(string: "https://soundcloud.com/legendarymusic")
//                UIApplication.shared.openURL(url!)
//            }
//            if sender.tag == 4 {
//                let url = URL(string: "https://twitter.com/LuckyovLegends")
//                UIApplication.shared.openURL(url!)
//            }
//            if sender.tag == 5 {
//                let url = URL(string: "https://www.youtube.com/channel/UC43tEsKAB324l7Qla8QpQFA")
//                UIApplication.shared.openURL(url!)
//            }
//            break
        case 1:
            if sender.tag == 1 {
                let url = URL(string: "https://www.facebook.com/thereallanashea")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 2 {
                let url = URL(string: "https://www.instagram.com/lalanashea/")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 3 {
                let url = URL(string: "https://soundcloud.com/lanashea")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 4 {
                let url = URL(string: "https://twitter.com/lalanashea")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 5 {
                let url = URL(string: "https://www.youtube.com/user/LanaSheaKicksIt")
                UIApplication.shared.openURL(url!)
            }
            break
        case 2:
            if sender.tag == 2 {
                let url = URL(string: "https://www.instagram.com/hijack/")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 4 {
                let url = URL(string: "https://twitter.com/HIJACK")
                UIApplication.shared.openURL(url!)
            }
            break
        case 3:
            if sender.tag == 1 {
                let url = URL(string: "https://www.facebook.com/ewa.m.grochowska")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 2 {
                let url = URL(string: "https://www.instagram.com/freedom4ewa/")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 4 {
                let url = URL(string: "https://twitter.com/Freedom4Ewa")
                UIApplication.shared.openURL(url!)
            }
            break
        case 4:
            if sender.tag == 2 {
                let url = URL(string: "https://www.instagram.com/johndardenne/")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 4 {
                let url = URL(string: "https://twitter.com/johndardenne")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 5 {
                let url = URL(string: "https://www.youtube.com/user/Dardenne")
                UIApplication.shared.openURL(url!)
            }
            break
        case 5:
            if sender.tag == 1 {
                let url = URL(string: "https://www.facebook.com/dandoramusic")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 2 {
                let url = URL(string: "https://www.instagram.com/dandoramusic/")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 4 {
                let url = URL(string: "https://twitter.com/dandoramusic")
                UIApplication.shared.openURL(url!)
            }
            if sender.tag == 5 {
                let url = URL(string: "https://www.youtube.com/user/dandoramusic")
                UIApplication.shared.openURL(url!)
            }
            break
        default:
            break
        }
    }
    
    func displayCause()  {
        bottomButtonContainer.layoutIfNeeded()
        let buttonWidth = Int(bottomButtonContainer.frame.width - 16)
        let buttonHeight = 40

        for (i, name) in CauseName[index].enumerated() {
            let button = UIButton()
            button.tag = index * 10 + i
            button.setTitle(name, for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            button.titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 15)
            button.backgroundColor = UIColor(red: 67/255, green: 255/255, blue: 125/255, alpha: 1.0)
            button.layer.cornerRadius = 7
            button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
            self.bottomButtonContainer.addArrangedSubview(button)
        }
        bottomButtonContainerHeightConstraint.constant = CGFloat((buttonHeight + 16) * CauseName[index].count)
        
    }
    
    @objc func pressed(_ sender : UIButton){
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "causeView") as! CauseViewController
        popoverContent.index = Int(sender.tag / 10)
        popoverContent.selectedbutton = sender.tag % 10
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func onTapBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapInvestBtn(_ sender: AnyObject) {
        let token = MemberModel.sharedInstance.user_Token
        if token == "" {
            performSegue(withIdentifier: "ToInvestPage", sender: self)
        } else {
            let params = [
                "token" : token
            ]
            _ = MyAlamofire.POST(CHECKTOKEN_API, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: true) { result, responseObject in
                if result {
                    if let result = responseObject.object(forKey: "result") as? Bool, result {
                        self.performSegue(withIdentifier: "FromMemberToLink", sender: self)
                    } else {
                        self.showOkAlert(customTitle: "Caution", customMessage: "Connection Error")
                    }
                }
            }
        }
    }
}

extension MemberInfoController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }

    
}
