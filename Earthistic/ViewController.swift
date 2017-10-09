//
//  ViewController.swift
//  Earthistic
//
//  Created by Sobura on 1/24/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit
extension UIViewController
{
    func showOkAlert(customTitle:String, customMessage:String)
    {
        let alertController = UIAlertController(title: customTitle, message: customMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var memberPicture = ["star_wandergypc","lana_photo","jack_photo","ewa_photo","john_photo","star_dandora_music"]
    var memberProfilePicture = ["star_wandergypc_1","lana_photo_1","jack_photo_1","ewa_photo_1","john_photo_1","star_dandora_music_1"]
    var memberName = ["The Wanderin GypC","Lana Shea","Jack Brockway","Ewa","Jhon Dardenne","Dandora Music"]
    var sequence = 0
    var curPage : Int {
        get {
            return Int(self.collectionView.contentOffset.x / self.collectionView.frame.width)
        }
    }
    
    var originalOffset:CGPoint!
    var rightScroll:Bool!
    var leftScroll:Bool!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberPicture.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemberPictureCell
        self.sequence = indexPath.row
        print(memberPicture[sequence])
        cell.MemberPicture.image = UIImage(named: memberPicture[sequence])
        cell.NameLabel.text = self.memberName[sequence]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMemberPage" {
            MemberModel.sharedInstance.name = memberName[curPage]
            MemberModel.sharedInstance.profileImage = memberProfilePicture[curPage]
            MemberModel.sharedInstance.Image = memberPicture[curPage]
            MemberModel.sharedInstance.sequence = self.curPage
        }
    }

    @IBAction func onTapHeartBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToMemberPage", sender: self)
    }

}

