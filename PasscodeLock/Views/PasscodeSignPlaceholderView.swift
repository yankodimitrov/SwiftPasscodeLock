//
//  PasscodeSignPlaceholderView.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
public class PasscodeSignPlaceholderView: UIView {
    
    public enum State {
        case Inactive
        case Active
        case Error
    }
    
    @IBInspectable
    public var inactiveColor: UIColor = UIColor.whiteColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var activeColor: UIColor = UIColor.grayColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var errorColor: UIColor = UIColor.redColor() {
        didSet {
            setupView()
        }
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public override func intrinsicContentSize() -> CGSize {
        
        return CGSizeMake(16, 16)
    }
    
    private func setupView() {
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = activeColor.CGColor
        backgroundColor = inactiveColor
    }
    
    private func colorsForState(state: State) -> (backgroundColor: UIColor, borderColor: UIColor) {
        
        switch state {
        case .Inactive: return (inactiveColor, activeColor)
        case .Active: return (activeColor, activeColor)
        case .Error: return (errorColor, errorColor)
        }
    }
    
    public func animateState(state: State) {
        
        let colors = colorsForState(state)
        
        UIView.animateWithDuration(
            0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                
                self.backgroundColor = colors.backgroundColor
                self.layer.borderColor = colors.borderColor.CGColor
                
            },
            completion: nil
        )
    }
}
