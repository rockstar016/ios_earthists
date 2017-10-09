//
//  ScrollViewExtentions.swift
//  Earthistic
//
//  Created by Alexander Hudym on 07.10.17.
//  Copyright © 2017 Sobura. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews[0].subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        //        self.frame = contentRect
        //        self.subviews[0].layoutIfNeeded()
        //        print(self.subviews[0].frame)
    }
    
}
