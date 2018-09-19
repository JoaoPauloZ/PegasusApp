//
//  FloatingPoint.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 18/09/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
