//
//  CartOrdersItemsTableViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Spring

var Order = OrderPageViewController()

class CartOrdersItemsTableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var emptyShopingCartView: UIView!
    
    let name = NSNotification.Name("Notification.name")
    
    let cellID = "CartCell"
    
    struct CartOrderIdentifiers {
        static let cellID = "CartCell"
        static let segueID = "show_UserInfo_ID"
    }
    
    var store = DataStore.sharedInstnce
    
    let checkOutButton: SpringButton = {
        let bnt = SpringButton(type: .system)
        bnt.setTitle("أكمل عملية الشراء", for: .normal)
        bnt.setTitleColor(.white, for: .normal)
        bnt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        bnt.backgroundColor =  UIColor(red:0.25, green:0.79, blue:0.46, alpha:1.0)
        //        bnt.isEnabled = false
        //        bnt.addTarget(self, action: #selector(handelCheckOutButton), for: .touchUpInside)
        bnt.viewCardTheme()
        return bnt
    }()
    
    func handelCheckOutButton() {
        print(123)
        performSegue(withIdentifier: CartOrderIdentifiers.segueID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == CartOrderIdentifiers.segueID {
            //            if let vc = segue.destination as! UserInfoTableViewController {
            //                checkOutButton.isHidden = true
            checkOutButton.removeFromSuperview()
            //            }
        }
    }
    
    @IBOutlet var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkOutButton.addTarget(self, action: #selector(handelCheckOutButton), for: .touchUpInside)
        
        // hide the tableView by default
        self.tableView.isHidden = true
        
        // add the emptyShopingCartView to the main view as a subview
        emptyShopingCartView = NoOrderItemsOnTheCart(frame: view.frame)
        self.view.addSubview(emptyShopingCartView)
        //        checkDataAndLoadthem()
        
        print("viewDidLoad... is loaded: CartOrdersItemsTableViewController")
        NotificationCenter.default.addObserver(self, selector: #selector(CartOrdersItemsTableViewController.methodOfReceivedNotification(notification:)), name: name, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkDataAndLoadthem()
    }
    
    //MARK: Notification observor call
    func methodOfReceivedNotification(notification: Notification){
        print("methodOfReceivedNotification... I was called")
        //                checkDataAndLoadthem()
        //                loadDate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        print("methodOfReceivedNotification... I was deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear: CartOrdersItemsTableViewController ... is loaded")
        //        checkOutButton.isHidden = false
        self.loadDate() // try to load data from user device
        checkDataAndLoadthem()
    }
    
    func checkDataAndLoadthem() {
        
        let flag = store.shoppingItems.isEmpty
        print("flag: ",flag)
        if flag {
            noItemsInShoppingCartView(emptyShopingCartView!)
        } else {
            self.loadItemsInCartView(emptyShopingCartView!)
        }
    }
    
    func noItemsInShoppingCartView(_ customView: UIView) {
        print("Sorry no items on the cart")
        //        self.view.addSubview(customView)
    }
    
    func loadItemsInCartView(_ customView: UIView) {
        print("Items on the cart ... are loading")
        customView.isHidden = true
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.checkOutButton.isHidden = false
            self.tableView.reloadData()
            self.setUpCheckOutButton()
        }
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
        
        //MARK: animation
        //        checkOutButton.animation = "fadeInUp"
        //        checkOutButton.delay = 0.1
        //        checkOutButton.animate()
    }
}

extension CartOrdersItemsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.store.shoppingItems.count
        print("Items in the array: ", count)
        return count //self.store.shoppingItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartOrderIdentifiers.cellID, for: indexPath) as! CartOrdersItemsCell
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
    
}
