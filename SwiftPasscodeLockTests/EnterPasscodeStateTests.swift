//
//  EnterPasscodeStateTests.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/27/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class EnterPasscodeStateTests: XCTestCase {
    
    class MockRepository: PasscodeRepositoryStub {
        
        override func getPasscode() -> [String] {
            
            return ["1", "2", "3", "4"]
        }
    }
    
    func testThatVerifyPasscodeWillCallDelegateOnCorrectPasscode() {
        
        class MockLock: PasscodeLockStub {
            
            override var passcode: [String] {
                
                return ["1", "2", "3", "4"]
            }
        }
        
        class LockDelegate: PasscodeLockDelegateStub {
            
            var didSucceed = false
            
            override func passcodeLockDidSucceed(passcodeLock: PasscodeLock) {
                
                didSucceed = true
            }
        }
        
        let repository = MockRepository()
        let delegate = LockDelegate()
        let passcodeLock = MockLock()
            passcodeLock.delegate = delegate
        
        let state = EnterPasscodeState(passcodeRepository: repository)
            state.passcodeLock = passcodeLock
        
        state.verifyPasscode()
        
        XCTAssertTrue(delegate.didSucceed, "Lock delegate should be called on correct passcode")
    }
    
    func testThatVerifyPasscodeWillCallDelegateOnIncorrectPasscode() {
        
        class LockDelegate: PasscodeLockDelegateStub {
            
            var didFailed = false
            
            override func passcodeLockDidFailed(passcodeLock: PasscodeLock) {
                
                didFailed = true
            }
        }
        
        let repository = MockRepository()
        let delegate = LockDelegate()
        let passcodeLock = PasscodeLockStub()
            passcodeLock.delegate = delegate
        
        let state = EnterPasscodeState(passcodeRepository: repository)
            state.passcodeLock = passcodeLock
        
        state.verifyPasscode()
        
        XCTAssertTrue(delegate.didFailed, "Lock delegate should be called on incorrect passcode")
    }
}
