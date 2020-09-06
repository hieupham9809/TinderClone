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
    var mainTabbar : UIView!
    
    var currentIdx : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        configMainTabbarView()
        
        
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.white
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else {return}
        viewModel.initSubViewControllers()
        configScrollView()
    }
    
    func configMainTabbarView() {
        let screenWidth = Define.screenWidth
        self.mainTabbar = UIView(frame: CGRect(x: 0, y: Define.safeAreaTop, width: screenWidth, height: screenWidth / 7.0))
        self.mainTabbar.backgroundColor = UIColor.gray
        self.view.addSubview(self.mainTabbar)
    }
    
    func configScrollView() {
        guard let viewModel = self.viewModel else {return}
        let scrollViewWidth = self.mainTabbar.bounds.size.width
        let scrollViewHeight = Define.screenHeight - self.mainTabbar.bounds.size.height
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: self.mainTabbar.frame.maxY, width: scrollViewWidth, height: scrollViewHeight))
        self.scrollView.contentSize = CGSize(width: CGFloat(viewModel.vcCount) * scrollViewWidth, height: scrollViewHeight)
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.backgroundColor = UIColor.yellow
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        
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
                self.addChild(vc)
                self.scrollView.addSubview(vc.view)
                vc.willMove(toParent: self)
            }
        }
    }
    
    func changeTabbarAppearance() {
        print("TABBAR: time to change tabbar's UI")
    }

}

extension MainViewController : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let nearestIndex = Int(CGFloat(targetContentOffset.pointee.x) / scrollView.bounds.width + 0.5)
        
        if nearestIndex != self.currentIdx {
            self.changeTabbarAppearance()
        }
        self.currentIdx = nearestIndex
        print("nearest idx: \(nearestIndex)")
    }
    
    
}
