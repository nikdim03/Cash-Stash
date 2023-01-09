//
//  MenuTabBar.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/27/22.
//

import UIKit

class MenuVC: UITabBarController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
        super.title = "OVERVIEW"
        createGradientBackground()
        tabBar.tintColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1.00)
        let tranRouter = TranRouter.start()
        let statRouter = StatRouter.start()
        let settRouter = SettRouter.start()
        let tranView = tranRouter.entry! as UIViewController
        tranView.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(named: "chart.line.uptrend.xyaxis"), selectedImage: nil)
        let statView = statRouter.entry! as UIViewController
        statView.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(named: "chart.bar"), selectedImage: nil)
        let settView = settRouter.entry! as UIViewController
        settView.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "gearshape"), selectedImage: nil)
        viewControllers = [tranView, statView, settView]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Overview" {
            super.title = "OVERVIEW"
        } else if item.title == "Statistics" {
            super.title = "STATISTICS"
        } else {
            super.title = "SETTINGS"
        }
    }
    
    func createGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 103/255, green: 97/255, blue: 244/255, alpha: 1).cgColor, UIColor(red: 58/255, green: 237/255, blue: 237/255, alpha: 1).cgColor, UIColor(red: 237/255, green: 93/255, blue: 240/255, alpha: 1).cgColor]
        gradient.locations = [0, 0.4, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
}
