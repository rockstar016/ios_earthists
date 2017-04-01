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
   
    @IBOutlet weak var investBtn: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var MemberInfoLabel: UIBorderedLabel!
    @IBOutlet weak var imageView: UIImageView!
    var index : Int = 0
    @IBOutlet weak var scrollView: UIScrollView!
    var memberText : [String] = ["Who is she? She is you. She is me. She is everythin' in between. She is everyone. " +
        "She is no one. She is nowhere to be seen. So where can you find her? Where will she be? Keep watchin' our videos and maybe" +
            " you’ll see. The gypc and her wild companion roam free through space and time in love, freedom, truth and delicate beauty. She wanders constantly, fervently, dancin’ in wind, floatin’ on clouds, guided from within. Follow her energy" +
        " and find answers to all questions, keys to all mysteries, treasures you only dreamed you could possess of.",
                                 
                                 "Luckyiam is the co-founder of The World Famous Living Legends crew & one of the best solo artists on earth. " +
                                    "He has put out many albums independently and is a major contributor to many different groups like Machina Muerte, " +
                                    "The Prime w/Sapient and latest project Luck and Lana with the LA DubStep/HipHop collective Kill the Computer. Check out " + "his work on iTunes and SoundCloud.",
                                 
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
    
    var CauseName : [[String]] = [["CHOOSE LOVE CAUSE BIO","WATER IS LIFE CAUSE BIO"],["RACE EQUITY CAUSE BIO"],["GENDER EQUITY CAUSE BIO"],["SUSTAINABLE LIVING CAUSE BIO"],["HEALTHY LIVING CAUSE BIO"],["INCOME EQUITY CAUSE BIO"],["WILDLIFE EQUITY CAUSE BIO"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        investBtn.layer.cornerRadius = 7
        index = MemberModel.sharedInstance.sequence
        nameLabel.text = MemberModel.sharedInstance.name
        nameLabel1.text = MemberModel.sharedInstance.name
        profileImage.image = UIImage(named: MemberModel.sharedInstance.profileImage)
        imageView.image = UIImage(named: MemberModel.sharedInstance.Image)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: memberText[MemberModel.sharedInstance.sequence])
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length ))
        MemberInfoLabel.attributedText = attrString

        MemberInfoLabel.sizeToFit()
        displayCause()
        createButton()
    }
    func createButton(){
        let importBtnView : UIView = UIView()
        var btns:[String] = []
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
            btns = ["1", "2", "3","4","5"]
            break
        case 4:
            btns = ["1", "2", "4"]
            break
        case 5:
            btns = ["2","4","5"]
            break
        case 6:
            btns = ["1", "2","4","5"]
            break
        default:
            break
        }
        let btncount = btns.count
        importBtnView.frame = CGRect(x: 0, y: 0, width: 50 * btncount, height: 50)

        var i = 0
        for btn in btns
        {
            let btnView = UIButton()
            
            btnView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btnView.setBackgroundImage(UIImage(named: btn), forState: .Normal)
            let dx = importBtnView.frame.width/CGFloat(btncount)
            btnView.center = CGPoint(x: dx/2 + CGFloat(i) * dx, y: importBtnView.frame.height/2)
            btnView.tag = Int(btn)!
            btnView.addTarget(self, action: #selector(self.btnTapped(_:)), forControlEvents: .TouchUpInside)
            importBtnView.addSubview(btnView)
            i = i + 1
        }
        importBtnView.center = CGPoint(x:self.buttonView.frame.width/2, y:self.buttonView.frame.height/2)
        self.buttonView.addSubview(importBtnView)
        
    }
    
    func btnTapped(sender:AnyObject)
    {
        switch index {
        case 0:
            if sender.tag == 1 {
                let url = NSURL(string: "https://www.facebook.com/earthistsinc/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/earthists_inc/")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        case 1:
            if sender.tag == 1 {
                let url = NSURL(string: "https://www.facebook.com/luckylegends/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/luckydoot1/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 3 {
                let url = NSURL(string: "https://soundcloud.com/legendarymusic")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 4 {
                let url = NSURL(string: "https://twitter.com/LuckyovLegends")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 5 {
                let url = NSURL(string: "https://www.youtube.com/channel/UC43tEsKAB324l7Qla8QpQFA")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        case 2:
            if sender.tag == 1 {
                let url = NSURL(string: "https://www.facebook.com/thereallanashea")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/lalanashea/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 3 {
                let url = NSURL(string: "https://soundcloud.com/lanashea")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 4 {
                let url = NSURL(string: "https://twitter.com/lalanashea")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 5 {
                let url = NSURL(string: "https://www.youtube.com/user/LanaSheaKicksIt")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        case 3:
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/hijack/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 4 {
                let url = NSURL(string: "https://twitter.com/HIJACK")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        case 4:
            if sender.tag == 1 {
                let url = NSURL(string: "https://www.facebook.com/ewa.m.grochowska")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/freedom4ewa/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 4 {
                let url = NSURL(string: "https://twitter.com/Freedom4Ewa")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        case 5:
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/johndardenne/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 4 {
                let url = NSURL(string: "https://twitter.com/johndardenne")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 5 {
                let url = NSURL(string: "https://www.youtube.com/user/Dardenne")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        case 6:
            if sender.tag == 1 {
                let url = NSURL(string: "https://www.facebook.com/dandoramusic")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 2 {
                let url = NSURL(string: "https://www.instagram.com/dandoramusic/")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 4 {
                let url = NSURL(string: "https://twitter.com/dandoramusic")
                UIApplication.sharedApplication().openURL(url!)
            }
            if sender.tag == 5 {
                let url = NSURL(string: "https://www.youtube.com/user/dandoramusic")
                UIApplication.sharedApplication().openURL(url!)
            }
            break
        default:
            break
        }
    }
    
    func displayCause()  {
        let width = buttonView.bounds.width
        let heightofbuttonView = buttonView.bounds.height
        let heightofmemberInfoLabel = MemberInfoLabel.bounds.height

        for i in 0...CauseName[index].count - 1{
            let button : UIButton = UIButton()
            button.tag = index * 10 + i
            button.setTitle(CauseName[index][i], forState: .Normal)
            button.frame = CGRectMake(8, 30 + heightofbuttonView * 2 + heightofmemberInfoLabel + CGFloat(i * 45), width, 40)
            button.titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 15)
            button.backgroundColor = UIColor(red: 67/255, green: 255/255, blue: 125/255, alpha: 1.0)
            button.layer.cornerRadius = 7
            button.addTarget(self, action: #selector(self.pressed(_:)), forControlEvents: .TouchUpInside)
            self.scrollView.addSubview(button)
        }
        
    }
    func pressed(sender : UIButton){
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("causeView") as! CauseViewController
        popoverContent.index = Int(sender.tag / 10)
        popoverContent.selectedbutton = sender.tag % 10
        self.presentViewController(popoverContent, animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        let heightofbuttonView = buttonView.bounds.height
        let heightofmemberInfoLabel = MemberInfoLabel.bounds.height
        scrollView.contentSize = CGSizeMake(self.myView.frame.size.width, 40 + heightofbuttonView * 2 + heightofmemberInfoLabel + CGFloat(CauseName[index].count * 45))
    }
    @IBAction func onTapBackBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onTapInvestBtn(sender: AnyObject) {
        let token = MemberModel.sharedInstance.user_Token
        if token == "" {
            performSegueWithIdentifier("ToInvestPage", sender: self)
        }else
        {
            let params = [
                "token" : token
            ]
            MyAlamofire.POST(CHECKTOKEN_API, parameters: params,showLoading: true,showSuccess: false,showError: true,search:false) { (result, responseObject)
                in
                if(result){
                    let result = responseObject.objectForKey("result") as! Int
                    if result == 1 {
                        self.performSegueWithIdentifier("FromMemberToLink", sender: self)
                    }else
                    {
                        let alertController = UIAlertController(title: "Caution", message: "Connection Error.", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                        }
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
