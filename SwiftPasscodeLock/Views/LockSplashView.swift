//
//  LockSplashView.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/25/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit

class LockSplashView: UIView {
    
    private lazy var icon: UIImageView = {
        
        let image = UIImage(named: "lock")
        let view = UIImageView(image: image)
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        return view
    }()
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 231/255, alpha: 1)
        
        addSubview(icon)
        setupLayout()
    }
    
    convenience override init() {
        
        self.init(frame: UIScreen.mainScreen().bounds)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Layout
    ///////////////////////////////////////////////////////
    
    private func setupLayout() {
        
        let views = ["icon": icon]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[icon(80)]", options: nil, metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[icon(80)]", options: nil, metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: icon, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: icon, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }
}
