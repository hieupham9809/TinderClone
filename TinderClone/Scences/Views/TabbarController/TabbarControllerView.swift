//
//  TabbarControllerView.swift
//  TinderClone
//
//  Created by HieuPM on 9/7/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

protocol TabbarSelectedDelegate: class {
   func selectedCell(at index: Int)
}

class TabbarControllerView : UIView {
   
   var collectionView : UICollectionView!
   let numberOfTab = 3
   let switchableCellTypeIdentifier = "switchableCellIdentifier"
   let IconCellTypeIdentifier = "iconCellIdentifier"
   let userIndex = 0
   let mainIndex = 1
   let messageIndex = 2
   
   weak var delegate: TabbarSelectedDelegate?
   
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
      createCollectionView()
   }
   
   func setupViews() {
      setupCollectionView()
   }
   
   func createCollectionView() {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
      self.addSubview(collectionView)
   }
   
   func setupCollectionView() {
      self.collectionView.backgroundColor = UIColor.clear
      self.collectionView.delegate = self
      self.collectionView.dataSource = self
      registerCellForCollectionView()
      
   }
   
   func registerCellForCollectionView() {
      self.collectionView.register(SwitchableCell.self, forCellWithReuseIdentifier: switchableCellTypeIdentifier)
      self.collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCellTypeIdentifier)
      
   }
   
   func getCell(at index: Int) -> UICollectionViewCell? {
      guard let validCollectionView = collectionView,
         index >= 0, index < numberOfTab else {return nil}
      let indexPath = IndexPath(row: index, section: 0)
      return validCollectionView.cellForItem(at: indexPath)
   }
   
   
   
}

extension TabbarControllerView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return numberOfTab
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let row = indexPath.row
      
      switch row {
      case userIndex:
         let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IconCellTypeIdentifier,
            for: indexPath) as! IconCell
         cell.setImageForIcon(image: UIImage.getTabbarUserIcon())
         return cell
      case mainIndex:
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: switchableCellTypeIdentifier, for: indexPath) as! SwitchableCell
         cell.setImageForIcon(image: UIImage.getTabbarDatingIcon())
         return cell
      case messageIndex:
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCellTypeIdentifier, for: indexPath) as! IconCell
         cell.setImageForIcon(image: UIImage.getTabbarMessageIcon())
         return cell
      default:
         break
      }
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCellTypeIdentifier, for: indexPath)
      
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width : CGFloat = self.bounds.width / CGFloat(numberOfTab)
      let height : CGFloat = self.bounds.height
      
      return CGSize(width: width, height: height)
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      delegate?.selectedCell(at: indexPath.row)
   }
   
}
