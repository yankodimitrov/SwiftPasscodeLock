//
//  PasscodeLockPresenter.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public class PasscodeLockPresenter {
    
    private var mainWindow: UIWindow?
    
    private lazy var passcodeLockWindow: UIWindow = {
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window.windowLevel = 0
        window.makeKeyAndVisible()
        
        return window
    }()
    
    private let passcodeConfiguration: PasscodeLockConfigurationType
    private var isPasscodePresented = false
    
    public init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType) {
        
        mainWindow = window
        mainWindow?.windowLevel = UIWindowLevelNormal
        passcodeConfiguration = configuration
    }
    
    public func presentPasscodeLock() {
        
        guard passcodeConfiguration.repository.hasPasscode else { return }
        guard !isPasscodePresented else { return }
        
        isPasscodePresented = true
		passcodeLockWindow.windowLevel = UIWindowLevelAlert
        
        let passcodeLockVC = PasscodeLockViewController(state: .EnterPasscode, configuration: passcodeConfiguration)
        
        passcodeLockVC.dismissCompletionCallback = { [weak self] in
            
            self?.dismissPasscodeLock()
        }
        
        passcodeLockWindow.rootViewController = passcodeLockVC
    }
    
    private func dismissPasscodeLock() {
        
        isPasscodePresented = false
        
        passcodeLockWindow.windowLevel = 0
        
        mainWindow?.windowLevel = UIWindowLevelNormal
        mainWindow?.makeKeyAndVisible()
    }
}
