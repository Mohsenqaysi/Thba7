//
//  HomeCV.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 7/31/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

private let reuseIdentifier = "Cell"
private let noConnectionColor: UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
private let withd = UIScreen.main.bounds.width
private let height = UIScreen.main.bounds.height

struct DataModel {
    let image: String?
    let label: String?
}

struct Identifires {
    let orderPageVC: String = "orderPageVC.Identifier"
}

class HomeCV: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var buyButtoTag: Int?
    
    let loderStatusLabel: UILabel = {
        let lb = UILabel() //frame: CGRect(x: 0, y: 0, width: withd/3, height: 100))
        lb.text = "جاري التحميل..."
        lb.textAlignment = .center
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    let loader: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()//frame: CGRect(x: 0, y: 0, width: withd/3, height: 400))
        spinner.layer.cornerRadius = 3
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.backgroundColor = UIColor.darkGray
        spinner.layer.opacity = 0.9
        return spinner
    }()
    
    var dataArray = [DataModel]()
    // Firebase Ref
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMainView()
    }
    
    func loadMainView(){
        
        if Bool().isInternetAvailable() {
            collectionView?.addSubview(loader)
            view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
            // MARK:- Start Animating loder
            loader.startAnimating()
            // End
            // MARK: add loderStatusLabel to the Loder indecator
            loader.insertSubview(loderStatusLabel, aboveSubview: loader)
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            // add constraint to loderStatusLabel
            _ = loader.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: height/4, leftConstant: withd/4, bottomConstant: height/4, rightConstant: withd/4, widthConstant: 150, heightConstant: 80)
            
            _ = loderStatusLabel.anchor(nil, left: loader.leftAnchor, bottom: loader.bottomAnchor, right: loader.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
            ref = Database.database().reference()
            //MARK:- Load the data into the collectionTable
            loadData()
            
            // Register cell classes
            let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
            self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            loader.stopAnimating()
            print("Sorry no internet connection")
            let noView = NoInternetConnectVC(frame: view.frame)
            view.addSubview(noView)
        }
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

    func moreToOderVC(sender:UIButton) {
        print("MoreToOderVC")
        buyButtoTag = sender.tag
        self.performSegue(withIdentifier: "orderPageVC.Identifier" , sender: nil)
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

extension HomeCV {
    
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
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: url)
        }
        
        cell.label.text = dataArray[indexPath.item].label!
        cell.buyButton.addTarget(self, action: #selector(moreToOderVC), for: .touchUpInside)
        cell.buyButton.tag = indexPath.item
        return cell
    }
}
