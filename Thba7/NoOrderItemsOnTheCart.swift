//
//  NoOrderItemsOnTheCart.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/29/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit

class NoOrderItemsOnTheCart: UIView {
    
    private let noConnectionColor: UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpNoConnectionViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var noConnnectionBlankView: UIView = {
        let blankView = UIView()
        blankView.frame = self.frame
        blankView.backgroundColor = self.noConnectionColor
        return blankView
    }()
    let noItemsInCartImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "empty_cart") //#imageLiteral(resourceName: "empty_cart"))
        return image
    }()
    
    let noConnnectionBText: UITextField = {
        let text = UITextField()
        text.isEnabled = false
        text.text = "عفوا لا يوجد لديك طلبات حالياً" //"Sorry No Connection"
        text.font = UIFont.boldSystemFont(ofSize: 24)
        text.textAlignment = .center
        text.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        return text
    }()
    
    func setUpNoConnectionViews() {
        addSubview(noConnnectionBlankView)
        noConnnectionBlankView.addSubview(noItemsInCartImageView)
        noConnnectionBlankView.addSubview(noConnnectionBText)
        
        let height = UIScreen.main.bounds.size.height / 3
        noItemsInCartImageView.anchorWithConstantsToTop(noConnnectionBlankView.topAnchor, left: noConnnectionBlankView.leftAnchor, bottom: nil, right: noConnnectionBlankView.rightAnchor, topConstant: height, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        noConnnectionBText.anchorWithConstantsToTop(noItemsInCartImageView.bottomAnchor, left: noConnnectionBlankView.leftAnchor, bottom: nil, right: noConnnectionBlankView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
    }
}
