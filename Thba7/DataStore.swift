//
//  DataStore.swift
//  NSKeyeDarchiverDemo
//
//  Created by Mohsen Qaysi on 8/27/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import Foundation

class DataStore {
    static let sharedInstnce = DataStore()
    private init(){}
    var shoppingItems = [OrderItems]()
}
