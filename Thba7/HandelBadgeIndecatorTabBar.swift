//
//  HandelBadgeIndecatorTabBar.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class HandelBadgeIndecatorTabBar: NSObject {
    var store = DataStore.sharedInstnce
    
    func Update(tabBar: UITabBar? ) {
        
        if let userOrders = NSKeyedUnarchiver.unarchiveObject(withFile: String().filePath)
            as? [OrderItems] {
            self.store.shoppingItems = userOrders
            guard let tabItems = tabBar?.items as NSArray! else {return}
            let tabItem = tabItems[1] as! UITabBarItem
            // Now set the badge of the secons tab
            let badgeCount = self.store.shoppingItems.count
            tabItem.badgeValue = "\(badgeCount)"
        }
    }
}
