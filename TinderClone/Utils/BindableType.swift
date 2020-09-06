//
//  BindableType.swift
//  TinderClone
//
//  Created by HieuPM on 9/6/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import Foundation
import UIKit

protocol BindableType : class {
    associatedtype ViewModelType
    
    var viewModel : ViewModelType! {get set}
    func bindViewModel()
}

extension BindableType where Self : UIViewController {
    func bind(to model : Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
