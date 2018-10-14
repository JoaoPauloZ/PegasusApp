//
//  UIColor.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 13/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

// http://paletton.com/#uid=72Q0I0krB++aJ+qkb+SIP+MWD-3

extension UIColor {

    open class var contentBgDark: UIColor {
        return UIColor(hex: "201E1E")
    }

    open class var pegasusGreen: UIColor {
        return UIColor(hex: "22ff36")
    }

    open class var pegasusBlue: UIColor {
        return UIColor(hex: "0A8FFE")
    }

    open class var pegasusDarkGray: UIColor {
        return UIColor(hex: "686868")
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
