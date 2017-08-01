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
class HomeCV: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var dataArray = [DataModel]()
    // Firebase Ref
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        ref = Database.database().reference()
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
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Register cell classes
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
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
        
        // MARK: - CardView Layout
//        cell.layer.cornerRadius = 15.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.layer.shadowOpacity = 0.8
        return cell
    }
    
}
