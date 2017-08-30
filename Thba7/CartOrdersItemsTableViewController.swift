//
//  CartOrdersItemsTableViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Spring


class CartOrdersItemsTableViewController: UITableViewController {
    let TAB_BAR_INDEX = 1
    
    let cellID = "CartCell"
    var store = DataStore.sharedInstnce
    
    let checkOutButton: SpringButton = {
        let bnt = SpringButton(type: .system)
        bnt.setTitle("أكمل عملية الشراء", for: .normal)
        bnt.setTitleColor(.white, for: .normal)
        bnt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        bnt.backgroundColor =  UIColor(red:0.25, green:0.79, blue:0.46, alpha:1.0)
//        bnt.isEnabled = false
        bnt.viewCardTheme()
        return bnt
    }()
    
    @IBOutlet var cartTableView: UITableView!
    
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
    
    func noItemsInCartView(_ customView: UIView) {
        print("Sorry no items on the cart")
        self.tableView.insertSubview(customView, aboveSubview: self.tableView)
        self.tableView.bringSubview(toFront: view)
        self.tableView.separatorStyle = .none
    }
    
    func ItemsInCartView(_ customView: UIView) {
        print("Items on the cart ... are loading")
        // Register cell classes
        customView.isHidden = true
        self.tableView.separatorStyle = .singleLine
        self.tableView.reloadData()
        self.setUpCheckOutButton()
    }
    
    func loadDate(){
        HandelBadgeIndecatorTabBar().Update(tabBar: self.tabBarController?.tabBar)
    }
    
    func setUpCheckOutButton(){
    self.navigationController?.view.addSubview(checkOutButton)
        guard let tabBarHeight = self.tabBarController?.tabBar.bounds.height.advanced(by: 12) else {
        debugPrint("Cannot get the height of the: tabBarHeight")
            return
        }
        print("tabBarHeight: ",tabBarHeight)
        let superView = navigationController?.view
       _ = checkOutButton.anchor(top: nil, left: superView?.leftAnchor, bottom: superView?.bottomAnchor, right: superView?.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: tabBarHeight, rightConstant: 12, widthConstant: 0, heightConstant: 42)
        
        checkOutButton.animation = "fadeInUp"
        //        checkOutButton.delay = 0.1
        checkOutButton.animate()
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
