//
//  SwipeableViewControllerMyLikesExtension.swift
//  TinderClone
//
//  Created by HieuPM on 10/13/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

extension SwipeableViewController: SwitchModeDelegate {
   func selectedSwipeMode() {
      myLikesView?.isHidden = true
   }
   
   func selectedMyLikesMode() {
      myLikesView?.isHidden = false
      if let validView = myLikesView {
         self.view.bringSubviewToFront(validView)
      }
   }
}
