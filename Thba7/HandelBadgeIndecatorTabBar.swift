//
//  HandelBadgeIndecatorTabBar.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class HandelBadgeIndecatorTabBar: NSObject {
    
    func UpdateBadge(tabBarControllerItems: NSArray, badgeCount: Int) {
        let tabItem = tabBarControllerItems[1] as! UITabBarItem
        // Now set the badge of the secons tab
        tabItem.badgeValue = "\(badgeCount)"
    }
    
}
