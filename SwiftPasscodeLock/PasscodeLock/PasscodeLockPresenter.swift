//
//  PasscodeLockPresenter.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/26/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit

public class PasscodeLockPresenter: NSObject {
    
    public weak var window: UIWindow?
    private let passcodeViewController: UIViewController
    private let passcodeRepository: PasscodeRepository
    private let splashView: UIView
    private var isPasscodePresented = false
    private var isApplicationActive = false
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    init(passcodeViewController: UIViewController, repository: PasscodeRepository, splashView: UIView) {
        
        assert(passcodeViewController is PasscodeLockPresentable, "Passcode VC should conform to PasscodeLockPresentable")
        
        self.passcodeViewController = passcodeViewController
        self.passcodeRepository = repository
        self.splashView = splashView
        
        super.init()
        
        if let presented = passcodeViewController as? PasscodeLockPresentable {
            
            presented.onCorrectPasscode = {
                
                self.dismissPasscodeLock()
            }
        }
        
        addEvents()
    }
    
    deinit {
        
        removeEvents()
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    private func addEvents() {
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(
            self,
            selector: Selector("applicationDidEnterBackground"),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil
        )
        
        center.addObserver(
            self,
            selector: Selector("applicationDidLaunched"),
            name: UIApplicationDidFinishLaunchingNotification,
            object: nil
        )
        
        center.addObserver(
            self,
            selector: Selector("applicationDidBecomeActive"),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        )
    }
    
    private func removeEvents() {
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.removeObserver(self)
    }
    
    func applicationDidEnterBackground() {
        
        addSplashView()
        presentPasscodeLock(splashViewAnimated: false)
    }
    
    func applicationDidLaunched() {
        
        addSplashView()
    }
    
    func applicationDidBecomeActive() {
        
        if isApplicationActive {
            
            return
        }
        
        isApplicationActive = true
        
        updateSplashViewFrame()
        presentPasscodeLock(splashViewAnimated: true)
    }
    
    private func shouldPresentPasscodeLock() -> Bool {
        
        if passcodeRepository.hasPasscode && !isPasscodePresented {
            
            return true
        }
        
        return false
    }
    
    private func findTopMostControllerInWindow(window: UIWindow?) -> UIViewController? {
        
        var topController: UIViewController?
        
        if let mainWindow = window {
            
            topController = mainWindow.rootViewController
        
            while topController?.presentedViewController != nil {
            
                topController = topController?.presentedViewController
            }
        }
        
        return topController
    }
    
    private func presentPasscodeLock(#splashViewAnimated: Bool) {
        
        if !shouldPresentPasscodeLock() {
            
            return
        }
        
        let topController = findTopMostControllerInWindow(window)
        
        if topController === passcodeViewController {
            
            assertionFailure("Trying to present passcode view controller on top of the same view controller")
            
            return
        }
        
        if splashViewAnimated {
            
            topController?.presentViewController(passcodeViewController, animated: false, completion: nil)
            
            animateSplashView({
                
                self.removeSplashView()
            })
            
        } else {
            
            topController?.presentViewController(passcodeViewController, animated: false, completion: {
                
                self.removeSplashView()
            })
        }
        
        isPasscodePresented = true
    }
    
    private func dismissPasscodeLock() {
        
        passcodeViewController.dismissViewControllerAnimated(true, completion: nil)
        
        self.isPasscodePresented = false
    }
    
    private func updateSplashViewFrame() {
        
        let screenBounds = UIScreen.mainScreen().bounds
        let device = UIDevice.currentDevice()
        
        splashView.frame = screenBounds
        
        if device.userInterfaceIdiom == .Phone && screenBounds.width > screenBounds.height {
            
            splashView.frame = CGRectMake(0, 0, screenBounds.height, screenBounds.width)
        }
    }
    
    private func addSplashView() {
        
        if !shouldPresentPasscodeLock() {
            
            return
        }
        
        updateSplashViewFrame()
        
        window?.addSubview(splashView)
    }
    
    private func removeSplashView() {
        
        splashView.removeFromSuperview()
    }
    
    private func animateSplashView(complete: () -> Void) {
        
        UIView.animateWithDuration(
            0.3,
            delay: 0.2,
            options: nil,
            animations: {
                
                self.splashView.alpha = 0
                
            }, completion: {
                finished in
                
                complete()
                self.splashView.alpha = 1
            }
        )
        
    }
}
