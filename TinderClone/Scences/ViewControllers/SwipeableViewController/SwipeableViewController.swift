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
    var bottomControlView: SwipeControlView?
    var startPosition: CGPoint?
    var startTransform: CGAffineTransform?
    var movedXValue: CGFloat = 0
    
    let flingTime: TimeInterval = 0.3
    let initialBackViewScale: CGFloat = 0.95
    let flingVelocityThreshold: CGFloat = 20.0
    
    var myLikesView: UIView?
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getInitialProfiles()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        setupFrontAndBackView()
        setupBottomView()
        setupMyLikesView()
    }
    
    func setupBottomView() {
        let parentWidth = self.frontView?.bounds.size.width ?? 0.0
        let parentHeight = self.frontView?.bounds.size.height ?? 0.0
        
        let bottomViewWidth = parentWidth
        let bottomViewHeight = bottomViewWidth * 0.2
        
        bottomControlView = SwipeControlView(
            frame: CGRect(x: 0, y: parentHeight - bottomViewHeight,
                          width: bottomViewWidth, height: bottomViewHeight)
        )
        bottomControlView?.delegate = self
        self.view.addSubview(bottomControlView!)
        self.view.bringSubviewToFront(bottomControlView!)
    }
    
    func getInitialProfiles() {
        guard let validViewModel = viewModel else {return}
        validViewModel.fetchAvailablePartners()
    }
    
    func setupFrontAndBackView() {
        let parentWidth = self.view.bounds.size.width
        let parentHeight = self.view.bounds.size.height
        
        let marginValue: CGFloat = 3.0
        let frontViewWidth = parentWidth - 2 * marginValue
        let frontViewHeight = parentHeight - 2 * marginValue
        frontView = UIView(
            frame: CGRect(origin: CGPoint(x: marginValue, y: marginValue),
                          size: CGSize(width: frontViewWidth,
                                       height: frontViewHeight)))
        frontView.backgroundColor = .clear
        
        let backViewWidth = frontViewWidth
        let backViewHeight = backViewWidth * 4 / 3
        backView = UIView(frame: CGRect(origin: CGPoint(x: marginValue,
                                                        y: marginValue),
                                        size: CGSize(width: backViewWidth,
                                                     height: backViewHeight)))
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
        let panGesture
            = UIPanGestureRecognizer(target: self,
                                     action: #selector(panHandle(sender:)))
        swipeView.addGestureRecognizer(panGesture)
        let transform = swipeView.transform
        transform.scaledBy(x: initialBackViewScale, y: initialBackViewScale)
        swipeView.transform = transform
        
        swipeView.layer.masksToBounds = false
        swipeView.layer.shadowPath
            = UIBezierPath(rect: swipeView.bounds).cgPath
        swipeView.layer.shadowOffset = CGSize(width: 0, height: 8)
        swipeView.layer.shadowRadius = 5.0
        swipeView.layer.shadowOpacity = 0.1
        swipeView.setContent(content: swipeProfile)
        backView?.addSubview(swipeView)
        
        
    }
    
    func bringSwipeViewToFront() {
        frontView?.subviews.forEach({view in view.removeFromSuperview()})
        
        guard let validBackView = self.backView,
            let validFrontView = self.frontView else {return}
        if let swipeView = validBackView.subviews.first as? SwipeInfoView {
            swipeView.removeFromSuperview()
            startTransform = swipeView.transform
            validFrontView.addSubview(swipeView)
        }
    }
    
    func getNextPartner() {
        bringSwipeViewToFront()
        bringSwipeViewToBack()
    }
    
    func setupMyLikesView() {
        let myLikesVC = MyLikesViewController()
        let myLikesVM = MyLikesViewModel()
        
        myLikesVC.bind(to: myLikesVM)
        
        myLikesView = myLikesVC.view
        
        myLikesView?.frame = self.view.bounds
        myLikesVC.setupViews()
        
        self.addChild(myLikesVC)
        self.view.addSubview(myLikesVC.view)
        self.view.bringSubviewToFront(myLikesVC.view)
        myLikesVC.willMove(toParent: self)
        
        myLikesView?.backgroundColor = UIColor.white
        myLikesView?.isHidden = true
    }
}

extension SwipeableViewController {
    @objc func panHandle(sender: UIPanGestureRecognizer) {
        guard let targetView = sender.view,
            let validBackView = backView else {return}
        let translation = sender.translation(in: validBackView)
        
        switch sender.state {
        case .began:
            startPosition = sender.location(in: validBackView)
        case .changed:
            targetView.center
                = CGPoint(x: targetView.center.x + translation.x,
                          y: targetView.center.y + translation.y)
            movedXValue += translation.x
            if let validStartPosition = startPosition {
                if validStartPosition.y > validBackView.center.y {
                    startRotateFromLowerHalf(targetView: targetView)
                } else {
                    startRotateFromUpperHalf(targetView: targetView)
                }
            }
            
            scaleBackviewBy(frontView: targetView)
        case .ended, .cancelled:
            movedXValue = 0
            
            if isVelocityReached(from: sender, in: validBackView)
                || canMoveToNext(view: targetView) {
                // fling out of screen
                flingViewOut(targetView: targetView, fromBackView: validBackView)
            } else {
                // fling back to center of backview
                flingViewToBack(targetView: targetView)
                
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.backView)
    }
    
    func canMoveToNext(view: UIView) -> Bool {
        guard let validBackView = backView else {return false}
        let movedX = abs(view.center.x - validBackView.center.x)
        let movedY = abs(view.center.y - validBackView.center.y)
        let moveThresholdX = validBackView.bounds.size.width / 2
        let moveThresholdY = validBackView.bounds.size.height / 2
        
        return movedX > moveThresholdX || movedY > moveThresholdY
    }
    
    func startRotateFromUpperHalf(targetView: UIView) {
        guard let validStartTransform = startTransform else {return}
        let maximumRadius = CGFloat.pi / 4
        let maximumSpace = self.view.bounds.size.width
        
        let targetTransform
            = validStartTransform.rotated(
                by: movedXValue / maximumSpace * maximumRadius)
        targetView.transform = targetTransform
        
    }
    
    func startRotateFromLowerHalf(targetView: UIView) {
        guard let validStartTransform = startTransform else {return}
        let maximumRadius = CGFloat.pi / 4
        let maximumSpace = self.view.bounds.size.width
        
        let targetTransform
            = validStartTransform.rotated(
                by: movedXValue * (-1) / maximumSpace * maximumRadius)
        targetView.transform = targetTransform
    }
    
    func scaleBackviewBy(frontView: UIView) {
        guard let validBackView = backView,
            let swipeBackview = validBackView.subviews.first
                as? SwipeInfoView else {return}
        
        let viewWidth = self.view.bounds.size.width
        let movedX = abs(frontView.center.x - validBackView.center.x)
        let movedY = abs(frontView.center.y - validBackView.center.y)
        
        let targetMove = min(max(movedX, movedY),
                             viewWidth / 2)
        let targetScale = (1 - initialBackViewScale) * 2 / viewWidth
            * targetMove + initialBackViewScale
        let currentTransform = swipeBackview.transform
        swipeBackview.transform = currentTransform
            .scaledBy(x: targetScale / currentTransform.a,
                      y: targetScale / currentTransform.d)
        
    }
    
    func isVelocityReached(from sender: UIPanGestureRecognizer, in view: UIView) -> Bool {
        let horizontalVeloc = abs(sender.velocity(in: view).x / 60)
        let verticalVeloc = abs(sender.velocity(in: view).y / 60)
        
        return max(horizontalVeloc, verticalVeloc) > flingVelocityThreshold
    }
    
    func flingViewToBack(targetView: UIView) {
        UIView.animate(
            withDuration: flingTime,
            animations:{[weak self] in
                guard let strongSelf = self,
                    let validBackView = strongSelf.backView else {return}
                targetView.center = strongSelf.view.convert(validBackView.center,
                                                            to: validBackView)
                if let validStartTransform = strongSelf.startTransform {
                    targetView.transform = validStartTransform
                }
                strongSelf.scaleBackviewBy(frontView: targetView)
                
        })
    }
    
    func flingViewOut(targetView: UIView, fromBackView backView: UIView) {
        let viewWidth = targetView.bounds.size.width
        let viewHeight = targetView.bounds.size.height
        
        let movedX = abs(targetView.center.x - backView.center.x)
        let movedY = abs(targetView.center.y - backView.center.y)
        
        var targetCenter: CGPoint
        if movedX > movedY {
            targetCenter = targetView.center.x > backView.center.x
                ? CGPoint(x: 2 * viewWidth, y: targetView.center.y)
                : CGPoint(x: -2 * viewWidth, y: targetView.center.y)
        } else {
            targetCenter = targetView.center.y > backView.center.y
                ? CGPoint(x: targetView.center.x, y: 2 * viewHeight)
                : CGPoint(x: targetView.center.x, y: -2 * viewHeight)
        }
        UIView.animate(withDuration: flingTime,
                       animations:{[weak self] in
                        guard let strongSelf = self else {return}
                        targetView.center = targetCenter
                        strongSelf.scaleBackviewBy(frontView: targetView)
            },
                       completion: {[weak self] success in
                        guard let strongSelf = self else {return}
                        targetView.removeFromSuperview()
                        strongSelf.getNextPartner()
                        
            }
        )
    }
    
    func flingFrontViewToRight() {
        guard let targetView = self.frontView?.subviews.first else {return}
        let viewWidth = targetView.bounds.size.width
        let targetCenter = CGPoint(x: 2 * viewWidth, y: targetView.center.y)
        UIView.animate(withDuration: flingTime,
                       animations: {[weak self] in
                        guard let strongSelf = self else {return}
                        targetView.center = targetCenter
                        strongSelf.scaleBackviewBy(frontView: targetView)
            
        }, completion: {[weak self] success in
            guard let strongSelf = self else {return}
            targetView.removeFromSuperview()
            strongSelf.getNextPartner()})
    }
    
    func flingFrontViewToLeft() {
        guard let targetView = self.frontView?.subviews.first else {return}
        let viewWidth = targetView.bounds.size.width
        let targetCenter = CGPoint(x: -2 * viewWidth, y: targetView.center.y)
        UIView.animate(withDuration: flingTime,
                       animations: {[weak self] in
                        guard let strongSelf = self else {return}
                        targetView.center = targetCenter
                        strongSelf.scaleBackviewBy(frontView: targetView)
            
        }, completion: {[weak self] success in
            guard let strongSelf = self else {return}
            targetView.removeFromSuperview()
            strongSelf.getNextPartner()})
    }
    
    func flingFrontViewUp() {
        guard let targetView = self.frontView?.subviews.first else {return}
        let viewHeight = targetView.bounds.size.height
        let targetCenter = CGPoint(x: targetView.center.x, y: -2 * viewHeight)
        UIView.animate(withDuration: flingTime,
                       animations: {[weak self] in
                        guard let strongSelf = self else {return}
                        targetView.center = targetCenter
                        strongSelf.scaleBackviewBy(frontView: targetView)
            
        }, completion: {[weak self] success in
            guard let strongSelf = self else {return}
            targetView.removeFromSuperview()
            strongSelf.getNextPartner()})
    }
}

extension SwipeableViewController: SwipeViewControllerDelegate {
    func didLike() {
        flingFrontViewToRight()
    }
    
    func didDislike() {
        flingFrontViewToLeft()
    }
    
    func didSuperLike() {
        flingFrontViewUp()
    }
    
    
}
