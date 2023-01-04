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
    let settingsArr = ["Login", "Language", "Currency", "Logout", "About"]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).activate()
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).activate()
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).activate()
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).activate()
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
        settingLabel.numberOfLines = 0
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
        cell.settingLabel.textColor = .black
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Zen.shared.auth()
            // add small notification saying logged in
        case 1:
            print("Add language setting")
        case 2:
            print("Add currency setting")
        case 3:
            Zen.shared.logout()
            // add small notification saying logged out
        case 4:
            print("Add about setting")
        default:
            print("No such setting")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
