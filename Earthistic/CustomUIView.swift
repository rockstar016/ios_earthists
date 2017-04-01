//
//  CustomUIView.swift
//  Earthistic
//
//  Created by Sobura on 1/26/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit

import UIKit
extension UIView {
    func setExtesionStyle()
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor(red:165/255.0, green:165/255.0, blue:167/255.0, alpha: 1.0).CGColor
        self.layer.shadowOpacity = 0.7
    }
}

