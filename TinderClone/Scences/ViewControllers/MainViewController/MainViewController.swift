//
//  MainViewController.swift
//  TinderClone
//
//  Created by HieuPM on 9/5/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BindableType {
   
   var viewModel : MainViewModel!
   var scrollView : UIScrollView!
   var mainTabbar : TabbarControllerView!
   
   var currentIdx : Int = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      
      
      
      
   }
   
   override func viewDidAppear(_ animated: Bool) {
      setSelectedTab(at: 1)
   }
   
   func setupUI() {
      self.view.backgroundColor = UIColor.white
      configMainTabbarView()
      configScrollView()
      
   }
   
   func bindViewModel() {
      guard let viewModel = self.viewModel else {return}
      viewModel.initSubViewControllers()
      setupUI()
   }
   
   func configMainTabbarView() {
      let screenWidth = Define.screenWidth
      self.mainTabbar = TabbarControllerView(frame: CGRect(x: 0, y: Define.safeAreaTop, width: screenWidth, height: screenWidth / 7.0))
      self.mainTabbar.backgroundColor = UIColor.white
      self.mainTabbar.delegate = self
      self.view.addSubview(self.mainTabbar)
   }
   
   func configScrollView() {
      guard let viewModel = self.viewModel else {return}
      let tabbarMaxYValue = mainTabbar?.frame.maxY ?? 0
      let scrollViewWidth = self.mainTabbar.bounds.size.width
      let scrollViewHeight = self.view.bounds.size.height
         - tabbarMaxYValue
      
      self.scrollView = UIScrollView(frame: CGRect(x: 0, y: self.mainTabbar.frame.maxY, width: scrollViewWidth, height: scrollViewHeight))
      self.scrollView.contentSize = CGSize(width: CGFloat(viewModel.vcCount) * scrollViewWidth, height: scrollViewHeight)
      
      self.scrollView.isPagingEnabled = true
      self.scrollView.isScrollEnabled = true
      self.scrollView.backgroundColor = UIColor.yellow
      self.scrollView.bounces = false
      self.scrollView.delegate = self
      self.scrollView.showsHorizontalScrollIndicator = false
      self.createSubviewsForScrollView()
      
      self.view.addSubview(self.scrollView)
   }
   
   func createSubviewsForScrollView() {
      let scrollViewWidth = self.scrollView.bounds.size.width
      let scrollViewHeight = self.scrollView.bounds.size.height
      
      guard let viewModel = self.viewModel else {return}
      
      for idx in 0..<viewModel.vcCount {
         if let vc = viewModel.getViewController(by: idx) {
            vc.view.frame = CGRect(
               x: CGFloat(idx) * scrollViewWidth,
               y: 0,
               width: scrollViewWidth,
               height: scrollViewHeight)
            if let swipeableVC = vc as? SwipeableViewController {
               swipeableVC.setupViews()
               mainTabbar?.switchModeDelegate = swipeableVC
            }
            self.addChild(vc)
            self.scrollView.addSubview(vc.view)
            vc.willMove(toParent: self)
            
         }
      }
   }
   
   func changeTabbarAppearance() {
      print("TABBAR: time to change tabbar's UI")
   }
   
   func setSelectedTab(at index: Int) {
      guard index != currentIdx,
         let validCell = mainTabbar?.getCell(at: index) else {return}
      setUnselectedTab(at: currentIdx)
      if let iconCell = validCell as? IconCell {
         iconCell.setActiveState()
      } else if let _ = validCell as? SwitchableCell {
         
      }
      scrollTo(index: index)
      currentIdx = index
   }
   
   func setUnselectedTab(at index: Int) {
      guard let validCell = mainTabbar?.getCell(at: index) else {return}
      if let iconCell = validCell as? IconCell {
         iconCell.setInactiveState()
      } else if let _ = validCell as? SwitchableCell {
         
      }
   }
}

extension MainViewController : UIScrollViewDelegate,
TabbarSelectedDelegate {
   
   func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let nearestIndex = Int(CGFloat(targetContentOffset.pointee.x) / scrollView.bounds.width + 0.5)
      
      self.setSelectedTab(at: nearestIndex)
      
   }
   
   func scrollTo(index: Int) {
      guard index >= 0, index < (viewModel?.vcCount ?? 0) else {return}
      let scrollViewWidth = scrollView?.bounds.size.width ?? 0
      scrollView?
         .setContentOffset(CGPoint(x: CGFloat(index) * scrollViewWidth,
                                   y: 0),
                           animated: true)
   }
   
   func selectedCell(at index: Int) {
      setSelectedTab(at: index)
   }
   
}
