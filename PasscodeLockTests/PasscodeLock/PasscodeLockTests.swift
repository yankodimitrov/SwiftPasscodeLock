//
//  PasscodeLockTests.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class PasscodeLockTests: XCTestCase {
    
    var passcodeLock: PasscodeLock!
    var initialState: FakePasscodeState!
    
    override func setUp() {
        super.setUp()
        
        let repository = FakePasscodeRepository()
        let config = FakePasscodeLockConfiguration(repository: repository)
        
        initialState = FakePasscodeState()
        passcodeLock = PasscodeLock(state: initialState, configuration: config)
    }
    
    func testSetStateTo() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var called = false
            
            override func passcodeLockDidChangeState(lock: PasscodeLockType) {
                
                called = true
            }
        }
        
        let delegate = MockDelegate()
        let nextState = FakePasscodeState()
        
        passcodeLock.delegate = delegate
        passcodeLock.changeStateTo(nextState)
        
        XCTAssertEqual(delegate.called, true, "Should inform the delegate for state changes")
    }
    
    func testAddSign() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var called = false
            var signIndex = 0
            
            override func passcodeLock(lock: PasscodeLockType, addedSignAtIndex index: Int) {
                
                called = true
                signIndex = index
            }
        }
        
        let delegate = MockDelegate()
        
        passcodeLock.delegate = delegate
        passcodeLock.addSign("1")
        
        XCTAssertEqual(delegate.called, true, "Should inform the delegate for added sign at index")
        XCTAssertEqual(delegate.signIndex, 0, "Should return the added sign index")
        
        passcodeLock.addSign("2")
        
        XCTAssertEqual(delegate.signIndex, 1, "Should return the added sign index")
    }
    
    func testRemoveSign() {
        
        class MockDelegate: FakePasscodeLockDelegate {
            
            var called = false
            var signIndex = 0
            
            override func passcodeLock(lock: PasscodeLockType, removedSignAtIndex index: Int) {
                
                called = true
                signIndex = index
            }
        }
        
        let delegate = MockDelegate()
        
        passcodeLock.delegate = delegate
        passcodeLock.addSign("1")
        passcodeLock.addSign("2")
        
        passcodeLock.removeSign()
        
        XCTAssertEqual(delegate.called, true, "Should inform the delegate for removed sign at index")
        XCTAssertEqual(delegate.signIndex, 1, "Should return the removed sign index")
        
        passcodeLock.removeSign()
        XCTAssertEqual(delegate.signIndex, 0, "Should return the removed sign index")
    }
    
    func testCallStateToAcceptTheEnteredPasscode() {
        
        let passcode = ["0", "1", "2", "3"]
        
        for sign in passcode {
            
            passcodeLock.addSign(sign)
        }
        
        XCTAssertEqual(initialState.acceptPaccodeCalled, true, "When the passcode length is reached should call the current state to accept the entered passcode")
        XCTAssertEqual(initialState.acceptedPasscode, passcode, "Should return the entered passcode")
        XCTAssertEqual(initialState.numberOfAcceptedPasscodes, 1, "Should call the accept passcode only once")
    }
    
    func testResetSigns() {
        
        let passcodeOne = ["0", "1", "2", "3"]
        let passcodeTwo = ["9", "8", "7", "6"]
        
        for sign in passcodeOne {
            
            passcodeLock.addSign(sign)
        }
        
        for sign in passcodeTwo {
            
            passcodeLock.addSign(sign)
        }
        
        XCTAssertEqual(initialState.numberOfAcceptedPasscodes, 2, "Should call the accept passcode twice")
        XCTAssertEqual(initialState.acceptedPasscode, passcodeTwo, "Shpuld return the last entered passcode")
    }
}
