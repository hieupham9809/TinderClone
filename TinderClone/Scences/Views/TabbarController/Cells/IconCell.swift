//
//  IconCell.swift
//  TinderClone
//
//  Created by HieuPM on 9/7/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
   
   var iconImageView : UIImageView!
   
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
   
   override var frame: CGRect {
      didSet {
         setupViews()
      }
   }
   
   func createViews() {
      
      iconImageView = UIImageView()
      iconImageView.contentMode = .scaleAspectFit
      iconImageView.tintColor = UIColor.myMainGrayColor()
      self.contentView.addSubview(self.iconImageView)
   }
   
   func setImageForIcon(image: UIImage?) {
      iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
   }
   
   func setupViews() {
      
      let parentHeight = self.contentView.bounds.size.height
      let parentWidth = self.contentView.bounds.size.width
      
      let iconHeight: CGFloat = 30
      let iconWidth: CGFloat = 30
      
      iconImageView?.frame =
         CGRect(origin: CGPoint(x: (parentWidth - iconWidth) / 2,
                                y: (parentHeight - iconHeight) / 2),
                size: CGSize(width: iconWidth, height: iconHeight))
      
   }
   
   func setActiveState() {
      iconImageView?.tintColor = UIColor.myMainTinderColor()
   }
   
   func setInactiveState() {
      iconImageView?.tintColor = UIColor.myMainGrayColor()
   }
}
