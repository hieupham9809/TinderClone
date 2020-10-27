//
//  SimpleSegmentationView.swift
//  ZingNews
//
//  Created by HieuPM on 10/22/20.
//  Copyright © 2020 VNG ONLINE. All rights reserved.
//

import UIKit

protocol SimpleSegmentationDelegate : class {
   func selectedItem(item: SimpleSegmentationView.SimpleSegmentItem)
}

class SimpleSegmentationView: UIView {
   struct SimpleSegmentItem {
      var title: String
      var font: UIFont?
      var selectedColor: UIColor?
      var unselectedColor: UIColor?
      var index: Int?
      var textAlignment:
         UIControl.ContentHorizontalAlignment = .center
   }
   
   var itemsDict: [UIButton : SimpleSegmentItem] = [:]
   var currentSelectedButton: UIButton? = nil
   static var defaultSelectedIndex: Int = 0
   weak var delegate: SimpleSegmentationDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   convenience init(frame: CGRect, items: [SimpleSegmentItem]) {
      self.init(frame: frame)
      
      createViews(withItems: items)
   }
   
   func createViews(withItems items: [SimpleSegmentItem]) {
      let itemWidth = self.frame.size.width / CGFloat(items.count)
      let itemHeight = self.frame.size.height
      for index in 0..<items.count {
         let item = items[index]
         let button = UIButton()
         button.setTitle(item.title, for: .normal)
         button.contentHorizontalAlignment = item.textAlignment
         button.setTitleColor(item.unselectedColor, for: .normal)
         if index == Self.defaultSelectedIndex {
            button.setTitleColor(item.selectedColor, for: .normal)
         }
         button.addTarget(self,
                          action: #selector(buttonSelectedHandle(sender:)),
                          for: .touchUpInside)
         button.frame = CGRect(x: CGFloat(index) * itemWidth,
                               y: 0,
                               width: itemWidth, height: itemHeight)
         self.addSubview(button)
         itemsDict[button] = item
      }
   }
   
   @objc func buttonSelectedHandle(sender: UIButton) {
      if let currentBtn = currentSelectedButton {
         currentBtn.setTitleColor(itemsDict[currentBtn]?.unselectedColor,
                                  for: .normal)
      }
      if let item = itemsDict[sender] {
         sender.setTitleColor(item.selectedColor,
                              for: .normal)
         currentSelectedButton = sender
         delegate?.selectedItem(item: item)
      }
   }
   
   
}
