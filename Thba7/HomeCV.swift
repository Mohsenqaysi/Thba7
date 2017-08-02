//
//  HomeCV.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 7/31/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

struct DataModel {
    let image: String?
    let label: String?
}

struct Identifires {
    let orderPageVC: String = "orderPageVC.Identifier"
}
class HomeCV: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var buyButtoTag: Int?
    
    let loader: UIActivityIndicatorView = {
        let withd = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        //        let spinner = UIActivityIndicatorView(frame: CGRect(x: withd / 2, y: height / 2, width: 40, height: 40))
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.layer.cornerRadius = 3
        spinner.activityIndicatorViewStyle = .whiteLarge
        //        spinner.color = .red
        spinner.backgroundColor = UIColor.darkGray
        spinner.layer.opacity = 0.5
        return spinner
    }()
    
    var dataArray = [DataModel]()
    // Firebase Ref
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addSubview(loader)
        loader.center = view.center
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        // MARK:- Start Animating loder
        loader.startAnimating()
        // End
        ref = Database.database().reference()
        loadData()
        // Register cell classes
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func loadData()  {
        ref.child("data").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get values
            print("-----------------------------")
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                let image = restDict["image"] as? String
                let lablel = restDict["label"] as? String
                let model = DataModel(image: image, label: lablel)
                self.dataArray.append(model)
            }
            print("-----------------------------")
            self.loader.stopAnimating()
            self.collectionView?.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #wardataArraymplete implementation, return the number of items
        return dataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        // Configure the cell
        let imageName = dataArray[indexPath.item].image!
        print("dataArray[indexPath.item].image!: \(imageName)")
        if let url = URL.init(string: imageName) {
            print("URL: \(url)")
            cell.image.downloadedFrom(url: url)
        }
        cell.label.text = dataArray[indexPath.item].label!
        cell.buyButton.addTarget(self, action: #selector(moreToOderVC), for: .touchUpInside)
        cell.buyButton.tag = indexPath.item
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let index = indexPath.item
//        print(dataArray[index].label!)
////        self.performSegue(withIdentifier: "orderPageVC.Identifier" , sender: nil)
//    }
    
    func moreToOderVC(sender:UIButton) {
        print("MoreToOderVC")
        buyButtoTag = sender.tag
        self.performSegue(withIdentifier: "orderPageVC.Identifier" , sender: nil)
    }
    
    func getIndexPath(index: Int) -> Int {
        return index
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderPageVC.Identifier" {
            if let vc = segue.destination as? OrderPageVCViewController {
                vc.sheepOrderedImage = dataArray[buyButtoTag!].image!
                // Pass the title
                vc.title = "\(dataArray[buyButtoTag!].label!)"
            }
        }
    }
}
