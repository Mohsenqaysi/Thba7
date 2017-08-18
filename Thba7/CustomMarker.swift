//
//  CustomMarker.swift
//  FixMarkerGoogleMaps
//
//  Created by Mohsen Qaysi on 8/7/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class CustomMarker: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let pin: UIImageView = {
        let p = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 45))
        p.image = UIImage(named: "default_marker")//?.withRenderingMode(.alwaysTemplate)
        p.tintColor = UIColor.blue
        return p
    }()
    
    func setUpView(){
        self.addSubview(pin)
        self.frame = pin.frame
    }
}
