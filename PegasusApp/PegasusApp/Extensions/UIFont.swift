//
//  UIFont.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 13/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

extension UIFont {

    open class func bold(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .heavy)
    }

    open class func semiBold(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .semibold)
    }

    open class func regular(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }

    open class func light(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .light)
    }

}
