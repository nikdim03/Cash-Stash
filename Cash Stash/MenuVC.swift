//
//  MenuVC.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/27/22.
//

import UIKit

class MenuVC: UITabBarController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
        super.title = "OVERVIEW"
        view.backgroundColor = .lightGray
        tabBar.tintColor = .systemBlue
        let tranRouter = TranRouter.start()
        let transactionsVC = tranRouter.entry! as UIViewController
        transactionsVC.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(named: "chart.line.uptrend.xyaxis"), selectedImage: nil)
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "gearshape"), selectedImage: nil)
        viewControllers = [transactionsVC, settingsVC]
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Overview" {
            super.title = "OVERVIEW"
        } else {
            super.title = "SETTINGS"
        }
    }
}
