//
//  Order.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/7/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import Foundation

class Order: NSObject {
    var name: String?
    var size: String?
    var sizeIndex: Int?
    var cutTypee: String?
    var quantity: String? = "1"
    
    struct OrderInfo {
        let name: String?
        let size: String?
        let sizeIndex: Int?
        let cutTypee: String?
        let quantity: String?
    }
    
    func getOrderInfo() -> [OrderInfo]! {
        var array = [OrderInfo]()
        array.append(OrderInfo(name: name, size: size, sizeIndex: sizeIndex, cutTypee: cutTypee, quantity: quantity))
        return array
    }
}
