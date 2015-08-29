//
//  PasscodeLockViewController.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public class PasscodeLockViewController: UIViewController, PasscodeLockTypeDelegate {
    
    public enum LockState {
        case EnterPasscode
        case SetPasscode
        case ChangePasscode
        
        func getState() -> PasscodeLockStateType {
            
            switch self {
            case .EnterPasscode: return EnterPasscodeState()
            case .SetPasscode: return SetPasscodeState()
            case .ChangePasscode: return ChangePasscodeState()
            }
        }
    }
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    @IBOutlet public var placeholders: [PasscodeSignPlaceholderView] = [PasscodeSignPlaceholderView]()
    @IBOutlet public weak var cancelButton: UIButton!
    @IBOutlet public weak var deleteSignButton: UIButton!
    @IBOutlet public weak var placeholdersX: NSLayoutConstraint!
    
    internal let passcodeConfiguration: PasscodeLockConfigurationType
    internal let passcodeLock: PasscodeLockType
    internal var isPlaceholdersAnimationCompleted = true
    
    public init(lockState: LockState, configuration: PasscodeLockConfigurationType) {
        
        passcodeConfiguration = configuration
        passcodeLock = PasscodeLock(state: lockState.getState(), configuration: configuration)
        
        let nibName = "PasscodeLockView"
        let bundle: NSBundle = bundleForResource(nibName, ofType: "nib")
        
        super.init(nibName: nibName, bundle: bundle)
        
        passcodeLock.delegate = self
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePasscodeView()
        deleteSignButton.enabled = false
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if passcodeConfiguration.shouldRequestTouchIDImmediately && passcodeLock.isTouchIDAllowed {
            
            passcodeLock.authenticateWithBiometrics()
        }
    }
    
    internal func updatePasscodeView() {
        
        titleLabel.text = passcodeLock.state.title
        descriptionLabel.text = passcodeLock.state.description
    }
    
    // MARK: - Actions
    
    @IBAction func passcodeButtonTap(sender: PasscodeSignButton) {
        
        guard isPlaceholdersAnimationCompleted else { return }
        
        passcodeLock.addSign(sender.passcodeSign)
    }
    
    @IBAction func cancelButtonTap(sender: UIButton) {
        
        dismissPasscodeLock()
    }
    
    @IBAction func deleteSignButtonTap(sender: UIButton) {
        
        passcodeLock.removeSign()
    }
    
    internal func dismissPasscodeLock() {
    
        if navigationController != nil {
        
            navigationController?.popViewControllerAnimated(true)
        
        } else {
        
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Animations
    
    internal func animateWrongPassword() {
        
        deleteSignButton.enabled = false
        isPlaceholdersAnimationCompleted = false
        
        animatePlaceholders(placeholders, toState: .Error)
        
        placeholdersX.constant = -40
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(
            0.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                
                self.placeholdersX.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                
                self.isPlaceholdersAnimationCompleted = true
                self.animatePlaceholders(self.placeholders, toState: .Inactive)
        })
    }
    
    internal func animatePlaceholders(placeholders: [PasscodeSignPlaceholderView], toState state: PasscodeSignPlaceholderView.State) {
        
        for placeholder in placeholders {
            
            placeholder.animateState(state)
        }
    }
    
    private func animatePlacehodlerAtIndex(index: Int, toState state: PasscodeSignPlaceholderView.State) {
        
        guard index < placeholders.count && index >= 0 else { return }
        
        placeholders[index].animateState(state)
    }

    // MARK: - PasscodeLockDelegate
    
    public func passcodeLockDidSucceed(lock: PasscodeLockType) {
        
        dismissPasscodeLock()
    }
    
    public func passcodeLockDidFail(lock: PasscodeLockType) {
        
        animateWrongPassword()
    }
    
    public func passcodeLockDidChangeState(lock: PasscodeLockType) {
        
        updatePasscodeView()
        animatePlaceholders(placeholders, toState: .Inactive)
        deleteSignButton.enabled = false
    }
    
    public func passcodeLock(lock: PasscodeLockType, addedSignAtIndex index: Int) {
        
        animatePlacehodlerAtIndex(index, toState: .Active)
        deleteSignButton.enabled = true
    }
    
    public func passcodeLock(lock: PasscodeLockType, removedSignAtIndex index: Int) {
        
        animatePlacehodlerAtIndex(index, toState: .Inactive)
        
        if index == 0 {
            
            deleteSignButton.enabled = false
        }
    }
}
