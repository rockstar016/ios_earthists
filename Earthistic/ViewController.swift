//
//  ViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/24/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var memberPicture : [String] = ["star_wandergypc","star_luckiam","lana_photo","jack_photo","ewa_photo","john_photo","star_dandora_music"]
    var memberProfilePicture : [String] = ["star_wandergypc_1","star_luckiam_1","lana_photo_1","jack_photo_1","ewa_photo_1","john_photo_1","star_dandora_music_1"]
    var memberName : [String] = ["The Wanderin GypC","Luckyiam","Lana Shea","Jack Brockway","Ewa","Jhon Dardenne","Dandora Music"]
    var sequence : Int = 0
    var curPage:Int!
    var originalOffset:CGPoint!
    var rightScroll:Bool!
    var leftScroll:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberPicture.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)as! MemberPictureCell
        cell.MemberPicture.image = UIImage(named: memberPicture[indexPath.row])
        cell.NameLabel.text = self.memberName[indexPath.row]
        self.sequence = indexPath.row
        return cell
    }
    
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        curPage = Int((self.collectionView.contentOffset.x / self.collectionView.contentSize.width) * CGFloat(self.memberPicture.count + 1))
        originalOffset = self.collectionView.contentOffset
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.rightScroll = false
        self.leftScroll = false
        
        if(self.collectionView.contentOffset.x > self.originalOffset.x)
        {
            self.rightScroll = true
        }
        else if(self.collectionView.contentOffset.x < self.originalOffset.x)
        {
            self.leftScroll = true
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(self.originalOffset.x < self.collectionView.contentOffset.x)
        {
            if(curPage < self.memberPicture.count)
            {
                self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: curPage + 1, inSection: 0), atScrollPosition:UICollectionViewScrollPosition.Left, animated: false)
            }
        }
        else if(self.originalOffset.x > self.collectionView.contentOffset.x)
        {
            if(curPage > 0)
            {
                self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: curPage - 1, inSection: 0), atScrollPosition:UICollectionViewScrollPosition.Right, animated: false)
            }
        }
        else
        {
            if(curPage == self.memberPicture.count)
            {
                if(!leftScroll)
                {
                    self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition:    UICollectionViewScrollPosition.Left, animated: false)
                }
            }
            else if(curPage == 0)
            {
                /*if(!rightScroll)
                 {
                 self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: self.RestaurantInfos[self.restaurantIndext].RestaurantImg.count, inSection: 0), atScrollPosition:    UICollectionViewScrollPosition.Left, animated: false)
                 }*/
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ToMemberPage")
        {
            MemberModel.sharedInstance.name = memberName[sequence ]
            MemberModel.sharedInstance.profileImage = memberProfilePicture[sequence]
            MemberModel.sharedInstance.Image = memberPicture[sequence]
            MemberModel.sharedInstance.sequence = self.sequence
        }
    }

    @IBAction func onTapHeartBtn(sender: AnyObject) {
        performSegueWithIdentifier("ToMemberPage", sender: self)
    }

}

