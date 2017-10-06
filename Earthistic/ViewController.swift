//
//  ViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/24/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var memberPicture : [String] = ["star_wandergypc","lana_photo","jack_photo","ewa_photo","john_photo","star_dandora_music"]
    var memberProfilePicture : [String] = ["star_wandergypc_1","lana_photo_1","jack_photo_1","ewa_photo_1","john_photo_1","star_dandora_music_1"]
    var memberName : [String] = ["The Wanderin GypC","Lana Shea","Jack Brockway","Ewa","Jhon Dardenne","Dandora Music"]
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberPicture.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! MemberPictureCell
        self.sequence = indexPath.row
        print(memberPicture[sequence])
        cell.MemberPicture.image = UIImage(named: memberPicture[sequence])
        cell.NameLabel.text = self.memberName[sequence]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell_width = self.view.frame.width
        let cell_height = self.view.frame.height;
        return CGSize(width: cell_width, height: cell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        curPage = Int((self.collectionView.contentOffset.x / self.collectionView.contentSize.width) * CGFloat(self.memberPicture.count))
        originalOffset = self.collectionView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
//        print("Curpage: " + String(curPage))
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(self.originalOffset.x < self.collectionView.contentOffset.x)
        {
            if(curPage < self.memberPicture.count)
            {
                self.collectionView?.scrollToItem(at: IndexPath(item: curPage + 1, section: 0), at:UICollectionViewScrollPosition.left, animated: false)
            }
        }
        else if(self.originalOffset.x > self.collectionView.contentOffset.x)
        {
            if(curPage > 0)
            {
                self.collectionView?.scrollToItem(at: IndexPath(item: curPage - 1, section: 0), at:UICollectionViewScrollPosition.right, animated: false)
            }
        }
        else
        {
            if(curPage == self.memberPicture.count)
            {
                if(!leftScroll)
                {
                    self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at:    UICollectionViewScrollPosition.left, animated: false)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToMemberPage")
        {
            MemberModel.sharedInstance.name = memberName[sequence]
            MemberModel.sharedInstance.profileImage = memberProfilePicture[sequence]
            MemberModel.sharedInstance.Image = memberPicture[sequence]
            MemberModel.sharedInstance.sequence = self.sequence
        }
    }

    @IBAction func onTapHeartBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToMemberPage", sender: self)
    }

}

