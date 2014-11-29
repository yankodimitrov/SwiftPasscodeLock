//
//  PasscodesMismatchStateTests.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/28/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class PasscodesMismatchStateTests: XCTestCase {

    func testThatWillChangeStateToConfirmPasscode() {
        
        class ConfirmStateStub: PasscodeLockStateStub {}
        
        class MockFactory: PasscodeLockStateFactoryStub {
            
            override func makeConfirmPasscodeState() -> PasscodeLockState {
                
                return ConfirmStateStub()
            }
        }
        
        let lock = PasscodeLockStub()
        let factory = MockFactory()
        
        let state = PasscodesMismatchState()
            state.passcodeLock = lock
            state.stateFactory = factory
        
        state.verifyPasscode()
        
        XCTAssertTrue(lock.state is ConfirmStateStub, "Should change state to set passcode on correct passcode")
    }
}
