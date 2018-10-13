//
//  SettingsViewController.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 12/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bgImage = UIImage(named: "spiration-dark") {
            view.backgroundColor = UIColor(patternImage: bgImage)
        } else {
            view.backgroundColor = .lightGray
        }

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
}

// MARK: UI Interface Orientation
extension SettingsViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
