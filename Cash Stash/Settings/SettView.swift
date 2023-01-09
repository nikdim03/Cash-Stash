//
//  SettView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import UIKit

//view controller
//protocol
//ref to presenter

//MARK: - SettView
protocol SettViewProtocol {
    var presenter: SettPresenterProtocol? { get set }
}

class SettView: UIViewController, SettViewProtocol {
    var presenter: SettPresenterProtocol?
    @UsesAutoLayout
    var tableView = UITableView()
    let settingsArr = ["Login with ZenMoney", "Language", "Currency", "Logout", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.rowHeight = 50
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).activate()
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).activate()
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).activate()
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).activate()
    }
        
    func showLogin() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let aboutAction = UIAlertAction(title: "Log In", style: .default) { (_) in
            Zen.shared.auth()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(aboutAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let aboutAction = UIAlertAction(title: "Log Out", style: .default) { (_) in
            Zen.shared.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(aboutAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showLanguage() {
        let alertController = UIAlertController(title: "Извинение", message: "Здесь могли были быть языковые настройки, но автор обленился и оставил всё на последний момент!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showCurrency() {
        let alertController = UIAlertController(title: "Извинение", message: "Здесь могли были быть настройки валюты, но автор обленился и оставил всё на последний момент!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAbout() {
        let aboutView = AboutView(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
        aboutView.center = view.center
        aboutView.alpha = 0
        DispatchQueue.main.async {
            self.view.addSubview(aboutView)
            UIView.animate(withDuration: 0.3) {
                aboutView.alpha = 1
            }
        }
    }
}


//MARK: - AboutView
class AboutView: UIView {
    let gradientLayer = CAGradientLayer()
    let appNameLabel = UILabel()
    let versionLabel = UILabel()
    let buildLabel = UILabel()
    let createdByLabel = UILabel()
    let developerContactLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Set up the gradient layer
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor(red: 103/255, green: 97/255, blue: 244/255, alpha: 1).cgColor, UIColor(red: 58/255, green: 237/255, blue: 237/255, alpha: 1).cgColor, UIColor(red: 237/255, green: 93/255, blue: 240/255, alpha: 1).cgColor]
        gradientLayer.locations = [0, 0.4, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        layer.addSublayer(gradientLayer)
        
        // Set up the app name label
        appNameLabel.text = "Cash Stash"
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        appNameLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        addSubview(appNameLabel)
        
        // Set up the version label
        versionLabel.text = "Version 1.0"
        versionLabel.font = UIFont.systemFont(ofSize: 18.0)
        versionLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        addSubview(versionLabel)
        
        // Set up the build label
        buildLabel.text = "Build Version 1.0"
        buildLabel.font = UIFont.systemFont(ofSize: 18.0)
        buildLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        addSubview(buildLabel)
        
        // Set up the created by label
        createdByLabel.text = "Created by Dmitriy Nikulin"
        createdByLabel.font = UIFont.systemFont(ofSize: 18.0)
        createdByLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        addSubview(createdByLabel)
        
        // Set up the developer contact label
        developerContactLabel.text = "Contact: nikdim_03@mail.ru"
        developerContactLabel.font = UIFont.systemFont(ofSize: 18.0)
        developerContactLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        addSubview(developerContactLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the frame and corner radius of the gradient layer
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 50
        
        // Layout the labels
        let labelWidth = bounds.width * 0.9
        let labelHeight: CGFloat = 24.0
        let labelSpacing: CGFloat = 8.0
        let y = (bounds.height - (labelHeight * 5.0) - (labelSpacing * 4.0)) / 2.0
        let x = (bounds.width - labelWidth) / 2.0
        appNameLabel.frame = CGRect(x: x, y: y, width: labelWidth, height: labelHeight)
        versionLabel.frame = CGRect(x: x, y: y + labelHeight + labelSpacing, width: labelWidth, height: labelHeight)
        buildLabel.frame = CGRect(x: x, y: y + (labelHeight + labelSpacing) * 2.0, width: labelWidth, height: labelHeight)
        createdByLabel.frame = CGRect(x: x, y: y + (labelHeight + labelSpacing) * 3.0, width: labelWidth, height: labelHeight)
        developerContactLabel.frame = CGRect(x: x, y: y + (labelHeight + labelSpacing) * 4.0, width: labelWidth, height: labelHeight)
    }
    
    override func didMoveToSuperview() {
      super.didMoveToSuperview()
      // Add the tap gesture recognizer to the view
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      tapGestureRecognizer.cancelsTouchesInView = true
      addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}


//MARK: - SettingCell
class SettingCell: UITableViewCell {
    @UsesAutoLayout
    var settingLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(settingLabel)
        configureSettingLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSettingLabel() {
        settingLabel.font = .boldSystemFont(ofSize: 20)
        settingLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).activate()
        settingLabel.heightAnchor.constraint(equalToConstant: 80).activate()
        settingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20).activate()
    }
}


//MARK: - SettView Extensions
extension SettView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        cell.settingLabel.text = settingsArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showLogin()
            // add small notification saying logged in
        case 1:
            showLanguage()
            print("Add language setting")
        case 2:
            showCurrency()
            print("Add currency setting")
        case 3:
            showLogout()
            // add small notification saying logged out
        case 4:
            showAbout()
        default:
            print("Error: No such setting")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
