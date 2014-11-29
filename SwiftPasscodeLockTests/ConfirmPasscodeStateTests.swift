//
//  ConfirmPasscodeStateTests.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/28/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class ConfirmPasscodeStateTests: XCTestCase {
    
    let passcodeToConfirm = ["1", "5"]
    
    func testThatDelegateIsCalledOnEqualPasscodes() {
        
        class MockLock: PasscodeLockStub {
            
            override var passcode: [String] {
                return ["1", "5"]
            }
        }
        
        class MockDelegate: PasscodeLockDelegateStub {
            
            var didSucceed = false
            
            override func passcodeLockDidSucceed(passcodeLock: PasscodeLock) {
                
                didSucceed = true
            }
        }
        
        let repository = PasscodeRepositoryStub()
        let delegate = MockDelegate()
        
        let lock = MockLock()
            lock.delegate = delegate
        
        let state = ConfirmPasscodeState(passcode: passcodeToConfirm, passcodeRepository: repository)
            state.passcodeLock = lock
        
        state.verifyPasscode()
        
        XCTAssertTrue(delegate.didSucceed, "Should call the delegate when passcodes are equal")
        
    }
    
    func testThatWillSwitchToPasscodesMismatchStateOnPasscodesMismatch() {
        
        class MismatchStateStub: PasscodeLockStateStub {}
        
        class MockFactory: PasscodeLockStateFactoryStub {
            
            override func makePasscodesMismatchState() -> PasscodeLockState {
                
                return MismatchStateStub()
            }
        }
        
        let repository = PasscodeRepositoryStub()
        let lock = PasscodeLockStub()
        let factory = MockFactory()
        
        let state = ConfirmPasscodeState(passcode: passcodeToConfirm, passcodeRepository: repository)
            state.passcodeLock = lock
            state.stateFactory = factory
        
        state.verifyPasscode()
        
        XCTAssertTrue(lock.state is MismatchStateStub, "Should switch to passcodes mismatch state on passcodes mismatch")
    }
    
    func testThatWillCallDelegateOnPasscodesMismatch() {
        
        class MockDelegate: PasscodeLockDelegateStub {
            
            var didFailed = false
            
            override func passcodeLockDidFailed(passcodeLock: PasscodeLock) {
                
                didFailed = true
            }
        }
        
        let repository = PasscodeRepositoryStub()
        let delegate = MockDelegate()
        
        let lock = PasscodeLockStub()
            lock.delegate = delegate
        
        let state = ConfirmPasscodeState(passcode: passcodeToConfirm, passcodeRepository: repository)
            state.passcodeLock = lock
        
        state.verifyPasscode()
        
        XCTAssertTrue(delegate.didFailed, "Should call the delegate on passcodes mismatch")
    }
}
