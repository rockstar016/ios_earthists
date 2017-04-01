//
//  CauseViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/26/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

class CauseViewController: UIViewController {
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var causeContentView: UIView!
    @IBOutlet weak var causeNameLabel: UILabel!
    @IBOutlet weak var causeLabel: UIBorderedLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var causeNameView: UIView!
    @IBOutlet weak var causeTextLabel: UILabel!
    @IBOutlet weak var causeProfilePicture: UIImageView!
    var index :Int = 0
    var selectedbutton : Int = 0
    var heartImage : [[String]] = [["chooselovecause","waterislifecause"],["raceequitycause"],["genderequitycause"],["sustainablecause"],["healthylivingcause"],["incomeequalitycause"],["wildlifecause"]]
    var causeName : [[String]] = [["CHOOSE LOVE CAUSE BIO","WATER IS LIFE CAUSE BIO"],["RACE EQUITY CAUSE BIO"],["GENDER EQUITY CAUSE BIO"],["SUSTAINABLE LIVING CAUSE BIO"],["HEALTHY LIVING CAUSE BIO"],["INCOME EQUITY CAUSE BIO"],["WILDLIFE EQUITY CAUSE BIO"]]
    var causeKind : [[String]] = [["Choose Love","Water is Life"],["Race Equity"],["Gender Equity"],["Sustainable Liviing"],["Healthy Living"],["Income Equity"],["Wildlife Equity"]]
    var causeContentText : [[String]] = [["All our causes revolve around this cause  for we believe that if love is the motive for all your choices then everything else" +
        " will fall into place. Our solutions to humanity’s many problems all follow a “center-out” approach, meaning they are tailored to meet the specific needs of those they are trying to help. When we focus on our children first, we naturally" +
        " look to love to guide us. Also known as the Children First cause, this cause benefits Father Bosco’s work with orphans in Africa.",
        // water
        "Our Choose Love cause is our flexible cause. She is ever-changin’. She takes on different causes that need immediate attention. " +
            "For the launch of this app, ALL of the Artists for Earth are sharing their investments with the Standing Rock Sioux and showing " +
            "their support for their cause. We stand with the Sioux and other Native Americans who have sacrificed so much to make this country " +
            "what it is today. We share in all of our many blessings and want to see you thrive as well. We commit to collaborating with Indigenous " +
            "people for a progressive today and a peaceful tomorrow.  We rise up in love to help protect that, which gives us life, our gracious Mother " +
        "Earth and water, the life source of our great Mother.  Together, we can finally do what is right. "],
        ["Our Race Equity cause focuses on the notion of being fair, the idea of justice rather than everyone being seen as equals.  " +
                                            "Different cultures have different ways to contribute to humanity and society and our differences are a cause for celebration. " +
                                            "We believe proper race equity starts with acknowledgement and understanding of history and current events so we can properly " +
                                            "steer the courses of our future towards collaboration, equality and peace. Many racial inequalities today are still the extended " +
                                            "products of colonialism. When we acknowledge and fully understand this we can start to correct it. For this reason, this cause " +
                                            "supports the amazing and heroic efforts of Falling Whistles and their push for peace."],
        ["Our gender equality cause promotes a balanced approach to life by creating equity between the sexes. We believe " +
            "that we will never reach humanity’s full potential until we fully appreciate women and incorporate them into every aspect of society. " +
            "This stARTs with each of us. This cause vigorously supports the brilliant Jackson Katz and his work with " +
            "MVP Strategies against gender violence. True hero."],
        ["Our sustainable living cause promotes the idea that living sustainably will help us" +
            " to battle the negative effects of climate change. Climate change is a global" +
            " phenomenon that affects us all. We must all actively work together to divest from dirty, polluting energy sources like oil and coal." +
            " This cause supports the tireless work of the Leonardo Di Caprio Foundation and their" +
            " efforts to bring awareness to this global crisis and what we all need to do to survive and thrive."],
        ["Healthy living, to us, means anything you do to maintain your overall health. This comprises " +
            "of keeping a balance between proper mental, physical and spiritual health.  There are many " +
            "paths to achieving this goal. We simply promote living everyday lives that keep you happy, healthy " +
            "and fulfilled instead of buying into expensive treatments, trending fads or traveling experiences.  " +
            "We focus on what you can do right here, right now, with or without friends. We see art as a form of rehabilitation, " +
            "both for the artist and the art lover. Creating and experiencing art is transformative. Since art is a form of expression, " +
            "it has therapeutic qualities that are intense.  For this reason, this cause supports Ewa’s art therapy work with kids who have " +
            "suffered from domestic violence, a truly noble cause."],
        ["Our Income Equity cause is also known as the Ending Poverty cause. Poverty, like the current climate change Earth is" +
            " experiencing, is man-made. Ending poverty once and for all is a duty we all share." +
            " Income equity also speaks to the drastic disparity between the top 1% and" +
            " the rest of us. For this reason, the cause supports the efforts of Robert" +
            " Reich and his fight to inform the masses about this injustice that negatively" +
            " impacts us all, even the super rich."],
        ["We see all life on our Mother Earth to be equal. Animals deserve the same respect and rights as our fellow brothers and sisters do. " +
            "We believe in compassionate living meaning all beings deserve to live happy, healthy and fulfilled lives." +
            "Killing off vital species like elephants for short-term gains have devastating long-term effects for our planet and us. " +
            "Since we are all connected, ecological collapse affects every one of us and can have a spiraling, exponential effect. We must strengthen " +
            "our efforts to protect the biodiversity we have left to try to prevent this from happening. For this reason, this cause supports the Dandora " +
            "Music School and their inspiring efforts to educate the youth on wildlife conservation."]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.causeNameView.setExtesionStyle()
        self.heartView.setExtesionStyle()
        causeProfilePicture.image = UIImage(named: heartImage[index][selectedbutton])
        causeNameLabel.text = causeKind[index][selectedbutton]
        causeLabel.text = causeName[index][selectedbutton]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attrString = NSMutableAttributedString(string: causeContentText[index][selectedbutton])
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        causeTextLabel.attributedText = attrString
        causeTextLabel.sizeToFit()
    }
    
    override func viewDidLayoutSubviews() {
        let height = causeTextLabel.bounds.height
        scrollView.contentSize = CGSizeMake(self.causeContentView.frame.size.width, height + 10)
    }
    @IBAction func onTapBackBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
    