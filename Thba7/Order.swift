//
//  Order.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/7/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import Foundation
import UIKit

class Order: NSObject {
    
    override init() {
        super.init()
    }
    
//    init(image: UIImage) {
//        self.productImage = image
//    }
    
    var productImage: UIImage!
    var name: String?
    var size: String?
    var sizeIndex: Int?
    var cutTypee: String?
    var quantity: String? = "1"
    var totalCost: Int? = 0
    
    struct OrderInfo {
        let productImage: UIImage!
        let name: String?
        let size: String?
        let sizeIndex: Int?
        let cutTypee: String?
        let quantity: String?
        let totalCost: Int?
    }
    
    func getOrderInfo() -> [OrderInfo]! {
        var array = [OrderInfo]()
        array.append(OrderInfo(productImage: productImage, name: name, size: size, sizeIndex: sizeIndex, cutTypee: cutTypee, quantity: quantity, totalCost: totalCost))
        return array
    }
}
