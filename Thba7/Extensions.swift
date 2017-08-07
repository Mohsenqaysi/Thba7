//
//  Extensions.swift
//  Youtube
//
//  Created by Mohsen Qaysi on 5/27/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration


extension CGFloat {
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIView {
    func addConstrantsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIView {
    func viewCardTheme() {
        // MARK: - CardView Layout
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
    }
}

extension UIView {
    func viewCardThemeWithCornerRadius(radius: CGFloat) {
        // MARK: - CardView Layout
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
    }
}
extension UIView {
    
    func anchorToTop(_
        top: NSLayoutYAxisAnchor? = nil,
                     left: NSLayoutXAxisAnchor? = nil,
                     bottom: NSLayoutYAxisAnchor? = nil,
                     right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(
            top,
            left: left,
            bottom: bottom,
            right: right,
            
            topConstant: 0,
            leftConstant: 0,
            bottomConstant: 0,
            rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil,
                                  left: NSLayoutXAxisAnchor? = nil,
                                  bottom: NSLayoutYAxisAnchor? = nil,
                                  right: NSLayoutXAxisAnchor? = nil,
                                  topConstant: CGFloat = 0,
                                  leftConstant: CGFloat = 0,
                                  bottomConstant: CGFloat = 0,
                                  rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_
        top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                topConstant: CGFloat = 0,
                leftConstant: CGFloat = 0,
                bottomConstant: CGFloat = 0,
                rightConstant: CGFloat = 0,
                widthConstant: CGFloat = 0,
                heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // Very importnat
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        // Apply it to all of them "forEach"
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
}

extension Bool {
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}
