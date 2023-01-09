//
//  LaunchScreenVC.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import UIKit

class LaunchScreenVC: UIViewController {
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    let sloganTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    let appNameTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    
    func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    func getGradientLayerForSlogan(bounds : CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(red: 103/255, green: 97/255, blue: 244/255, alpha: 1).cgColor, UIColor(red: 58/255, green: 237/255, blue: 237/255, alpha: 1).cgColor, UIColor(red: 237/255, green: 93/255, blue: 240/255, alpha: 1).cgColor]
        gradient.locations = [0, 0.4, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }
    
    func getGradientLayerForName(bounds : CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(red: 255/255, green: 87/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 32/255, green: 224/255, blue: 223/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 91/255, blue: 225/255, alpha: 1).cgColor]
        gradient.locations = [0.5, 0.6, 0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        logoImageView.alpha = 0
        logoImageView.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        logoImageView.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        view.addSubview(logoImageView)
        
        appNameTextView.backgroundColor = .clear
        appNameTextView.alpha = 0
        appNameTextView.font = UIFont.boldSystemFont(ofSize:60)
        appNameTextView.textAlignment = .center
        appNameTextView.text = "CASH STASH"
        appNameTextView.center = CGPoint(x: view.center.x, y: view.center.y + 400)
        let gradient2 = getGradientLayerForName(bounds: appNameTextView.bounds)
        appNameTextView.textColor = gradientColor(bounds: appNameTextView.bounds, gradientLayer: gradient2)
        view.addSubview(appNameTextView)
        
        sloganTextView.backgroundColor = .clear
        sloganTextView.alpha = 0
        sloganTextView.font = UIFont.boldSystemFont(ofSize:50)
        sloganTextView.textAlignment = .center
        sloganTextView.text = "Save More\nSpend Less!"
        sloganTextView.center = CGPoint(x: view.center.x, y: view.center.y + 480)
        let gradient1 = getGradientLayerForSlogan(bounds: sloganTextView.bounds)
        sloganTextView.textColor = gradientColor(bounds: sloganTextView.bounds, gradientLayer: gradient1)
        view.addSubview(sloganTextView)
        
        UIView.animate(withDuration: 1, animations: {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.appNameTextView.alpha = 1
            self.appNameTextView.transform = CGAffineTransform(translationX: 0, y: -120)
        })
        
        UIView.animate(withDuration: 0.7, delay: 1, options: [], animations: {
            self.sloganTextView.alpha = 1
            self.sloganTextView.transform = CGAffineTransform(translationX: 0, y: -120)
        }, completion: nil)
    }
}
