//
//  LaunchScreenViewController.swift
//  TinderClone
//
//  Created by HieuPM on 9/6/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addAppIcon()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupAndJumpToMain()
    }
    
    func addAppIcon() {
        let screenWidth = Define.screenWidth
        let screenHeight = Define.screenHeight
        let imageWidth : CGFloat = 50
        let imageHeight = imageWidth
        let iconImageView = UIImageView(frame:
            CGRect(
                origin: CGPoint(
                    x: (screenWidth - imageWidth) / 2,
                    y: (screenHeight - imageHeight) / 2),
                size: CGSize(width: imageWidth, height: imageHeight)))
        iconImageView.image = UIImage(named: "LaunchScreenIcon")
        
        self.view.addSubview(iconImageView)
    }
    
    func setupAndJumpToMain() {
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1) as Date)
        
        let mainVC = MainViewController()
        let mainModel = MainViewModel()
        
        mainVC.bind(to: mainModel)
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
        
    }
 

}
