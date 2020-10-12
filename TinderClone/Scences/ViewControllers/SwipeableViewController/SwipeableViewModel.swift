//
//  SwipeableViewModel.swift
//  TinderClone
//
//  Created by HieuPM on 9/21/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import Foundation

class SwipeableViewModel {
   var partnerQueue = DataStructures.Queue<SwipeableProfile>()
   
   func fetchAvailablePartners() {
      let profile1 = SwipeableProfile()
      profile1.imageUrl = "https://i.pinimg.com/originals/43/93/93/4393933003940a763b0197aeb1dc742b.jpg"
      let profile2 = SwipeableProfile()
      profile2.imageUrl = "https://images.pexels.com/photos/1382731/pexels-photo-1382731.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
      let profile3 = SwipeableProfile()
      profile3.imageUrl = "https://i.pinimg.com/564x/ce/2c/c2/ce2cc2e0be09909a92834bd88aaa55be.jpg"
      
      partnerQueue.enQueue(profile1)
      partnerQueue.enQueue(profile2)
      partnerQueue.enQueue(profile3)
   }
   
   func getNextPartner()->SwipeableProfile? {
      if partnerQueue.count() < 2 {
         fetchAvailablePartners()
      }
      return partnerQueue.deQueue()?.key
   }
}
