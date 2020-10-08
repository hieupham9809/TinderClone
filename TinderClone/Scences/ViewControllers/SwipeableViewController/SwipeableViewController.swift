//
//  SwipeableViewController.swift
//  TinderClone
//
//  Created by HieuPM on 9/21/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

class SwipeableViewController: UIViewController, BindableType {

    var viewModel: SwipeableViewModel!
    
    var frontView: UIView!
    var backView: UIView!
    
    func bindViewModel() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getInitialProfiles()
        
    }
    func getInitialProfiles() {
        guard let validViewModel = viewModel else {return}
        validViewModel.fetchAvailablePartners()
    }
    
    func setupFrontAndBackView() {
        frontView = UIView(frame: self.view.bounds)
        frontView.backgroundColor = .clear
        
        backView = UIView(frame: self.view.bounds)
        backView.backgroundColor = .clear
        
        self.view.addSubview(backView)
        self.view.addSubview(frontView)
        self.view.bringSubviewToFront(frontView)
        
        initProfile()
    }
    
    func initProfile() {
        bringSwipeViewToBack()
        bringSwipeViewToFront()
        bringSwipeViewToBack()
    }

    func bringSwipeViewToBack() {
        backView?.subviews.forEach({view in view.removeFromSuperview()})
        
        guard let validViewModel = self.viewModel,
            let swipeProfile = validViewModel.getNextPartner()
            else {return}
        
        let swipeView = SwipeInfoView(frame: backView?.bounds ?? .zero)
        
        swipeView.setContent(content: swipeProfile)
        backView?.addSubview(swipeView)
        
        
    }
    
    func bringSwipeViewToFront() {
        frontView?.subviews.forEach({view in view.removeFromSuperview()})
        
        guard let validBackView = self.backView,
            let validFrontView = self.frontView else {return}
        if let swipeView = validBackView.subviews.first as? SwipeInfoView {
            swipeView.removeFromSuperview()
            validFrontView.addSubview(swipeView)
        }
    }

}
