//
//  UIColor.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 13/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

extension UIColor {

    open class var contentBgDark: UIColor {
        return UIColor(hex: "201E1E")
    }

    open class var primaryColor: UIColor {
        return UIColor(hex: "00F41E")
    }

    open class var secundaryColor: UIColor {
        return UIColor(hex: "0265b2")
    }

    open class var light1: UIColor {
        return UIColor(hex: "FFFFFF")
    }

    open class var light2: UIColor {
        return UIColor(hex: "FCFCFC")
    }

    open class var dark1: UIColor {
        return UIColor(hex: "201E1E")
    }

    open class var dark2: UIColor {
        return UIColor(hex: "595454")
    }

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
