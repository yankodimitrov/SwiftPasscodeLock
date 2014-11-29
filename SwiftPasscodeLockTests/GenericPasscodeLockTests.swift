//
//  GenericPasscodeLockTests.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/27/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class PasscodeLockStub: PasscodeLock {
    var passcode: [String] { return [String]() }
    var state: PasscodeLockState?
    weak var delegate: PasscodeLockDelegate?
    func enterSign(sign: String) {}
    func removeSign(){}
    func resetSigns(){}
    init(){}
}

class PasscodeLockDelegateStub: PasscodeLockDelegate {
    func passcodeLockDidSucceed(passcodeLock: PasscodeLock) {}
    func passcodeLockDidFailed(passcodeLock: PasscodeLock) {}
    func passcodeLockDidReset(passcodeLock: PasscodeLock) {}
    func passcodeLock(passcodeLock: PasscodeLock, changedToState state: PasscodeLockState) {}
    func passcodeLock(passcodeLock: PasscodeLock, addedSignAtIndex index: Int) {}
    func passcodeLock(passcodeLock: PasscodeLock, removedSignAtIndex index: Int) {}
}

class PasscodeLockStateStub: PasscodeLockState {
    var title = "title"
    var description = "description"
    weak var passcodeLock: PasscodeLock?
    weak var stateFactory: PasscodeLockStateFactory?
    func verifyPasscode() {}
    init() {}
}

class PasscodeRepositoryStub: PasscodeRepository {
    var hasPasscode = true
    func savePasscode(passcode: [String]) -> Bool { return false }
    func updatePasscode(passcode: [String]) -> Bool { return false }
    func deletePasscode() -> Bool { return false }
    func getPasscode() -> [String] { return [String]() }
}

class PasscodeLockStateFactoryStub: PasscodeLockStateFactory {
    
    func makeEnterPasscodeState() -> PasscodeLockState { return PasscodeLockStateStub() }
    func makeSetPasscodeState() -> PasscodeLockState { return PasscodeLockStateStub() }
    func makeConfirmPasscodeState() -> PasscodeLockState { return PasscodeLockStateStub() }
    func makePasscodesMismatchState() -> PasscodeLockState { return PasscodeLockStateStub() }
    func makeChangePasscodeState() -> PasscodeLockState { return PasscodeLockStateStub() }
}


class GenericPasscodeLockTests: XCTestCase {
    
    let repository = PasscodeRepositoryStub()
    let passcodeLength: UInt = 4
    var lock: PasscodeLock!
    var stateFactory: PasscodeLockStateFactory!
    
    override func setUp() {
        super.setUp()
        
        let passcodeLock = GenericPasscodeLock(length: passcodeLength, repository: repository)
        
        lock = passcodeLock
        stateFactory = passcodeLock
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Tests
    ///////////////////////////////////////////////////////
    
    func testThatWeCanMakeAnInstance() {
        
        let passcodeLength: UInt = 6
        let lock = GenericPasscodeLock(length: passcodeLength, repository: repository)
        
        XCTAssertEqual(lock.passcode.count, 0, "Passcode stack should be empty on PasscodeLock init")
    }
    
    func testThatWeCanEnterAPasscodeSign() {
        
        let sign = "a"
        
        lock.enterSign(sign)
        
        XCTAssertEqual(lock.passcode, [sign], "We should be able to enter a passcode sign")
    }
    
    func testThatDelegateIsCalledWhenWeEnterAPasscodeSign() {
        
        class LockDelegate: PasscodeLockDelegateStub {
            
            var signIndex: Int?
            
            override func passcodeLock(passcodeLock: PasscodeLock, addedSignAtIndex index: Int) {
                
                signIndex = index
            }
        }
        
        let lockDelegate = LockDelegate()
        
        lock.delegate = lockDelegate
        lock.enterSign("a")
        
        XCTAssertEqual(lockDelegate.signIndex!, 0, "Delegate method should be called when we enter a passcode sign")
    }
    
    func testThatWeCanRemoveAPasscodeSign() {
        
        let sign = "a"
        
        lock.enterSign(sign)
        lock.removeSign()
        
        XCTAssertEqual(lock.passcode.count, 0, "We should be able to remove a passcode sign")
    }
    
    func testThatDelegateIsCalledWhenWeRemoveAPasscodeSign() {
        
        class LockDelegate: PasscodeLockDelegateStub {
            
            var signIndex: Int?
            
            override func passcodeLock(passcodeLock: PasscodeLock, removedSignAtIndex index: Int) {
                
                signIndex = index
            }
        }
        
        let lockDelegate = LockDelegate()
        
        lock.delegate = lockDelegate
        lock.enterSign("a")
        lock.removeSign()
        
        XCTAssertEqual(lockDelegate.signIndex!, 0, "Delegate method should be called when we remove a passcode sign")
    }
    
    func testThatWeCanResetPasscodeSigns() {
        
        lock.enterSign("2")
        lock.enterSign("1")
        lock.resetSigns()
        
        XCTAssertEqual(lock.passcode.count, 0, "We should be able to reset the passcode signs")
    }
    
    func testThatDelegateIsCalledWhenPasscodeResets() {
        
        class LockDelegate: PasscodeLockDelegateStub {
            
            var didReset = false
            
            override func passcodeLockDidReset(passcodeLock: PasscodeLock) {
                
                didReset = true
            }
        }
        
        let lockDelegate = LockDelegate()
        
        lock.delegate = lockDelegate
        lock.enterSign("a")
        lock.enterSign("b")
        lock.resetSigns()
        
        XCTAssertEqual(lockDelegate.didReset, true, "Delegate method should be called when we reset the passcode signs")
    }
    
    func testThatDelegateIsCalledWhenPasscodeLockChangesItsState() {
        
        class LockDelegate: PasscodeLockDelegateStub {
            
            var changedState = false
            
            override func passcodeLock(passcodeLock: PasscodeLock, changedToState state: PasscodeLockState) {
                
                changedState = true
            }
        }
        
        let lockDelegate = LockDelegate()
        
        lock.delegate = lockDelegate
        lock.state = PasscodeLockStateStub()
        
        XCTAssertEqual(lockDelegate.changedState, true, "Delegate method should be called when PasscodeLock changes its state")
    }
    
    func testThatVerifyPasscodeIsCalledOnCurrentStateWhenWeEnterThePasscode() {
        
        class LockState: PasscodeLockStateStub {
            
            var didVrifyPasscode = false
            
            override func verifyPasscode() {
                
                didVrifyPasscode = true
            }
        }
        
        let mockState = LockState()
        
        lock.state = mockState
        
        for _ in 0..<Int(passcodeLength) {
            lock.enterSign("1")
        }
        
        XCTAssertEqual(mockState.didVrifyPasscode, true, "We should call the current state to verify the passcode")
    }
    
    func testThatWeCanMakeEnterPasscodeState() {
        
        let state = stateFactory.makeEnterPasscodeState()
        
        XCTAssertTrue(state is EnterPasscodeState, "We should be able to make an EnterPasscodeState isntance")
    }
    
    func testThatWeCanMakeSetPasscodeState() {
        
        let state = stateFactory.makeSetPasscodeState()
        
        XCTAssertTrue(state is SetPasscodeState, "We should be able to make an SetPasscodeState isntance")
    }
    
    func testThatWeCanMakeConfirmPasscodeState() {
        
        lock.enterSign("a")
        
        let state = stateFactory.makeConfirmPasscodeState()
        
        XCTAssertTrue(state is ConfirmPasscodeState, "We should be able to make an ConfirmPasscodeState isntance")
    }
    
    func testThatWeCanMakePasscodesMismatchState() {
        
        let state = stateFactory.makePasscodesMismatchState()
        
        XCTAssertTrue(state is PasscodesMismatchState, "We should be able to make an PasscodesMismatchState isntance")
    }
    
    func testThatWeCanMakeChangePasscodeState() {
        
        let state = stateFactory.makeChangePasscodeState()
        
        XCTAssertTrue(state is ChangePasscodeState, "We should be able to make an ChangePasscodeState isntance")
    }
}
