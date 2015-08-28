//
//  EnterPasscodeStateTests.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class NotificaionObserver: NSObject {
    
    var called = false
    var callCounter = 0
    
    func observe(notification: String) {
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self, selector: "handle:", name: notification, object: nil)
    }
    
    func handle(notification: NSNotification) {
        
        called = true
        callCounter += 1
    }
}

class EnterPasscodeStateTests: XCTestCase {
    
    var passcodeLock: FakePasscodeLock!
    var passcodeState: EnterPasscodeState!
    var repository: FakePasscodeRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = FakePasscodeRepository()
        
        let config = FakePasscodeLockConfiguration(repository: repository)
        
        passcodeState = EnterPasscodeState()
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
        passcodeState.acceptPasscode(repository.fakePasscode, fromLock: passcodeLock)
        
        XCTAssertEqual(delegate.called, true, "Should call the delegate when the passcode is correct")
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
    
    func testIncorrectPasscodeNotification() {
        
        let observer = NotificaionObserver()
        
        observer.observe(PasscodeLockIncorrectPasscodeNotification)
        
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        
        XCTAssertEqual(observer.called, true, "Should send a notificaiton when the maximum number of incorrect attempts is reached")
    }
    
    func testIncorrectPasscodeSendNotificationOnce() {
        
        let observer = NotificaionObserver()
        
        observer.observe(PasscodeLockIncorrectPasscodeNotification)
        
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)
        passcodeState.acceptPasscode(["0"], fromLock: passcodeLock)

        XCTAssertEqual(observer.callCounter, 1, "Should send the notification only once")
    }
}
