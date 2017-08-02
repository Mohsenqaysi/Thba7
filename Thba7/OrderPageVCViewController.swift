//
//  OrderPageVCViewController.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/2/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class OrderPageVCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var SheepImage: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var orderTableView: UITableView!

    var productInfo = ["الكمية","السعر","الدفع","العنوان"]
    let CellID = "CellID"
    var sheepOrderedImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sheepOrderedImage)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        backGroundView.viewCardTheme()
        SheepImage.downloadedFrom(link: sheepOrderedImage)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! OrderPageVCCell
        cell.testLabel.text = productInfo[indexPath.row]
        return cell
    }
}
