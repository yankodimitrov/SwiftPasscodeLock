//
//  ChangePasscodeStateTests.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class ChangePasscodeStateTests: XCTestCase {
    
    var passcodeLock: FakePasscodeLock!
    var passcodeState: ChangePasscodeState!
    var repository: FakePasscodeRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = FakePasscodeRepository()
        
        let config = FakePasscodeLockConfiguration(repository: repository)
        
        passcodeState = ChangePasscodeState()
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
        
        XCTAssert(passcodeLock.state is SetPasscodeState, "Should change the state to SetPasscodeState")
        XCTAssertEqual(delegate.didChangedState, true, "Should call the delegate when the passcode is correct")
    }
    
    func testAcceptIncorrectPasscode() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var called = false
            
            override func passcodeLockDidFail(lock: PasscodeLockType) {
                
                called = true
            }
        }
        
        let delegate = MockDelegate()
        
        passcodeLock.delegate = delegate
        passcodeState.acceptPasscode(["0", "0", "0", "0"], fromLock: passcodeLock)
        
        XCTAssertEqual(delegate.called, true, "Should call the delegate when the passcode is incorrect")
    }
}
