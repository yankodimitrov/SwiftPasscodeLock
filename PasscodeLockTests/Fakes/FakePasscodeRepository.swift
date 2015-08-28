//
//  FakePasscodeRepository.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class FakePasscodeRepository: PasscodeRepositoryType {
    
    var hasPasscode: Bool { return true }
    var passcode: [String]? { return fakePasscode }
    
    var fakePasscode = ["1", "2", "3", "4"]
    
    var savePasscodeCalled = false
    var savedPasscode = [String]()
    
    func savePasscode(passcode: [String]) {
        
        savePasscodeCalled = true
        savedPasscode = passcode
    }
    
    func deletePasscode() {
        
    }
}
