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

class OrderPageVCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var SheepImage: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var productInfoTBV: UITableView!
    
    var productInfo = [customCellData(name: "Arrow", image: #imageLiteral(resourceName: "arrow")),
                       customCellData(name: "Basket", image: #imageLiteral(resourceName: "basket")),
                       customCellData(name: "Menu", image: #imageLiteral(resourceName: "menuu"))]
//    ["الكمية","السعر","الدفع","العنوان"]
    let cellID = "CellID"
    var sheepOrderedImage: String = ""
    
    let button: UIButton = {
        let width = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 200)
        let bnt = UIButton(type: UIButtonType.system)
        bnt.setTitle("هذا مكاني", for: UIControlState.normal)
        bnt.titleLabel!.font =  UIFont.boldSystemFont(ofSize: 20)
        bnt.setTitleColor(UIColor.white, for: UIControlState.normal)
        bnt.backgroundColor = .red
        bnt.addTarget(self, action: #selector(handelCurrentLocation), for: .touchUpInside)
        bnt.viewCardTheme()
        return bnt
    }()
    
    func handelCurrentLocation() {
        print(123)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        productInfoTBV.viewCardTheme()
        productInfoTBV.isScrollEnabled = false
        loadData()
    }
    
    func loadData(){
        // MARK: Load the data inot the table view
        let url = URL(string: sheepOrderedImage)!
        SheepImage.kf.indicatorType = .activity
        SheepImage.kf.setImage(with: url)
        
        // set the height of the TBV
//        let rowHeight = productInfoTBV.rowHeight
//        let arraySize = CGFloat(productInfo.count)
//        productInfoTBV.contentSize = CGSize(width: 100, height: rowHeight * arraySize)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        backGroundView.viewCardTheme()
        let url = URL(string: sheepOrderedImage)!
        SheepImage.kf.indicatorType = .activity
        SheepImage.kf.setImage(with: url)
        productInfoTBV.tableFooterView = UIView.init(frame: CGRect.zero)
        productInfoTBV.tableHeaderView = UIView.init(frame: CGRect.zero)
    }
}

extension OrderPageVCViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productInfoTBV.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrderPageVCCell
        cell.textLabel?.text = productInfo[indexPath.item].name
        cell.imageView?.image = productInfo[indexPath.item].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = productInfoTBV.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrderPageVCCell

        if indexPath.row == 1 {
            StringPickerPopover(title: "أختر الحجم", choices: ["خروف لباني 650","خروف وسط 850","خروف كبير 1000"])
                .setSelectedRow(1)
                .setSize(width: 250.0, height: 200.0)
                .setDoneButton(action: { (popover, selectedRow, selectedString) in
                    print("done row \(selectedRow) \(selectedString)")
                    if indexPath.row == 1 {
                    cell.testLabel.text = selectedString
                    }
                })
                .setCancelButton(action: { v in print("cancel")
                    if indexPath.row == 1 {
                        cell.testLabel.text = ""
                    }
                })
                .appear(originView: cell, baseViewController: self)
        }
        self.productInfoTBV.reloadData()
    }
}
