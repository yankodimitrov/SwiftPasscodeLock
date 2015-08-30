//
//  SetPasscodeStateTests.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class SetPasscodeStateTests: XCTestCase {
    
    var passcodeLock: FakePasscodeLock!
    var passcodeState: SetPasscodeState!
    var repository: FakePasscodeRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = FakePasscodeRepository()
        
        let config = FakePasscodeLockConfiguration(repository: repository)
        
        passcodeState = SetPasscodeState()
        passcodeLock = FakePasscodeLock(state: passcodeState, configuration: config)
    }
    
    func testAcceptCorrectPasscode() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var didChangedState = false
            
            override func passcodeLockDidChangeState(lock: PasscodeLockType) {
                
                didChangedState = true
            }
        }
        
        let delegate = MockDelegate()
        
        passcodeLock.delegate = delegate
        passcodeState.acceptPasscode(repository.fakePasscode, fromLock: passcodeLock)
        
        XCTAssert(passcodeLock.state is ConfirmPasscodeState, "Should change the state to ConfirmPasscodeState")
        XCTAssertEqual(delegate.didChangedState, true, "Should inform the delegate for the state change")
    }
}
