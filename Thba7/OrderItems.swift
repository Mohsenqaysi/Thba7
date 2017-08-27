//
//  OrderItems.swift
//  NSKeyeDarchiverDemo
//
//  Created by Mohsen Qaysi on 8/27/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import Foundation


class OrderItems: NSObject, NSCoding  {
    
    // Keys for our items in the Orderitems struct
    struct OrderItems_Keys {
        static let productImage = "productImage.key"
        static let name = "name.key"
        static let size = "size.key"
        static let sizeIndex = "sizeIndex.key"
        static let cutTypee = "cutTypee.key"
        static let totalCost = "cost.key"
    }
    
    // out var's instinces
    private var _productImage = ""
    private var _name = ""
    private var _size = ""
    private var _sizeIndex = ""
    private var _cutTypee = ""
    private var _quantity = "1"
    private var _totalCost = "0"
    
    // Accessors
    var productImage: String {
        get {
            return _productImage
        }
        set {
            _productImage = newValue
        }
    }
    
    var name: String {
        get {
            return _name
        } set {
            _name = newValue
        }
    }
    
    var size: String {
        get {
            return _size
        } set {
            _size = newValue
        }
    }
    
    var sizeIndex: String {
        get {
            return _sizeIndex
        } set {
            _sizeIndex = newValue
        }
    }
    
    var cutTypee: String {
        get {
            return _cutTypee
        } set {
            _cutTypee = newValue
        }
    }
    
    var quantity: String {
        get {
            return _quantity
        } set {
            _quantity = newValue
        }
    }
    
    var totalCost: String {
        get {
            return _totalCost
        } set {
            _totalCost = newValue
        }
    }
    
    override init() {} // Empty constructor
    
    // init the instinces
    init(image: String, name: String,cost: String,size: String,indexSize: String, cutTypee: String,quantity: String, totalCost: String) {
       
        self._productImage = image
        self._name = name
        self._size = size
        self._sizeIndex = indexSize
        self._cutTypee = cutTypee
        self._quantity = quantity
        self._totalCost = totalCost
    }
    
    // code the data (Load them and decode them to a readable form
    required init?(coder aDecoder: NSCoder) {
       
        if let productImage = aDecoder.decodeObject(forKey: OrderItems_Keys.productImage) as? String {
            self._productImage = productImage
        }
        
        if let nameObject = aDecoder.decodeObject(forKey: OrderItems_Keys.name) as? String {
            self._name = nameObject
        }
        
        if let sizeObject = aDecoder.decodeObject(forKey: OrderItems_Keys.size) as? String {
            self._size = sizeObject
        }
        
        if let sizeIndexObject = aDecoder.decodeObject(forKey: OrderItems_Keys.sizeIndex) as? String {
            self._sizeIndex = sizeIndexObject
        }
        
        if let cutTypeeObject = aDecoder.decodeObject(forKey: OrderItems_Keys.cutTypee) as? String {
            self._cutTypee = cutTypeeObject
        }
        if let totalCostObject = aDecoder.decodeObject(forKey: OrderItems_Keys.totalCost) as? String {
            self._totalCost = totalCostObject
        }
    }
    
    // This encodes our objects (saves them)
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_productImage , forKey: OrderItems_Keys.productImage)
        aCoder.encode(_name, forKey: OrderItems_Keys.name)
        aCoder.encode(_size, forKey: OrderItems_Keys.size)
        aCoder.encode(_sizeIndex, forKey: OrderItems_Keys.sizeIndex)
        aCoder.encode(_cutTypee, forKey: OrderItems_Keys.cutTypee)
        aCoder.encode(_totalCost, forKey: OrderItems_Keys.totalCost)
 
    }
}
