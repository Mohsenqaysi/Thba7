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
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.layer.cornerRadius = 3
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.backgroundColor = UIColor.darkGray
        spinner.layer.opacity = 0.5
        return spinner
    }()
    
    var dataArray = [DataModel]()
    // Firebase Ref
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Bool().isInternetAvailable() {
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
        } else {
            loader.stopAnimating()
            print("Sorry no internet connection")
            setUpNoConnectionViews()
        }
    }
    
    lazy var noConnnectionBlankView: UIView = {
        let blankView = UIView()
        blankView.frame = self.view.frame
        blankView.backgroundColor = noConnectionColor
        return blankView
    }()
    let noConnnectionImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "noConnection")
        return image
    }()
    
    let noConnnectionBText: UITextField = {
        let text = UITextField()
        text.isEnabled = false
        text.text = "Sorry No Connection"
        text.font = UIFont.boldSystemFont(ofSize: 24)
        text.textAlignment = .center
        text.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        return text
    }()
    
    func setUpNoConnectionViews() {
        view.addSubview(noConnnectionBlankView)
        noConnnectionBlankView.addSubview(noConnnectionImageView)
        noConnnectionBlankView.addSubview(noConnnectionBText)
        
        let height = UIScreen.main.bounds.size.height / 3
        noConnnectionImageView.anchorWithConstantsToTop(noConnnectionBlankView.topAnchor, left: noConnnectionBlankView.leftAnchor, bottom: nil, right: noConnnectionBlankView.rightAnchor, topConstant: height, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        noConnnectionBText.anchorWithConstantsToTop(noConnnectionImageView.bottomAnchor, left: noConnnectionBlankView.leftAnchor, bottom: nil, right: noConnnectionBlankView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
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
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: url)
            
            //            let resource = ImageResource(downloadURL: url, cacheKey: "my_cache_key")
            //            cell.image.kf.setImage(with: resource)
            
        }
        
        cell.label.text = dataArray[indexPath.item].label!
        cell.buyButton.addTarget(self, action: #selector(moreToOderVC), for: .touchUpInside)
        cell.buyButton.tag = indexPath.item
        return cell
    }
    
    
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
