//
//  SwipeControlView.swift
//  TinderClone
//
//  Created by HieuPM on 10/10/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import UIKit

protocol SwipeViewControllerDelegate: class {
    func didLike()
    func didDislike()
    func didSuperLike()
}

class SwipeControlView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var superLikeBtn: UIButton!
    @IBOutlet weak var ignoreBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var rollBackBtn: UIButton!
    
    @IBOutlet weak var superlikeWidthBtnConstraint: NSLayoutConstraint!
    
    weak var delegate: SwipeViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupViews()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SwipeControlView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupViews() {
        setupSuperlikeBtn()
        setupLikeBtn()
        setupIgnoreBtn()
        setupFlashBtn()
        setupRollbackBtn()
    }
    
    func setupSuperlikeBtn() {
        configBtn(button: superLikeBtn)
        superLikeBtn.addTarget(self,
                               action: #selector(superLikeTappedHandle(sender:)),
                               for: .touchUpInside)
    }
    
    @objc func superLikeTappedHandle(sender: UIButton) {
        delegate?.didSuperLike()
    }
    
    func setupLikeBtn() {
        configBtn(button: likeBtn)
        likeBtn.addTarget(self,
                          action: #selector(likeTappedHandle(sender:)),
                          for: .touchUpInside)
    }
    
    @objc func likeTappedHandle(sender: UIButton) {
        delegate?.didLike()
    }
    
    func setupIgnoreBtn() {
        configBtn(button: ignoreBtn)
        ignoreBtn.addTarget(self,
                            action: #selector(disLikeTappedHandle(sender:)),
                            for: .touchUpInside)
    }
    
    @objc func disLikeTappedHandle(sender: UIButton) {
        delegate?.didDislike()
    }
    
    func setupFlashBtn() {
        configBtn(button: flashBtn)
    }
    
    func setupRollbackBtn() {
        configBtn(button: rollBackBtn)
    }
    
    func configBtn(button: UIButton) {
        let btnWidth = button.bounds.size.width
        let btnHeight = button.bounds.size.height
        
        button.layer.backgroundColor = UIColor.myBackgroundColor().cgColor
        button.layer.cornerRadius = btnWidth / 2
        button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: btnWidth / 2).cgPath
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 5.0
    }
}
