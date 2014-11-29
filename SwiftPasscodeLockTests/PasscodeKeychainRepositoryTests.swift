//
//  PasscodeKeychainRepositoryTests.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/27/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class PasscodeKeychainRepositoryTests: XCTestCase {
    
    let passcode = ["1", "2", "3", "4"]
    var repository: PasscodeKeychainRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = PasscodeKeychainRepository()
    }
    
    override func tearDown() {
        super.tearDown()
        
        repository.deletePasscode()
    }
    
    func testThatWeCanSavePasscode() {
        
        let result = repository.savePasscode(passcode)
        
        XCTAssertTrue(result, "We should be able to save passcode")
    }
    
    func testThatWeCanUpdatePasscode() {
        
        repository.savePasscode(passcode)
        
        let result = repository.updatePasscode(passcode)
        
        XCTAssertTrue(result, "We should be able to update an exisitng passcode")
    }
    
    func testThatWillFailToUpdateANonExisitingPasscode() {
        
        let result = repository.updatePasscode(passcode)
        
        XCTAssertFalse(result, "Should fail to update a non existing passcode")
    }
    
    func testThatWeCanDeletePasscode() {
        
        repository.savePasscode(passcode)
        
        let result = repository.deletePasscode()
        
        XCTAssertTrue(result, "We should be able to delete an exisitng passcode")
    }
    
    func testThatWillFailToDeleteANonExistingPasscode() {
        
        let result = repository.deletePasscode()
        
        XCTAssertFalse(result, "Should fail to delete a non existing passcode")
    }
    
    func testThatWeCanGetPasscode() {
        
        repository.savePasscode(passcode)
        
        let pass = repository.getPasscode()
        
        XCTAssertEqual(pass, passcode, "We should be able to get the stored passcode")
    }
}
