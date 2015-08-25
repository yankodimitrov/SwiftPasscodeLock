//
//  GenericPasscodeLock.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/27/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class GenericPasscodeLock: PasscodeLock, PasscodeLockStateFactory {
    
    public var passcode: [String] {
        return passcodeStack
    }
    
    public var state: PasscodeLockState? {
        didSet {
            
            state?.passcodeLock = self
            state?.stateFactory = self
            
            delegate?.passcodeLock(self, changedToState: state!)
        }
    }
    
    public weak var delegate: PasscodeLockDelegate?
    private lazy var passcodeStack = [String]()
    private let repository: PasscodeRepository
    private let length: Int
    private var signCounter = 0
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    public init(length: UInt, repository: PasscodeRepository) {
        
        self.length = Int(length)
        self.repository = repository
    }
    
    convenience init(repository: PasscodeRepository) {
        
        self.init(length: 4, repository: repository)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - PasscodeLock
    ///////////////////////////////////////////////////////
    
    public func enterSign(sign: String) {
        
        assert(sign != "", "Can't enter an empty passcode sign")
        
        passcodeStack.append(sign)
        delegate?.passcodeLock(self, addedSignAtIndex: signCounter)
        signCounter += 1
        
        if signCounter == length {
            
            state?.verifyPasscode()
        }
    }
    
    public func removeSign() {
        
        if passcodeStack.count == 0 {
            return
        }
        
        passcodeStack.removeLast()
        signCounter -= 1
        delegate?.passcodeLock(self, removedSignAtIndex: signCounter)
    }
    
    public func resetSigns() {
        
        passcodeStack.removeAll(keepCapacity: true)
        signCounter = 0
        delegate?.passcodeLockDidReset(self)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - PasscodeLockStateFactory
    ///////////////////////////////////////////////////////
    
    public func makeEnterPasscodeState() -> PasscodeLockState {
        
        return EnterPasscodeState(passcodeRepository: repository)
    }
    
    public func makeSetPasscodeState() -> PasscodeLockState {
        
        return SetPasscodeState()
    }
    
    public func makeConfirmPasscodeState() -> PasscodeLockState {
        
        return ConfirmPasscodeState(passcode: passcode, passcodeRepository: repository)
    }
    
    public func makePasscodesMismatchState() -> PasscodeLockState {
        
        return PasscodesMismatchState()
    }
    
    public func makeChangePasscodeState() -> PasscodeLockState {
        
        return ChangePasscodeState(passcodeRepository: repository)
    }
}
