//
//  ChangePasscodeStateTests.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/28/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class ChangePasscodeStateTests: XCTestCase {
    
    func testThatWillChangeStateToSetPasscodeOnCorrectPasscode() {
        
        class SetPasscodeStateStub: PasscodeLockStateStub {}
        
        class MockFactory: PasscodeLockStateFactoryStub {
            
            override func makeSetPasscodeState() -> PasscodeLockState {
                
                return SetPasscodeStateStub()
            }
        }
        
        let repository = PasscodeRepositoryStub()
        let lock = PasscodeLockStub()
        let factory = MockFactory()
        
        let state = ChangePasscodeState(passcodeRepository: repository)
            state.passcodeLock = lock
            state.stateFactory = factory
        
        state.verifyPasscode()
        
        XCTAssertTrue(lock.state is SetPasscodeStateStub, "Should change state to set passcode on correct passcode")
    }
    
    func testThatWillCallTheDelegateOnIncorrectPasscode() {
        
        class MockLock: PasscodeLockStub {
            
            override var passcode: [String] {
                
                return ["1"]
            }
        }
        
        class MockDelegate: PasscodeLockDelegateStub {
            
            var didFailed = false
            
            override func passcodeLockDidFailed(passcodeLock: PasscodeLock) {
                
                didFailed = true
            }
        }
        
        let repository = PasscodeRepositoryStub()
        let delegate = MockDelegate()
        
        let lock = MockLock()
            lock.delegate = delegate
        
        let state = ChangePasscodeState(passcodeRepository: repository)
            state.passcodeLock = lock
        
        state.verifyPasscode()
        
        XCTAssertTrue(delegate.didFailed, "Should call the delegate on wrong passcode")
    }
}
