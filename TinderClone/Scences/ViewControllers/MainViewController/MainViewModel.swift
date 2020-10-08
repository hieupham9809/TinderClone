//
//  MainViewModel.swift
//  TinderClone
//
//  Created by HieuPM on 9/6/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel {
   private var listViewController : [UIViewController] = []
   
   var vcCount : Int {
      listViewController.count
   }
   
   func getViewController(by index : Int) -> UIViewController? {
      guard index >= 0, index < listViewController.count else {return nil}
      return listViewController[index]
   }
   
   func initSubViewControllers() {
      let vc2 = UIViewController()
      vc2.view.backgroundColor = UIColor.green
      listViewController.append(vc2)
      
      let swipeableVC = SwipeableViewController()
      let swipeableVM = SwipeableViewModel()
      swipeableVC.bind(to: swipeableVM)
      swipeableVC.view.backgroundColor = UIColor.red
      listViewController.append(swipeableVC)
      
      let vc3 = UIViewController()
      vc3.view.backgroundColor = UIColor.blue
      listViewController.append(vc3)
   }
}
