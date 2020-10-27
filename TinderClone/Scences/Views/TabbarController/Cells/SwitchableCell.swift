//
//  SwitchableCell.swift
//  TinderClone
//
//  Created by HieuPM on 9/7/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

protocol SwitchModeDelegate: class {
   func selectedSwipeMode()
   func selectedMyLikesMode()
}

class SwitchableCell: IconCell {
   
   var switchMode: TinderUISwitch?
   var isOnSwipeMode: Bool = true
   
   weak var switchModeDelegate: SwitchModeDelegate?
   
   override func setupViews() {
      super.setupViews()
      setupSwitch()
   }
   
   override func createViews() {
      super.createViews()
      createSwitch()
   }
   
   func createSwitch() {
      switchMode = TinderUISwitch()
      switchMode?.borderWidth = 0
      switchMode?.offTintColor = UIColor.myGrayBackground()
      switchMode?.onTintColor = UIColor.myGrayBackground()
      switchMode?.isHidden = true
      switchMode?.offImage = UIImage.getTabbarLikedModeIcon()?
      .withRenderingMode(.alwaysTemplate).cgImage
      switchMode?.onImage = UIImage.getTabbarDatingIcon()?
      .withRenderingMode(.alwaysTemplate).cgImage
      switchMode?.addTarget(self, action: #selector(handleSwitchChangeState(sender:)), for: .valueChanged)
      self.contentView.addSubview(switchMode!)
   }
   
   func setupSwitch() {
      switchMode?.center = iconImageView?.center ?? .zero
   }
   
   override func setActiveState() {
      super.setActiveState()
      iconImageView?.isHidden = true
      switchMode?.isHidden = false
      
      if isOnSwipeMode {
         setOnSwipeMode()
      } else {
         setOnLikedMode()
      }
   }
   
   override func setInactiveState() {
      super.setInactiveState()
      iconImageView?.isHidden = false
      switchMode?.isHidden = true
   }
   
   func setOnSwipeMode() {
      
      switchMode?.thumbImage = UIImage.getTabbarDatingIcon()?.cgImage
   }
   
   func setOnLikedMode() {
      
      switchMode?.thumbImage = UIImage.getTabbarLikedModeIcon()?
         .tinted(with: UIColor.myMainYellowColor())?.cgImage
   }
   
   @objc func handleSwitchChangeState(sender: TinderUISwitch) {
      
      isOnSwipeMode = !sender.isOn
      if sender.isOn {
         setOnLikedMode()
         switchModeDelegate?.selectedMyLikesMode()
      } else {
         setOnSwipeMode()
         switchModeDelegate?.selectedSwipeMode()
      }
   }
}
