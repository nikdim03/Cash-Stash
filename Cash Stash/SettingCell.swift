//
//  SettingCell.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import UIKit

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
