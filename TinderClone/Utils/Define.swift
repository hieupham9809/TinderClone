//
//  Define.swift
//  TinderClone
//
//  Created by HieuPM on 9/6/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import Foundation
import UIKit

struct Define {
    static var safeAreaTop : CGFloat {
        let window = UIApplication.shared.keyWindow
        var top : CGFloat = 0.0
        if #available(iOS 11, *) {
            top = window?.safeAreaInsets.top ?? 0.0
        } else {
            top = window?.rootViewController?.topLayoutGuide.length ?? 0.0
        }
        
        return top
    }
    
    static var safeAreaBottom : CGFloat {
        let window = UIApplication.shared.keyWindow
        var bottom : CGFloat = 0.0
        if #available(iOS 11, *) {
            bottom = window?.safeAreaInsets.bottom ?? 0.0
        } else {
            bottom = window?.rootViewController?.bottomLayoutGuide.length ?? 0.0
        }
        
        return bottom
    }
    
    static var safeAreaLeading : CGFloat {
        let window = UIApplication.shared.keyWindow
        var leading : CGFloat = 0.0

        if #available(iOS 11, *) {
            leading = window?.safeAreaInsets.left ?? 0.0
        }
        return leading
    }
    
    static var safeAreaTrailing : CGFloat {
        let window = UIApplication.shared.keyWindow
        var trailing : CGFloat = 0.0
        
        if #available(iOS 11, *) {
            trailing = window?.safeAreaInsets.right ?? 0.0
        }
        return trailing
    }
    
    static var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight : CGFloat {
        return UIScreen.main.bounds.height
    }
}
