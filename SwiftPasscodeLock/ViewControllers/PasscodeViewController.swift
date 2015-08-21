//
//  PasscodeViewController.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/18/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import LocalAuthentication

public class PasscodeViewController: UIViewController, PasscodeLockPresentable, PasscodeLockDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var placeholders: [PasscodePlaceholderView] = [PasscodePlaceholderView]()
    @IBOutlet weak var placeholdersWrapperX: NSLayoutConstraint!
    
    public var hideCancelButton = false
    public var onCorrectPasscode: ( () -> Void )?
    
    private let passcodeLock: PasscodeLock
    private var isWrongPasscodeAnimationCompleted = true
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    public init(passcodeLock lock: PasscodeLock) {
        
        passcodeLock = lock
        
        super.init(nibName: "PasscodeView", bundle: nil)
        
        passcodeLock.delegate = self
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - View
    ///////////////////////////////////////////////////////
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    public override func supportedInterfaceOrientations() -> Int {
        
        let device = UIDevice.currentDevice()
        
        if device.userInterfaceIdiom == .Pad {
            
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
        
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    private func updateView() {
        
        titleLabel.text = passcodeLock.state?.title
        descriptionLabel.text = passcodeLock.state?.description
        cancelButton.hidden = hideCancelButton
        
        if passcodeLock.state is EnterPasscodeState {
            
            authenticateUsingTouchID()
        }
    }
    
    private func changePlaceholders(placeholders: [PasscodePlaceholderView], toState state: PasscodePlaceholderView.State) {
        
        placeholders.map({ $0.changeState(state) })
    }
    
    private func changePlaceholder(atIndex index: Int, toState state: PasscodePlaceholderView.State) {
        
        assert( (index < placeholders.count || index < 0 ), "Placeholder index is out of range")
        
        placeholders[index].changeState(state)
    }
    
    private func animateWrongPasscode() {
        
        changePlaceholders(placeholders, toState: .Error)
        
        isWrongPasscodeAnimationCompleted = false
        placeholdersWrapperX.constant = -40
        
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(
            0.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: nil,
            animations: {
                
                self.placeholdersWrapperX.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: {
                finished in
                
                self.passcodeLock.resetSigns()
                self.isWrongPasscodeAnimationCompleted = true
            }
        )
        
    }
    
    private func authenticateUsingTouchID() {
        
        var error: NSError?
        let context = LAContext()
        let reason = NSLocalizedString("PasscodeLockTouchIDReason", tableName: "PasscodeLock", bundle: getLocalizationBundle(), comment: "")
        
        if !context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            return
        }
        
        context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {
            success, error in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.handleCorrectPasscode()
                })
            }
        })
        
    }
    
    private func handleCorrectPasscode() {
        
        onCorrectPasscode?()
        
        passcodeLock.resetSigns()
    }
    
    @IBAction func passcodeButtonTap(sender: PasscodeButton) {
        
        if isWrongPasscodeAnimationCompleted {
            
            passcodeLock.enterSign(sender.passcodeSign)
        }
    }
    
    @IBAction func deleteButtonTap(sender: UIButton) {
        
        passcodeLock.removeSign()
    }
    
    @IBAction func cancelButtonTap(sender: UIButton) {
        
        passcodeLock.resetSigns()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - PasscodeLockDelegate
    ///////////////////////////////////////////////////////
    
    public func passcodeLockDidSucceed(passcodeLock: PasscodeLock) {
        
        handleCorrectPasscode()
    }
    
    public func passcodeLockDidFailed(passcodeLock: PasscodeLock) {
        
        animateWrongPasscode()
    }
    
    public func passcodeLockDidReset(passcodeLock: PasscodeLock) {
        
        changePlaceholders(placeholders, toState: .Inactive)
    }
    
    public func passcodeLock(passcodeLock: PasscodeLock, changedToState state: PasscodeLockState) {
        
        updateView()
    }
    
    public func passcodeLock(passcodeLock: PasscodeLock, addedSignAtIndex index: Int) {
        
        changePlaceholder(atIndex: index, toState: .Active)
    }
    
    public func passcodeLock(passcodeLock: PasscodeLock, removedSignAtIndex index: Int) {
        
        changePlaceholder(atIndex: index, toState: .Inactive)
    }
}
