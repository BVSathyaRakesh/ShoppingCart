//
//  UIImageView+Extension.swift
//  ShoppingCartMVVM
//
//  Created by Rakesh on 25/06/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString:String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
        
    }
    
}
