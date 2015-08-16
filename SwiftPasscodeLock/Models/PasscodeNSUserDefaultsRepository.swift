//
//  PasscodeNSUserDefaultsRepository.swift
//  SwiftPasscodeLock
//
//  Created by Nishinobu.Takahiro on 2015/08/16.
//  Copyright (c) 2015年 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class PasscodeNSUserDefaultsRepository: PasscodeRepository {
    
    public var hasPasscode: Bool {
        return getPasscode().count > 0
    }
    
    private let keyName = "swift.passcode.lock"
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    public func savePasscode(passcode: [String]) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(passcode, forKey: keyName)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func updatePasscode(passcode: [String]) -> Bool {
        return savePasscode(passcode)
    }
    
    public func deletePasscode() -> Bool {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(keyName)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func getPasscode() -> [String] {
        return NSUserDefaults.standardUserDefaults().objectForKey(keyName) as? [String] ?? [String]()
    }

}
