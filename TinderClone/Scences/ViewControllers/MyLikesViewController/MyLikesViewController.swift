//
//  MyLikesViewController.swift
//  TinderClone
//
//  Created by HieuPM on 10/13/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

class MyLikesViewController: UIViewController, BindableType {
   
   var viewModel: MyLikesViewModel!
   var segmentationView: TinderSegmentationView?
   
   let firstHeaderIndex = 0
   let secondHeaderIndex = 1
   
   func bindViewModel() {
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      createViews()
      setupViews()
   }
   
   func setupViews() {
      setupSegmentationView()
   }
   
   func createViews() {
      createSegmentationView()
   }
   
   func createSegmentationView() {
      let firstHeaderItem = SimpleSegmentationView.SimpleSegmentItem(
         title: "10 Like",
         font: UIFont.myTinderSegmentationHeaderFont,
         selectedColor: .black,
         unselectedColor: .myMainGrayColor(),
         index: firstHeaderIndex)
      
      let secondHeaderItem = SimpleSegmentationView.SimpleSegmentItem(
         title: "10 Top Picks",
         font: UIFont.myTinderSegmentationHeaderFont,
         selectedColor: .black,
         unselectedColor: .myMainGrayColor(),
         index: secondHeaderIndex)
      
      let segmentationWidth = self.view.bounds.width
      let segmentationHeight = 0.130 * segmentationWidth
      
      segmentationView = TinderSegmentationView(
         frame: CGRect(x: 0, y: 0,
                       width: segmentationWidth,
                       height: segmentationHeight),
         items: [firstHeaderItem, secondHeaderItem])
      
      self.view.addSubview(segmentationView!)
   }
   
   func setupSegmentationView() {
      
   }
}
