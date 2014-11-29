//
//  ViewController.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/16/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let passcodeRepository: PasscodeRepository
    private let passcodeLock: GenericPasscodeLock
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var changePasscodeButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        
        passcodeRepository = PasscodeKeychainRepository()
        passcodeLock = GenericPasscodeLock(repository: passcodeRepository)
        
        super.init(coder: aDecoder)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - View
    ///////////////////////////////////////////////////////
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    private func updateView() {
        
        if passcodeRepository.hasPasscode {
            
            passcodeSwitch.on = true
            changePasscodeButton.hidden = false
            
        } else {
            
            passcodeSwitch.on = false
            changePasscodeButton.hidden = true
        }
    }
    
    private func presentPasscode(#onCorrectPasscode: (controller: UIViewController)->Void) {
        
        let controller = PasscodeViewController(passcodeLock: passcodeLock)
            controller.onCorrectPasscode = {
                
                onCorrectPasscode(controller: controller)
            }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func passcodeSwitchChangeState(sender: UISwitch) {
    
        if sender.on == true {
            
            passcodeLock.state = passcodeLock.makeSetPasscodeState()
            
            presentPasscode(onCorrectPasscode: {
                controller in
                
                controller.dismissViewControllerAnimated(true, completion: nil)
            })
            
        } else {
            
            passcodeLock.state = passcodeLock.makeEnterPasscodeState()
            
            presentPasscode(onCorrectPasscode: {
                controller in
                
                self.passcodeRepository.deletePasscode()
                controller.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    @IBAction func changePasscodeTap(sender: UIButton) {
        
        passcodeLock.state = passcodeLock.makeChangePasscodeState()
        
        presentPasscode(onCorrectPasscode: {
            controller in
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}

