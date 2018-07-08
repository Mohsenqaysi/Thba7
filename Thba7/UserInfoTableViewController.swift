//
//  UserInfoTableViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/18/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class UserInfoTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var store = DataStore.sharedInstnce

    var passedOrderData = [String]()
    var userPlacedOrder: [OrderItems] = []
    let cellID = "cell"
    let FinalCollectionViewCellID = "collectionViewCell"

    @IBOutlet var tableVC: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var firstNmae: UITextField!
    @IBOutlet weak var lastNmae: UITextField!
    @IBOutlet weak var finalOrderTableView: UITableView!
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var addressSection: UITableViewCell!
    @IBOutlet weak var userAddress: UITextView!
    @IBOutlet weak var confiremedUserPhoneNumberLabel: UILabel!
    @IBOutlet weak var confiremedUserPhoneNumberIcon: UIImageView!
    @IBOutlet weak var confiremedUserPhoneNumberButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameInputTextField.delegate = self
        self.cityTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        confiremedUserPhoneNumberLabel.isHidden = true
        confiremedUserPhoneNumberIcon.isHidden = true
        
        print("user order: \(userPlacedOrder)")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
        let nib = UINib(nibName: "FinalOrderCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: FinalCollectionViewCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mapButton.layer.cornerRadius = mapButton.frame.size.height / 2
        confiremedUserPhoneNumberButtom.viewCardTheme()
        tableView.viewCardTheme()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 260
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        print(collectionView.contentSize.height)
//        print(collectionView.frame.height * CGFloat(array.count))
    }
    
    @IBAction func unwindTo_UserInfoTableViewController_PhoneNumber(segue: UIStoryboardSegue) {
        confiremedUserPhoneNumberLabel.isHidden = false
        confiremedUserPhoneNumberIcon.isHidden = false
        
        if let userVerifedPhoneNumber = segue.source as? VerifySMSCodeViewController {
            self.confiremedUserPhoneNumberLabel.text = userVerifedPhoneNumber.number
            self.confiremedUserPhoneNumberButtom.isEnabled = false
            self.confiremedUserPhoneNumberButtom.layer.opacity = 0.5
            print(userVerifedPhoneNumber.number)
        }
    }
}

extension UserInfoTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.textColor = UIColor(hex: "6D6D6D")
        }
    }
}

extension UserInfoTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.store.shoppingItems.count
        print("Items in the array: ", count)
        return count //self.store.shoppingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectioCell = collectionView.dequeueReusableCell(withReuseIdentifier: FinalCollectionViewCellID, for: indexPath) as! FinalOrderCollectionViewCell
        let order = self.store.shoppingItems[indexPath.row]
        
        if let url = URL.init(string: order.productImage) {
            print("URL: \(url)")
            collectioCell.image.kf.indicatorType = .activity
            collectioCell.image.kf.setImage(with: url)
            collectioCell.image.viewCardThemeWithCornerRadius(radius: collectioCell.image.frame.size.height / 2)
        }
        
        collectioCell.label.text = order.name
//        collectioCell.orderCutTypeLabel.text = order.cutTypee
        return collectioCell
    }
}

