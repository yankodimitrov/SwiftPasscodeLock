//
//  PasscodeLock.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
import LocalAuthentication

public class PasscodeLock: PasscodeLockType {
    
    public weak var delegate: PasscodeLockTypeDelegate?
    public let configuration: PasscodeLockConfigurationType
    
    public var repository: PasscodeRepositoryType {
        return configuration.repository
    }
    
    public var state: PasscodeLockStateType {
        return lockState
    }
    
    public var isTouchIDAllowed: Bool {
        return isTouchIDEnabled() && configuration.isTouchIDAllowed && lockState.isTouchIDAllowed
    }
    
    private var lockState: PasscodeLockStateType
    private lazy var passcode = [String]()
    
    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType) {
        
        precondition(configuration.passcodeLength > 0, "Passcode length sould be greather than zero.")
        
        self.lockState = state
        self.configuration = configuration
    }
    
    public func addSign(sign: String) {
        
        passcode.append(sign)
        delegate?.passcodeLock(self, addedSignAtIndex: passcode.count - 1)
        
        if passcode.count >= configuration.passcodeLength {
            
            lockState.acceptPasscode(passcode, fromLock: self)
            passcode.removeAll(keepCapacity: true)
        }
    }
    
    public func removeSign() {
        
        guard passcode.count > 0 else { return }
        
        passcode.removeLast()
        delegate?.passcodeLock(self, removedSignAtIndex: passcode.count)
    }
    
    public func changeStateTo(state: PasscodeLockStateType) {
        
        lockState = state
        delegate?.passcodeLockDidChangeState(self)
    }
    
    public func authenticateWithBiometrics() {
        
        guard isTouchIDAllowed else { return }
        
        let context = LAContext()
        let reason = localizedStringFor("PasscodeLockTouchIDReason", comment: "TouchID authentication reason")

        context.localizedFallbackTitle = localizedStringFor("PasscodeLockTouchIDButton", comment: "TouchID authentication fallback button")
        
        context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            success, error in
            
            self.handleTouchIDResult(success)
        }
    }
    
    private func handleTouchIDResult(success: Bool) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if success {
                
                self.delegate?.passcodeLockDidSucceed(self)
            }
        }
    }
    
    private func isTouchIDEnabled() -> Bool {
        
        let context = LAContext()
        
        return context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
