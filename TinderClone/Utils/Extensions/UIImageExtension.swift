//
//  UIImageExtension.swift
//  TinderClone
//
//  Created by HieuPM on 10/11/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

extension UIImage {
   static func getTabbarMessageIcon() -> UIImage? {
      UIImage(named: "tabbarMessagesIcon")
   }
   
   static func getTabbarUserIcon() -> UIImage? {
      UIImage(named: "tabbarUserIcon")
   }
   
   static func getTabbarLikedModeIcon() -> UIImage? {
      UIImage(named: "tabbarShineIcon")
   }
   
   static func getTabbarDatingIcon() -> UIImage? {
      UIImage(named: "tabbarSwitchDating")
   }
   
   func tinted(with color: UIColor) -> UIImage? {
       defer { UIGraphicsEndImageContext() }
       UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
       color.set()
       self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: self.size))
       return UIGraphicsGetImageFromCurrentImageContext()
   }
}
