//
//  Extension.swift
//  Mobiletest
//
//  Created by Faridullah on 8/26/18.
//  Copyright © 2018 Faridullah. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func loadImageWith(imgUrl:URL?, placeHolder:UIImage?) {
        let imgPlaceHolder = (placeHolder != nil) ? placeHolder! : UIImage(named: "bitmap")
        self.kf.indicatorType = .activity
        //[.transition(ImageTransition.fade(0.5)), .forceTransition]
        self.kf.setImage(with: imgUrl, placeholder: imgPlaceHolder, options: nil, progressBlock: { (progress, total) in
            //
        }, completionHandler: { (image, error, cache, url) in
            //
        })
    }
}
