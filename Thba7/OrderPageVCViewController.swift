//
//  OrderPageVCViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/2/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

//MARK:- Cell Model
struct customCellData {
    let name: String?
    let image: UIImage?
}

private struct Identifiers {
    static let cellID: String = "CellID"
    static let segueUserInfoPageVCIdentifier: String = "segueUserInfoPageVC.ientifier"
}


class OrderPageVCViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var SheepImage: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var productInfoTBV: UICollectionView!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var viewUnderBuyButton: UIView!
    
    
    //MARK: Order instans
    var userOrder = Order()
    var sheepsSizes = [String]()
    var sheepSizeCost = [String]()
    var sheepCuts = [String]()

    
    var sheepOrderedImage: String = ""
    var animaleName: String = ""
    var animleImage: AnyObject?
    
    var productInfo = [customCellData(name: "الحجم", image: #imageLiteral(resourceName: "iconSheep")),
                       customCellData(name: "التقطيع", image: #imageLiteral(resourceName: "cut")),
                       customCellData(name: "الكمية", image: #imageLiteral(resourceName: "quantity"))]
    
    var choosesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the sheep name
        self.userOrder.name = animaleName
        productInfoTBV.delegate = self
        productInfoTBV.viewCardTheme()
        buyNowButton.viewCardThemeWithCornerRadius(radius: 0)
        viewUnderBuyButton.viewCardTheme()
        buyNowButton.backgroundColor = UIColor(red:0.25, green:0.79, blue:0.46, alpha:1.0)
        productInfoTBV.isScrollEnabled = false
        loadData()
        buyNowButton.addTarget(self, action: #selector(handelBuyButton), for: .touchUpInside)
    }
    // MARK: Segue to the userInfo VC
    func handelBuyButton(){
        if !choosesArray.isEmpty {
            if let info = userOrder.getOrderInfo() {
                print(info)
            }
        } else {
            print("Place fill in the form fully")
        }
    }
    
    // MARK: Perper for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.segueUserInfoPageVCIdentifier {
            if let vc = segue.destination as? UserInfoTableViewController {
                let backItem = UIBarButtonItem()
                backItem.title = "رجوع"
                navigationItem.backBarButtonItem = backItem
                // Pass the title
                vc.title = "معلومات التوصيل"
//                vc.passedOrderData = choosesArray
                vc.userPlacedOrder = userOrder.getOrderInfo()
            }
        }
    }
    func loadData(){
        // MARK: Load the data inot the table view
        let url = URL(string: sheepOrderedImage)!
        SheepImage.kf.setImage(with: url)
        self.userOrder.productImage = SheepImage.image

        
        // Set the height of the TBV
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        choosesArray.removeAll()
        enbaleBuyButton()
        backGroundView.viewCardTheme()
        let url = URL(string: sheepOrderedImage)!
        SheepImage.kf.indicatorType = .activity
        SheepImage.kf.setImage(with: url)
        self.enbaleBuyButton()
    }
}

extension OrderPageVCViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productInfoTBV.dequeueReusableCell(withReuseIdentifier: Identifiers.cellID, for: indexPath) as! OrderPageVCCell
        cell.icon.image = productInfo[indexPath.item].image
        cell.iconLabel.text = productInfo[indexPath.item].name
        return cell
    }
    
    
    // MARK: The user chooses for the order
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.productInfoTBV.cellForItem(at: indexPath) as! OrderPageVCCell
        
        if indexPath.row == 0 {
            StringPickerPopover(title: "أختر الحجم", choices: sheepsSizes)
                .setSize(width: 250.0, height: 150.0)
                .setSelectedRow(0)
                .setDoneButton(action: { (popover, selectedRow, selectedString) in
                    self.setUpLabelAndAddToarray(cell: cell, indexPath: indexPath, selectedString: selectedString)
                    self.userOrder.size = selectedString
                    self.userOrder.sizeIndex = selectedRow
                })
                .setCancelButton(action: { v in print("cancel")
                    cell.userChoose?.text = ""
                    self.removeChoses(index: indexPath.row)
                })
                .appear(originView: cell, baseViewController: self)
        }
        
        if indexPath.row == 1 {
            StringPickerPopover(title: "أختر التقطيع", choices: sheepCuts)
                .setSize(width: 250.0, height: 150.0)
                .setSelectedRow(0)
                .setDoneButton(action: { (popover, selectedRow, selectedString) in
                    self.setUpLabelAndAddToarray(cell: cell, indexPath: indexPath, selectedString: selectedString)
                    self.userOrder.cutTypee = selectedString
                })
                .setCancelButton(action: { v in print("cancel")
                    cell.userChoose?.text = ""
                    self.removeChoses(index: indexPath.row)
                })
                .appear(originView: cell, baseViewController: self)
        }
        
        if indexPath.row == 2 {
            StringPickerPopover(title: "أختر الكمية", choices: ["1","2","3","4","5","6","7","8","9","10"])
                .setSize(width: 250.0, height: 150.0)
                .setSelectedRow(0)
                .setDoneButton(action: { (popover, selectedRow, selectedString) in
                    self.setUpLabelAndAddToarray(cell: cell, indexPath: indexPath, selectedString: selectedString)
                    self.userOrder.quantity = selectedString
                    self.setTheCostLabel()
                    cell.userChoose?.text = selectedString
                })
                .setCancelButton(action: { v in print("cancel")
                    cell.userChoose?.text = ""
                    self.removeChoses(index: indexPath.row)
                })
                .appear(originView: cell, baseViewController: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setUpLabelAndAddToarray(cell: OrderPageVCCell,indexPath: IndexPath, selectedString: String){
        if self.choosesArray.count == 3 {
            self.choosesArray[indexPath.row] = selectedString
            cell.userChoose.text = selectedString
        } else {
            cell.userChoose.text = selectedString
            self.choosesArray.append(selectedString)
            self.enbaleBuyButton()
        }
    }
    
    //MARK: enable the buy button
    func enbaleBuyButton() {
        if choosesArray.count == 3 {
            buyNowButton.isEnabled = true
            buyNowButton.layer.opacity = 1.0
            //            viewUnderBuyButton.layer.opacity = 1.0
            print(choosesArray)
        } else {
            buyNowButton.isEnabled = false
            buyNowButton.layer.opacity = 0.5
            //            viewUnderBuyButton.layer.opacity = 0.5
            print(choosesArray)
        }
    }
    
    func setTheCostLabel() {
        guard let index = userOrder.sizeIndex, userOrder.sizeIndex != nil else {
            return
        }
        guard let cost = Int(sheepSizeCost[index]) else {
            print("error... no data")
            return
        }
        guard let quantity =  Int(self.userOrder.quantity!), Int(self.userOrder.quantity!) != nil else {
            return
        }
        
        print(index)

        switch index {
        case 0..<10:
            let totalCost = Int(quantity * cost)
            userOrder.totalCost = totalCost
            self.totalCostLabel.text = "\(totalCost) ريال"
        default:
            self.totalCostLabel.text = ""
        }
    }
    
    func removeChoses(index: Int){
        if !choosesArray.isEmpty {
            self.choosesArray.remove(at: index)
        } else {
            choosesArray = [String]()
        }
        self.enbaleBuyButton()
    }
}
