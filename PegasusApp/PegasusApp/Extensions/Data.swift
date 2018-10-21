//
//  Data.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 18/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

extension Data {
    var jsonObject: [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) {
            return json as? [String: Any]
        }
        return nil
    }

    var jsonArray: [[String: Any]]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) {
            return json as? [[String: Any]]
        }
        return nil
    }

    var string: String? {
        return String(data: self, encoding: .utf8)
    }
}
