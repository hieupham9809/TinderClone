//
//  SwipeInfoView.swift
//  TinderClone
//
//  Created by HieuPM on 9/22/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit
import Kingfisher

class SwipeInfoView : UIView {
   var thumbImage: UIImageView!

   
   override init(frame: CGRect) {
      super.init(frame: frame)
      createViews()
      setupViews()
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      createViews()
      setupViews()
   }
   
   func createViews() {
//      self.clipsToBounds = true
      self.layer.cornerRadius = 10.0
      thumbImage = UIImageView()
      thumbImage?.layer.cornerRadius = 10.0
      thumbImage?.contentMode = .scaleAspectFill
      thumbImage?.clipsToBounds = true
      self.addSubview(thumbImage!)
      
     
   }
   
   func setupViews() {
      thumbImage?.frame = self.bounds
   }
   
   func setContent(content: SwipeableProfile) {
      thumbImage.kf.setImage(with: URL(string: content.imageUrl))
   }
   
   
}
