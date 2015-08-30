//
//  FakePasscodeLockDelegate.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class FakePasscodeLockDelegate: PasscodeLockTypeDelegate {
    
    func passcodeLockDidSucceed(lock: PasscodeLockType) {}
    func passcodeLockDidFail(lock: PasscodeLockType) {}
    func passcodeLockDidChangeState(lock: PasscodeLockType) {}
    func passcodeLock(lock: PasscodeLockType, addedSignAtIndex index: Int) {}
    func passcodeLock(lock: PasscodeLockType, removedSignAtIndex index: Int) {}
}
