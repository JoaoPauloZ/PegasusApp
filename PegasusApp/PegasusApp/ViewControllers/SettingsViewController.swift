//
//  SettingsViewController.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 12/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private var collectionView: TPKeyboardAvoidingCollectionView!
    private lazy var flowLayout = UICollectionViewFlowLayout()

    var client: UDPClient?
    var preferences: [MotorPreference] = []

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(_ client: UDPClient?) {
        super.init(nibName: nil, bundle: nil)
        self.client = client
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bgImage = UIImage(named: "spiration-dark") {
            view.backgroundColor = UIColor(patternImage: bgImage)
        } else {
            view.backgroundColor = .lightGray
        }

        setupNavigationBar()
        addCollectionView()
        loadLocalPreferences()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = self.view.bounds.width
        flowLayout.itemSize = CGSize(width: w * 0.88, height: w * 0.6)
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Settings"
        let appearence = UINavigationBar.appearance()
        appearence.shadowImage = UIImage()
        appearence.tintColor = .white
        appearence.barTintColor = UIColor(patternImage: UIImage(named: "spiration-dark")!)
        appearence.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        appearence.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        appearence.prefersLargeTitles = true
        appearence.isTranslucent = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_save")?.withRenderingMode(.alwaysTemplate),
                                                            style: .done, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate),
                                                           style: .done, target: self, action: #selector(dismissVC))
    }

    private func addCollectionView() {
        flowLayout.minimumLineSpacing = 30
        flowLayout.minimumInteritemSpacing = 30
        collectionView = TPKeyboardAvoidingCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MotorSettingsCell.self, forCellWithReuseIdentifier: MotorSettingsCell.reuseId)
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 20, right: 10)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }

    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferences.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MotorSettingsCell.reuseId, for: indexPath) as? MotorSettingsCell
        cell?.motorIndex = indexPath.row
        cell?.motorPref = preferences[indexPath.row]
        cell?.delegate = self
        return cell ?? MotorSettingsCell()
    }

}

extension SettingsViewController {

    private func loadLocalPreferences() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "motorsPreferences") {
            if let dicArray = data.jsonArray {
                preferences = dicArray.map { dic -> MotorPreference in
                    return MotorPreference(dic)
                }
            }
        } else {
            preferences.append(MotorPreference())
            preferences.append(MotorPreference())
            preferences.append(MotorPreference())
            preferences.append(MotorPreference())
        }
    }

    private func saveLocalPreferences() {
        let dicArray = preferences.map { motorPref -> [String: Any] in
            return motorPref.json
        }
        if let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "motorsPreferences")
        }
    }

    @objc private func save() {
        saveLocalPreferences()
        let alert = UIAlertController(title: "Salvar", message: "Deseja salvar as preferências?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { _ in

        }))
        alert.addAction(UIAlertAction(title: "Salvar", style: .default, handler: { _ in
            self.saveLocalPreferences()
            self.sendToDrone()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func sendToDrone() {
        var comands = "U"
        comands += preferences.map { pref -> String in
            var values = ""
            values += String(pref.increaseValue)
            values += ";"
            values += String(pref.minAngleESC)
            values += ";"
            values += String(pref.maxAngleESC)
            values += ";&"
            return values
        }.joined()
        print(comands)
        guard let client = self.client else {
            let alert = UIAlertController(title: "Pegasus", message: "As preferências foram salvas localmente, mas não foram enviadas  ao drone. Por favor reconecte-se ao drone e tente novamente.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let result = client.send(data: comands.data(using: .utf8) ?? Data())
        print("Sended: \(result.isSuccess)")
    }

}

extension SettingsViewController: MotorSettingsCellDelegate {
    func update(_ preference: MotorPreference, forMotorAt index: Int) {
        self.preferences[index] = preference
    }
}

// MARK: UI Interface Orientation
extension UINavigationController {

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override open var prefersStatusBarHidden: Bool {
        return false
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override open var shouldAutorotate: Bool {
        return true
    }
}
