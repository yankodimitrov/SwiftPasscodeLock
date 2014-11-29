//
//  PasscodeButton.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/19/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
public class PasscodeButton: UIButton {
    
    @IBInspectable
    public var passcodeSign: String = "1"
    
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
    public var borderRadius: CGFloat = 35 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var buttonBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var buttonHighlightBackgroundColor: UIColor = UIColor.whiteColor() {
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
        setupActions()
    }

    public required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupActions()
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    private func setupActions() {
        
        addTarget(self, action: Selector("handleTouchDown"), forControlEvents: .TouchDown)
        addTarget(self, action: Selector("handleTouchUp"), forControlEvents: .TouchUpInside | .TouchDragOutside | .TouchCancel)
    }
    
    private func setupView() {
        
        layer.cornerRadius = borderRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
        backgroundColor = buttonBackgroundColor
    }
    
    func handleTouchDown() {
        
        animateButton(backgroundColor: buttonHighlightBackgroundColor)
    }
    
    func handleTouchUp() {
        
        animateButton(backgroundColor: buttonBackgroundColor)
    }
    
    private func animateButton(#backgroundColor: UIColor) {
        
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.0,
            options: .AllowUserInteraction | .BeginFromCurrentState,
            animations: {
                
                self.backgroundColor = backgroundColor
            },
            completion: nil
        )
        
    }

}

