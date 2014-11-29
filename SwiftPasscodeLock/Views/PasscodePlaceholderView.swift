//
//  PasscodePlaceholderView.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/20/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
public class PasscodePlaceholderView: UIView {
    
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
    public var activeColor: UIColor = UIColor.whiteColor() {
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
    
    @IBInspectable
    public var borderWidth: CGFloat = 1 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var borderRadius: CGFloat = 8 {
        didSet {
            setupView()
        }
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    public required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    private func setupView() {
        
        layer.cornerRadius = borderRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
        backgroundColor = inactiveColor
    }
    
    public func changeState(state: PasscodePlaceholderView.State) {
        
        switch state {
            case .Inactive: animate(backgroundColor: inactiveColor, borderColor: borderColor)
            case .Active:   animate(backgroundColor: activeColor, borderColor: activeColor)
            case .Error:    animate(backgroundColor: errorColor, borderColor: errorColor)
        }
    }
    
    private func animate(#backgroundColor: UIColor, borderColor: UIColor) {
        
        UIView.animateWithDuration(
            0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: nil,
            animations: {
                
                self.backgroundColor = backgroundColor
                self.layer.borderColor = borderColor.CGColor
                
            },
            completion: nil
        )
        
    }
}
