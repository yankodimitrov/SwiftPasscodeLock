//
//  GenericPasscodeLock.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/27/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

class GenericPasscodeLock: PasscodeLock, PasscodeLockStateFactory {
    
    var passcode: [String] {
        return passcodeStack
    }
    
    var state: PasscodeLockState? {
        didSet {
            
            state?.passcodeLock = self
            state?.stateFactory = self
            
            delegate?.passcodeLock(self, changedToState: state!)
        }
    }
    
    weak var delegate: PasscodeLockDelegate?
    private lazy var passcodeStack = [String]()
    private let repository: PasscodeRepository
    private let length: Int
    private var signCounter = 0
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    init(length: UInt, repository: PasscodeRepository) {
        
        self.length = Int(length)
        self.repository = repository
    }
    
    convenience init(repository: PasscodeRepository) {
        
        self.init(length: 4, repository: repository)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - PasscodeLock
    ///////////////////////////////////////////////////////
    
    func enterSign(sign: String) {
        
        assert(sign != "", "Can't enter an empty passcode sign")
        
        passcodeStack.append(sign)
        delegate?.passcodeLock(self, addedSignAtIndex: signCounter)
        signCounter += 1
        
        if signCounter == length {
            
            state?.verifyPasscode()
        }
    }
    
    func removeSign() {
        
        if passcodeStack.count == 0 {
            return
        }
        
        passcodeStack.removeLast()
        signCounter -= 1
        delegate?.passcodeLock(self, removedSignAtIndex: signCounter)
    }
    
    func resetSigns() {
        
        passcodeStack.removeAll(keepCapacity: true)
        signCounter = 0
        delegate?.passcodeLockDidReset(self)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - PasscodeLockStateFactory
    ///////////////////////////////////////////////////////
    
    func makeEnterPasscodeState() -> PasscodeLockState {
        
        return EnterPasscodeState(passcodeRepository: repository)
    }
    
    func makeSetPasscodeState() -> PasscodeLockState {
        
        return SetPasscodeState()
    }
    
    func makeConfirmPasscodeState() -> PasscodeLockState {
        
        return ConfirmPasscodeState(passcode: passcode, passcodeRepository: repository)
    }
    
    func makePasscodesMismatchState() -> PasscodeLockState {
        
        return PasscodesMismatchState()
    }
    
    func makeChangePasscodeState() -> PasscodeLockState {
        
        return ChangePasscodeState(passcodeRepository: repository)
    }
}
