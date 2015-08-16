//
//  PasscodeNSUserDefaultsRepositoryTests.swift
//  SwiftPasscodeLock
//
//  Created by Nishinobu.Takahiro on 2015/08/16.
//  Copyright (c) 2015年 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class PasscodeNSUserDefaultsRepositoryTests: XCTestCase {

    let passcode = ["1", "2", "3", "4"]
    let passcode2 = ["5", "6", "7", "8"]
    
    var repository: PasscodeNSUserDefaultsRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = PasscodeNSUserDefaultsRepository()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        repository.deletePasscode()
    }
    
    func testThatWeCanSavePasscode() {
        
        let result = repository.savePasscode(passcode)
        
        XCTAssertTrue(result, "We should be able to save passcode")
    }
    
    func testThatWeCanGetPasscode() {
        
        repository.savePasscode(passcode)
        
        let pass = repository.getPasscode()
        
        XCTAssertEqual(pass, passcode, "We should be able to get the stored passcode")
    }
    
    func testThatWeCanUpdatePasscode() {
        
        repository.savePasscode(passcode)
        
        let result = repository.updatePasscode(passcode2)
        
        let pass = repository.getPasscode()
        
        XCTAssertEqual(pass, passcode2, "We should be able to update an exisitng passcode")
    }
    
    func testThatWeCanDeletePasscode() {
        
        repository.savePasscode(passcode)
        
        let result = repository.deletePasscode()
        
        let pass = repository.getPasscode()
        
        XCTAssertEqual(pass, [String](), "We should be able to delete an exisitng passcode")
    }
    
    
}
