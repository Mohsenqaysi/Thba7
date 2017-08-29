//
//  UserInfoTableViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/18/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class UserInfoTableViewController: UITableViewController {
    
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
    
    //    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        switch indexPath.section {
    //        case 0:
    //            return CGFloat(260)
    //        case 1:
    //            return CGFloat(130)
    //        case 2:
    //            return CGFloat(collectionView.frame.size.height * CGFloat(array.count))
    //        default:
    //            return CGFloat(44)
    //        }
    //    }
}

extension UserInfoTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPlacedOrder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectioCell = collectionView.dequeueReusableCell(withReuseIdentifier: FinalCollectionViewCellID, for: indexPath) as! FinalOrderCollectionViewCell
//        collectioCell.image.image = userPlacedOrder[indexPath.item].productImage
        collectioCell.label.text = userPlacedOrder[indexPath.item].name
        return collectioCell
    }
}

