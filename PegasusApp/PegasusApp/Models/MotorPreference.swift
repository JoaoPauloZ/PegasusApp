//
//  MotorPreference.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 18/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

class MotorPreference {

    lazy var minAngleESC: Int = 65
    lazy var maxAngleESC: Int = 179
    lazy var increaseValue: Int = 0

    var json: [String: Any] {
        var json = [String: Any]()
        json["minAngleESC"] = self.minAngleESC
        json["maxAngleESC"] = self.maxAngleESC
        json["increaseValue"] = self.increaseValue
        return json
    }

    init() {

    }

    init(_ dic: [String: Any]) {
        minAngleESC = dic["minAngleESC"] as? Int ?? 65
        maxAngleESC = dic["maxAngleESC"] as? Int ?? 179
        increaseValue = dic["increaseValue"] as? Int ?? 0
    }

}
