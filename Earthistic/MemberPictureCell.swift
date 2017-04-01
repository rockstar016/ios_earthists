//
//  MemberPictureCell.swift
//  Earthistic
//
//  Created by Sobura on 1/24/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

class MemberPictureCell: UICollectionViewCell {

    @IBOutlet weak var MemberPicture: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.NameLabel.text = nil
    }
}
