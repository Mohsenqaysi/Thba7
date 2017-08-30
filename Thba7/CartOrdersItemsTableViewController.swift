//
//  CartOrdersItemsTableViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class CartOrdersItemsTableViewController: UITableViewController {
    let TAB_BAR_INDEX = 1
    
    let cellID = "CartCell"
    var store = DataStore.sharedInstnce
    
    @IBOutlet var cartTableView: UITableView!
    var cartOrderItems  = ["Hi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad... is loaded: CartOrdersItemsTableViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear: CartOrdersItemsTableViewController ... is loaded")
        self.loadDate() // try to load data from user device
        let flag = store.shoppingItems.isEmpty
        
        if flag {
            checkForCartItems(flag: flag)
        } else {
            checkForCartItems(flag: flag)
        }
    }
    
    
    
    func checkForCartItems(flag: Bool) {
        let noItemsView = NoOrderItemsOnTheCart(frame: self.tableView.frame)
        switch flag {
        case true:
            self.noItemsInCartView(noItemsView)
        case false:
            self.ItemsInCartView(noItemsView)
        }
    }
    
    func noItemsInCartView(_ view: UIView) {
        print("Sorry no items on the cart")
        self.tableView.insertSubview(view, aboveSubview: self.tableView)
        self.tableView.bringSubview(toFront: view)
        self.tableView.separatorStyle = .none
    }
    
    func ItemsInCartView(_ view: UIView) {
        print("Items on the cart ... are loading")
        // Register cell classes
        self.tableView.separatorStyle = .singleLine
        self.tableView.reloadData()
    }
    
    func loadDate(){
        HandelBadgeIndecatorTabBar().Update(tabBar: self.tabBarController?.tabBar)
    }
}

extension CartOrdersItemsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.store.shoppingItems.count
        print("Items in the array: ", count)
        return count //self.store.shoppingItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CartOrdersItemsCell
        let order = self.store.shoppingItems[indexPath.row]

        if let url = URL.init(string: order.productImage) {
            print("URL: \(url)")
            cell.orderImage.kf.indicatorType = .activity
            cell.orderImage.kf.setImage(with: url)
            cell.orderImage.viewCardThemeWithCornerRadius(radius: cell.orderImage.frame.size.height / 2)
        }

        cell.orderNameLabel.text = order.name
        cell.orderCutTypeLabel.text = order.cutTypee
        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(150)
//    }
    
}
