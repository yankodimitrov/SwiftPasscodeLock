//
//  KeychainService.swift
//  SwiftKeychain
//
//  Created by Yanko Dimitrov on 11/11/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol KeychainService {
    
    var accessMode: String {get}
    var serviceName: String {get}
    var accessGroup: String? {get set}
    
    func add(key: KeychainItem) -> NSError?
    func update(key: KeychainItem) -> NSError?
    func remove(key: KeychainItem) -> NSError?
    func get<T: BaseKey>(key: T) -> (item: T?, error: NSError?)
}
