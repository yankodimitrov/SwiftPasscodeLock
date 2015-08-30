//
//  ConfirmPasscodeStateTests.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class ConfirmPasscodeStateTests: XCTestCase {
    
    let passcodeToConfirm = ["0", "0", "0", "0"]
    var passcodeLock: FakePasscodeLock!
    var passcodeState: ConfirmPasscodeState!
    var repository: FakePasscodeRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = FakePasscodeRepository()
        
        let config = FakePasscodeLockConfiguration(repository: repository)
        
        passcodeState = ConfirmPasscodeState(passcode: passcodeToConfirm)
        passcodeLock = FakePasscodeLock(state: passcodeState, configuration: config)
    }
    
    func testAcceptCorrectPasscode() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var called = false
            
            override func passcodeLockDidSucceed(lock: PasscodeLockType) {
                
                called = true
            }
        }
        
        let delegate = MockDelegate()
        
        passcodeLock.delegate = delegate
        passcodeState.acceptPasscode(passcodeToConfirm, fromLock: passcodeLock)
        
        XCTAssertEqual(delegate.called, true, "Should call the delegate when the passcode is correct")
    }
    
    func testAcceptCorrectPasscodeWillSaveThePasscode() {
        
        passcodeState.acceptPasscode(passcodeToConfirm, fromLock: passcodeLock)
        
        XCTAssertEqual(repository.savePasscodeCalled, true, "Should call the repository to save the new passcode")
        XCTAssertEqual(repository.savedPasscode, passcodeToConfirm, "Should save the confirmed passcode")
    }
    
    func testAcceptIncorrectPasscode() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var didFailed = false
            var didChangedState = false
            
            override func passcodeLockDidFail(lock: PasscodeLockType) {
                
                didFailed = true
            }
            
            override func passcodeLockDidChangeState(lock: PasscodeLockType) {
                
                didChangedState = true
            }
        }
        
        let delegate = MockDelegate()
        
        passcodeLock.delegate = delegate
        passcodeState.acceptPasscode(["1", "2"], fromLock: passcodeLock)
        
        XCTAssertEqual(passcodeLock.changeStateCalled, true, "Should change the state")
        XCTAssert(passcodeLock.state is SetPasscodeState, "Should change the state to SetPasscodeState")
        XCTAssertEqual(delegate.didFailed, true, "Should call the delegate when the passcode confirmation fails")
        XCTAssertEqual(delegate.didChangedState, true, "Should change the state")
    }
}
