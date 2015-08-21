//
//  PasscodeLock.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/16/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

/// MARK: - PasscodeLock
public protocol PasscodeLock: class {
    
    var passcode: [String] {get}
    var state: PasscodeLockState? {get set}
    weak var delegate: PasscodeLockDelegate? {get set}
    
    func enterSign(sign: String)
    func removeSign()
    func resetSigns()
}

/// MARK: - PasscodeLockState
public protocol PasscodeLockState: class {
    
    var title: String {get}
    var description: String {get}
    weak var passcodeLock: PasscodeLock? {get set}
    weak var stateFactory: PasscodeLockStateFactory? {get set}
    
    func verifyPasscode()
}

/// MARK: - PasscodeLockStateFactory
public protocol PasscodeLockStateFactory: class {
    
    func makeEnterPasscodeState() -> PasscodeLockState
    func makeSetPasscodeState() -> PasscodeLockState
    func makeConfirmPasscodeState() -> PasscodeLockState
    func makePasscodesMismatchState() -> PasscodeLockState
    func makeChangePasscodeState() -> PasscodeLockState
}

/// MARK: - PasscodeLockDelegate
public protocol PasscodeLockDelegate: class {
    
    func passcodeLockDidSucceed(passcodeLock: PasscodeLock)
    func passcodeLockDidFailed(passcodeLock: PasscodeLock)
    func passcodeLockDidReset(passcodeLock: PasscodeLock)
    func passcodeLock(passcodeLock: PasscodeLock, changedToState state: PasscodeLockState)
    func passcodeLock(passcodeLock: PasscodeLock, addedSignAtIndex index: Int)
    func passcodeLock(passcodeLock: PasscodeLock, removedSignAtIndex index: Int)
}

/// MARK: - PasscodeRepository
public protocol PasscodeRepository: class {
    
    var hasPasscode: Bool {get}
    
    func savePasscode(passcode: [String]) -> Bool
    func updatePasscode(passcode: [String]) -> Bool
    func deletePasscode() -> Bool
    func getPasscode() -> [String]
}

/// MARK: - PasscodeLockPresentable
@objc public protocol PasscodeLockPresentable {
    
    var onCorrectPasscode: ( () -> Void )? {set get}
}
